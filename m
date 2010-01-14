From: akpm@linux-foundation.org
Subject: + mm-fix-mbind-vma-merge-problem.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:26:39 -0800
Message-ID: <201001142326.o0ENQd3T006068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358Ab0ANX2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:28:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, aarcange@redhat.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au


The patch titled
     mm: fix mbind vma merge problem
has been added to the -mm tree.  Its filename is
     mm-fix-mbind-vma-merge-problem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   51 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff -puN mm/mempolicy.c~mm-fix-mbind-vma-merge-problem mm/mempolicy.c
--- a/mm/mempolicy.c~mm-fix-mbind-vma-merge-problem
+++ a/mm/mempolicy.c
@@ -563,24 +563,49 @@ static int policy_vma(struct vm_area_str
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
+		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
+				  vma->anon_vma, vma->vm_file, vma->vm_pgoff,
+				  new_pol);
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
 
@@ -1047,7 +1072,7 @@ static long do_mbind(unsigned long start
 	if (!IS_ERR(vma)) {
 		int nr_failed = 0;
 
-		err = mbind_range(vma, start, end, new);
+		err = mbind_range(mm, start, end, new);
 
 		if (!list_empty(&pagelist))
 			nr_failed = migrate_pages(&pagelist, new_vma_page,
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
page-allocator-fix-update-nr_free_pages-only-as-necessary.patch
mm-page_alloc-fix-the-range-check-for-backward-merging.patch
vmscan-kswapd-dont-retry-balance_pgdat-if-all-zones-are-unreclaimable.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
vmscan-get_scan_ratio-cleanup.patch
vmstat-add-anon_scan_ratio-field-to-zoneinfo.patch
memcg-add-anon_scan_ratio-to-memorystat-file.patch
mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-fix-mbind-vma-merge-problem.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

