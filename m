From: akpm@linux-foundation.org
Subject: [merged] mempolicy-refix-mbind_range-vma-issue.patch removed from -mm tree
Date: Tue, 03 Jan 2012 13:35:36 -0800
Message-ID: <20120103213538.08782100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36490 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2ACVfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jan 2012 16:35:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, caspar@casparzhang.com, cl@linux.com, hannes@cmpxchg.org, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, minchan.kim@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: refix mbind_range() vma issue
has been removed from the -mm tree.  Its filename was
     mempolicy-refix-mbind_range-vma-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm/mempolicy.c: refix mbind_range() vma issue

commit 8aacc9f550 ("mm/mempolicy.c: fix pgoff in mbind vma merge") is the
slightly incorrect fix.

Why? Think following case.

1. map 4 pages of a file at offset 0

   [0123]

2. map 2 pages just after the first mapping of the same file but with
   page offset 2

   [0123][23]

3. mbind() 2 pages from the first mapping at offset 2.
   mbind_range() should treat new vma is,

   [0123][23]
     |23|
     mbind vma

   but it does

   [0123][23]
     |01|
     mbind vma

   Oops. then, it makes wrong vma merge and splitting ([01][0123] or similar).

This patch fixes it.

[testcase]
  test result - before the patch

	case4: 126: test failed. expect '2,4', actual '2,2,2'
       	case5: passed
	case6: passed
	case7: passed
	case8: passed
	case_n: 246: test failed. expect '4,2', actual '1,4'

	------------[ cut here ]------------
	kernel BUG at mm/filemap.c:135!
	invalid opcode: 0000 [#4] SMP DEBUG_PAGEALLOC

	(snip long bug on messages)

  test result - after the patch

	case4: passed
       	case5: passed
	case6: passed
	case7: passed
	case8: passed
	case_n: passed

  source:  mbind_vma_test.c
============================================================
 #include <numaif.h>
 #include <numa.h>
 #include <sys/mman.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <stdlib.h>
 #include <string.h>

static unsigned long pagesize;
void* mmap_addr;
struct bitmask *nmask;
char buf[1024];
FILE *file;
char retbuf[10240] = "";
int mapped_fd;

char *rubysrc = "ruby -e '\
  pid = %d; \
  vstart = 0x%llx; \
  vend = 0x%llx; \
  s = `pmap -q #{pid}`; \
  rary = []; \
  s.each_line {|line|; \
    ary=line.split(\" \"); \
    addr = ary[0].to_i(16); \
    if(vstart <= addr && addr < vend) then \
      rary.push(ary[1].to_i()/4); \
    end; \
  }; \
  print rary.join(\",\"); \
'";

void init(void)
{
	void* addr;
	char buf[128];

	nmask = numa_allocate_nodemask();
	numa_bitmask_setbit(nmask, 0);

	pagesize = getpagesize();

	sprintf(buf, "%s", "mbind_vma_XXXXXX");
	mapped_fd = mkstemp(buf);
	if (mapped_fd == -1)
		perror("mkstemp "), exit(1);
	unlink(buf);

	if (lseek(mapped_fd, pagesize*8, SEEK_SET) < 0)
		perror("lseek "), exit(1);
	if (write(mapped_fd, "\0", 1) < 0)
		perror("write "), exit(1);

	addr = mmap(NULL, pagesize*8, PROT_NONE,
		    MAP_SHARED, mapped_fd, 0);
	if (addr == MAP_FAILED)
		perror("mmap "), exit(1);

	if (mprotect(addr+pagesize, pagesize*6, PROT_READ|PROT_WRITE) < 0)
		perror("mprotect "), exit(1);

	mmap_addr = addr + pagesize;

	/* make page populate */
	memset(mmap_addr, 0, pagesize*6);
}

void fin(void)
{
	void* addr = mmap_addr - pagesize;
	munmap(addr, pagesize*8);

	memset(buf, 0, sizeof(buf));
	memset(retbuf, 0, sizeof(retbuf));
}

void mem_bind(int index, int len)
{
	int err;

	err = mbind(mmap_addr+pagesize*index, pagesize*len,
		    MPOL_BIND, nmask->maskp, nmask->size, 0);
	if (err)
		perror("mbind "), exit(err);
}

void mem_interleave(int index, int len)
{
	int err;

	err = mbind(mmap_addr+pagesize*index, pagesize*len,
		    MPOL_INTERLEAVE, nmask->maskp, nmask->size, 0);
	if (err)
		perror("mbind "), exit(err);
}

void mem_unbind(int index, int len)
{
	int err;

	err = mbind(mmap_addr+pagesize*index, pagesize*len,
		    MPOL_DEFAULT, NULL, 0, 0);
	if (err)
		perror("mbind "), exit(err);
}

void Assert(char *expected, char *value, char *name, int line)
{
	if (strcmp(expected, value) == 0) {
		fprintf(stderr, "%s: passed\n", name);
		return;
	}
	else {
		fprintf(stderr, "%s: %d: test failed. expect '%s', actual '%s'\n",
			name, line,
			expected, value);
//		exit(1);
	}
}

/*
      AAAA
    PPPPPPNNNNNN
    might become
    PPNNNNNNNNNN
    case 4 below
*/
void case4(void)
{
	init();
	sprintf(buf, rubysrc, getpid(), mmap_addr, mmap_addr+pagesize*6);

	mem_bind(0, 4);
	mem_unbind(2, 2);

	file = popen(buf, "r");
	fread(retbuf, sizeof(retbuf), 1, file);
	Assert("2,4", retbuf, "case4", __LINE__);

	fin();
}

/*
       AAAA
 PPPPPPNNNNNN
 might become
 PPPPPPPPPPNN
 case 5 below
*/
void case5(void)
{
	init();
	sprintf(buf, rubysrc, getpid(), mmap_addr, mmap_addr+pagesize*6);

	mem_bind(0, 2);
	mem_bind(2, 2);

	file = popen(buf, "r");
	fread(retbuf, sizeof(retbuf), 1, file);
	Assert("4,2", retbuf, "case5", __LINE__);

	fin();
}

/*
	    AAAA
	PPPPNNNNXXXX
	might become
	PPPPPPPPPPPP 6
*/
void case6(void)
{
	init();
	sprintf(buf, rubysrc, getpid(), mmap_addr, mmap_addr+pagesize*6);

	mem_bind(0, 2);
	mem_bind(4, 2);
	mem_bind(2, 2);

	file = popen(buf, "r");
	fread(retbuf, sizeof(retbuf), 1, file);
	Assert("6", retbuf, "case6", __LINE__);

	fin();
}

/*
    AAAA
PPPPNNNNXXXX
might become
PPPPPPPPXXXX 7
*/
void case7(void)
{
	init();
	sprintf(buf, rubysrc, getpid(), mmap_addr, mmap_addr+pagesize*6);

	mem_bind(0, 2);
	mem_interleave(4, 2);
	mem_bind(2, 2);

	file = popen(buf, "r");
	fread(retbuf, sizeof(retbuf), 1, file);
	Assert("4,2", retbuf, "case7", __LINE__);

	fin();
}

/*
    AAAA
PPPPNNNNXXXX
might become
PPPPNNNNNNNN 8
*/
void case8(void)
{
	init();
	sprintf(buf, rubysrc, getpid(), mmap_addr, mmap_addr+pagesize*6);

	mem_bind(0, 2);
	mem_interleave(4, 2);
	mem_interleave(2, 2);

	file = popen(buf, "r");
	fread(retbuf, sizeof(retbuf), 1, file);
	Assert("2,4", retbuf, "case8", __LINE__);

	fin();
}

void case_n(void)
{
	init();
	sprintf(buf, rubysrc, getpid(), mmap_addr, mmap_addr+pagesize*6);

	/* make redundunt mappings [0][1234][34][7] */
	mmap(mmap_addr + pagesize*4, pagesize*2, PROT_READ|PROT_WRITE,
	     MAP_FIXED|MAP_SHARED, mapped_fd, pagesize*3);

	/* Expect to do nothing. */
	mem_unbind(2, 2);

	file = popen(buf, "r");
	fread(retbuf, sizeof(retbuf), 1, file);
	Assert("4,2", retbuf, "case_n", __LINE__);

	fin();
}

int main(int argc, char** argv)
{
	case4();
	case5();
	case6();
	case7();
	case8();
	case_n();

	return 0;
}
=============================================================

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Caspar Zhang <caspar@casparzhang.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: <stable@vger.kernel.org>		[3.1.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mempolicy-refix-mbind_range-vma-issue mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-refix-mbind_range-vma-issue
+++ a/mm/mempolicy.c
@@ -636,6 +636,7 @@ static int mbind_range(struct mm_struct 
 	struct vm_area_struct *prev;
 	struct vm_area_struct *vma;
 	int err = 0;
+	pgoff_t pgoff;
 	unsigned long vmstart;
 	unsigned long vmend;
 
@@ -643,13 +644,21 @@ static int mbind_range(struct mm_struct 
 	if (!vma || vma->vm_start > start)
 		return -EFAULT;
 
+	if (start > vma->vm_start)
+		prev = vma;
+
 	for (; vma && vma->vm_start < end; prev = vma, vma = next) {
 		next = vma->vm_next;
 		vmstart = max(start, vma->vm_start);
 		vmend   = min(end, vma->vm_end);
 
+		if (mpol_equal(vma_policy(vma), new_pol))
+			continue;
+
+		pgoff = vma->vm_pgoff +
+			((vmstart - vma->vm_start) >> PAGE_SHIFT);
 		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
-				  vma->anon_vma, vma->vm_file, vma->vm_pgoff,
+				  vma->anon_vma, vma->vm_file, pgoff,
 				  new_pol);
 		if (prev) {
 			vma = prev;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
mm-simplify-find_vma_prev.patch
mm-simplify-find_vma_prev-fix.patch
mm-simplify-find_vma_prev-fix-2.patch
tracepoint-add-tracepoints-for-debugging-oom_score_adj.patch
mm-vmscanc-consider-swap-space-when-deciding-whether-to-continue-reclaim.patch
mm-mempolicyc-mpol_equal-use-bool.patch
mm-test-pageswapbacked-in-lumpy-reclaim.patch
mm-vmscan-fix-typo-in-isolating-lru-pages.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch
mm-take-pagevecs-off-reclaim-stack.patch
kexec-remove-kmsg_dump_kexec.patch
ipc-mqueue-simplify-reading-msgqueue-limit.patch

