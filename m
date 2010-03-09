From: akpm@linux-foundation.org
Subject: [merged] mm-fix-mbind-vma-merge-problem.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:41 -0800
Message-ID: <201003091903.o29J3gDx030982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755822Ab0CITEZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:04:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, aarcange@redhat.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, minchan.kim@gmail.com, nickpiggin@yah


The patch titled
     mm: fix mbind vma merge problem
has been removed from the -mm tree.  Its filename was
     mm-fix-mbind-vma-merge-problem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix mbind vma merge problem
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Strangely, current mbind() doesn't merge vma with neighbor vma although it's possible.
Unfortunately, many vma can reduce performance...

This patch fixes it.

    reproduced program
    ----------------------------------------------------------------
     #include <numaif.h>
     #include <numa.h>
     #include <sys/mman.h>
     #include <stdio.h>
     #include <unistd.h>
     #include <stdlib.h>
     #include <string.h>

    static unsigned long pagesize;

    int main(int argc, char** argv)
    {
    	void* addr;
    	int ch;
    	int node;
    	struct bitmask *nmask = numa_allocate_nodemask();
    	int err;
    	int node_set = 0;
    	char buf[128];

    	while ((ch = getopt(argc, argv, "n:")) != -1){
    		switch (ch){
    		case 'n':
    			node = strtol(optarg, NULL, 0);
    			numa_bitmask_setbit(nmask, node);
    			node_set = 1;
    			break;
    		default:
    			;
    		}
    	}
    	argc -= optind;
    	argv += optind;

    	if (!node_set)
    		numa_bitmask_setbit(nmask, 0);

    	pagesize = getpagesize();

    	addr = mmap(NULL, pagesize*3, PROT_READ|PROT_WRITE,
    		    MAP_ANON|MAP_PRIVATE, 0, 0);
    	if (addr == MAP_FAILED)
    		perror("mmap "), exit(1);

    	fprintf(stderr, "pid = %d \n" "addr = %p\n", getpid(), addr);

    	/* make page populate */
    	memset(addr, 0, pagesize*3);

    	/* first mbind */
    	err = mbind(addr+pagesize, pagesize, MPOL_BIND, nmask->maskp,
    		    nmask->size, MPOL_MF_MOVE_ALL);
    	if (err)
    		error("mbind1 ");

    	/* second mbind */
    	err = mbind(addr, pagesize*3, MPOL_DEFAULT, NULL, 0, 0);
    	if (err)
    		error("mbind2 ");

    	sprintf(buf, "cat /proc/%d/maps", getpid());
    	system(buf);

    	return 0;
    }
    ----------------------------------------------------------------

result without this patch

	addr = 0x7fe26ef09000
	[snip]
	7fe26ef09000-7fe26ef0a000 rw-p 00000000 00:00 0
	7fe26ef0a000-7fe26ef0b000 rw-p 00000000 00:00 0
	7fe26ef0b000-7fe26ef0c000 rw-p 00000000 00:00 0
	7fe26ef0c000-7fe26ef0d000 rw-p 00000000 00:00 0

	=> 0x7fe26ef09000-0x7fe26ef0c000 have three vmas.

result with this patch

	addr = 0x7fc9ebc76000
	[snip]
	7fc9ebc76000-7fc9ebc7a000 rw-p 00000000 00:00 0
	7fffbe690000-7fffbe6a5000 rw-p 00000000	00:00 0	[stack]

	=> 0x7fc9ebc76000-0x7fc9ebc7a000 have only one vma.

[minchan.kim@gmail.com: fix file offset passed to vma_merge()]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   52 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff -puN mm/mempolicy.c~mm-fix-mbind-vma-merge-problem mm/mempolicy.c
--- a/mm/mempolicy.c~mm-fix-mbind-vma-merge-problem
+++ a/mm/mempolicy.c
@@ -563,24 +563,50 @@ static int policy_vma(struct vm_area_str
 }
 
 /* Step 2: apply policy to a range and do splits. */
-static int mbind_range(struct vm_area_struct *vma, unsigned long start,
-		       unsigned long end, struct mempolicy *new)
+static int mbind_range(struct mm_struct *mm, unsigned long start,
+		       unsigned long end, struct mempolicy *new_pol)
 {
 	struct vm_area_struct *next;
-	int err;
+	struct vm_area_struct *prev;
+	struct vm_area_struct *vma;
+	int err = 0;
+	pgoff_t pgoff;
+	unsigned long vmstart;
+	unsigned long vmend;
 
-	err = 0;
-	for (; vma && vma->vm_start < end; vma = next) {
+	vma = find_vma_prev(mm, start, &prev);
+	if (!vma || vma->vm_start > start)
+		return -EFAULT;
+
+	for (; vma && vma->vm_start < end; prev = vma, vma = next) {
 		next = vma->vm_next;
-		if (vma->vm_start < start)
-			err = split_vma(vma->vm_mm, vma, start, 1);
-		if (!err && vma->vm_end > end)
-			err = split_vma(vma->vm_mm, vma, end, 0);
-		if (!err)
-			err = policy_vma(vma, new);
+		vmstart = max(start, vma->vm_start);
+		vmend   = min(end, vma->vm_end);
+
+		pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
+		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
+				  vma->anon_vma, vma->vm_file, pgoff, new_pol);
+		if (prev) {
+			vma = prev;
+			next = vma->vm_next;
+			continue;
+		}
+		if (vma->vm_start != vmstart) {
+			err = split_vma(vma->vm_mm, vma, vmstart, 1);
+			if (err)
+				goto out;
+		}
+		if (vma->vm_end != vmend) {
+			err = split_vma(vma->vm_mm, vma, vmend, 0);
+			if (err)
+				goto out;
+		}
+		err = policy_vma(vma, new_pol);
 		if (err)
-			break;
+			goto out;
 	}
+
+ out:
 	return err;
 }
 
@@ -1047,7 +1073,7 @@ static long do_mbind(unsigned long start
 	if (!IS_ERR(vma)) {
 		int nr_failed = 0;
 
-		err = mbind_range(vma, start, end, new);
+		err = mbind_range(mm, start, end, new);
 
 		if (!list_empty(&pagelist))
 			nr_failed = migrate_pages(&pagelist, new_vma_page,
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
reiser4.patch

