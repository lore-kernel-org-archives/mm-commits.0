From: akpm@linux-foundation.org
Subject: + thp-huge-zero-page-basic-preparation.patch added to -mm tree
Date: Wed, 14 Nov 2012 13:34:04 -0800
Message-ID: <20121114213404.A2074100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:37957 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423455Ab2KNVeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 16:34:07 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so96660yhl.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 13:34:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     Subject: thp: huge zero page: basic preparation
has been added to the -mm tree.  Its filename is
     thp-huge-zero-page-basic-preparation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: huge zero page: basic preparation

During testing I noticed big (up to 2.5 times) memory consumption overhead
on some workloads (e.g.  ft.A from NPB) if THP is enabled.

The main reason for that big difference is lacking zero page in THP case. 
We have to allocate a real page on read page fault.

A program to demonstrate the issue:
#include <assert.h>
#include <stdlib.h>
#include <unistd.h>

#define MB 1024*1024

int main(int argc, char **argv)
{
        char *p;
        int i;

        posix_memalign((void **)&p, 2 * MB, 200 * MB);
        for (i = 0; i < 200 * MB; i+= 4096)
                assert(p[i] == 0);
        pause();
        return 0;
}

With thp-never RSS is about 400k, but with thp-always it's 200M.  After
the patcheset thp-always RSS is 400k too.

Design overview.

Huge zero page (hzp) is a non-movable huge page (2M on x86-64) filled with
zeros.  The way how we allocate it changes in the patchset:

- [01/10] simplest way: hzp allocated on boot time in hugepage_init();
- [09/10] lazy allocation on first use;
- [10/10] lockless refcounting + shrinker-reclaimable hzp;

We setup it in do_huge_pmd_anonymous_page() if area around fault address
is suitable for THP and we've got read page fault.  If we fail to setup
hzp (ENOMEM) we fallback to handle_pte_fault() as we normally do in THP.

On wp fault to hzp we allocate real memory for the huge page and clear it.
 If ENOMEM, graceful fallback: we create a new pmd table and set pte
around fault address to newly allocated normal (4k) page.  All other ptes
in the pmd set to normal zero page.

We cannot split hzp (and it's bug if we try), but we can split the pmd
which points to it.  On splitting the pmd we create a table with all ptes
set to normal zero page.

Patchset organized in bisect-friendly way:
 Patches 01-07: prepare all code paths for hzp
 Patch 08: all code paths are covered: safe to setup hzp
 Patch 09: lazy allocation
 Patch 10: lockless refcounting for hzp

v5:
 - implement HZP_ALLOC and HZP_ALLOC_FAILED events;
v4:
 - Rebase to v3.7-rc1;
 - Update commit message;
v3:
 - fix potential deadlock in refcounting code on preemptive kernel.
 - do not mark huge zero page as movable.
 - fix typo in comment.
 - Reviewed-by tag from Andrea Arcangeli.
v2:
 - Avoid find_vma() if we've already had vma on stack.
   Suggested by Andrea Arcangeli.
 - Implement refcounting for huge zero page.

--------------------------------------------------------------------------

By hpa's request I've tried alternative approach for hzp implementation
(see Virtual huge zero page patchset): pmd table with all entries set to
zero page.  This way should be more cache friendly, but it increases TLB
pressure.

The problem with virtual huge zero page: it requires per-arch enabling. 
We need a way to mark that pmd table has all ptes set to zero page.

Some numbers to compare two implementations (on 4s Westmere-EX):

Mirobenchmark1
==============

test:
        posix_memalign((void **)&p, 2 * MB, 8 * GB);
        for (i = 0; i < 100; i++) {
                assert(memcmp(p, p + 4*GB, 4*GB) == 0);
                asm volatile ("": : :"memory");
        }

hzp:
 Performance counter stats for './test_memcmp' (5 runs):

      32356.272845 task-clock                #    0.998 CPUs utilized            ( +-  0.13% )
                40 context-switches          #    0.001 K/sec                    ( +-  0.94% )
                 0 CPU-migrations            #    0.000 K/sec
             4,218 page-faults               #    0.130 K/sec                    ( +-  0.00% )
    76,712,481,765 cycles                    #    2.371 GHz                      ( +-  0.13% ) [83.31%]
    36,279,577,636 stalled-cycles-frontend   #   47.29% frontend cycles idle     ( +-  0.28% ) [83.35%]
     1,684,049,110 stalled-cycles-backend    #    2.20% backend  cycles idle     ( +-  2.96% ) [66.67%]
   134,355,715,816 instructions              #    1.75  insns per cycle
                                             #    0.27  stalled cycles per insn  ( +-  0.10% ) [83.35%]
    13,526,169,702 branches                  #  418.039 M/sec                    ( +-  0.10% ) [83.31%]
         1,058,230 branch-misses             #    0.01% of all branches          ( +-  0.91% ) [83.36%]

      32.413866442 seconds time elapsed                                          ( +-  0.13% )

vhzp:
 Performance counter stats for './test_memcmp' (5 runs):

      30327.183829 task-clock                #    0.998 CPUs utilized            ( +-  0.13% )
                38 context-switches          #    0.001 K/sec                    ( +-  1.53% )
                 0 CPU-migrations            #    0.000 K/sec
             4,218 page-faults               #    0.139 K/sec                    ( +-  0.01% )
    71,964,773,660 cycles                    #    2.373 GHz                      ( +-  0.13% ) [83.35%]
    31,191,284,231 stalled-cycles-frontend   #   43.34% frontend cycles idle     ( +-  0.40% ) [83.32%]
       773,484,474 stalled-cycles-backend    #    1.07% backend  cycles idle     ( +-  6.61% ) [66.67%]
   134,982,215,437 instructions              #    1.88  insns per cycle
                                             #    0.23  stalled cycles per insn  ( +-  0.11% ) [83.32%]
    13,509,150,683 branches                  #  445.447 M/sec                    ( +-  0.11% ) [83.34%]
         1,017,667 branch-misses             #    0.01% of all branches          ( +-  1.07% ) [83.32%]

      30.381324695 seconds time elapsed                                          ( +-  0.13% )

Mirobenchmark2
==============

test:
        posix_memalign((void **)&p, 2 * MB, 8 * GB);
        for (i = 0; i < 1000; i++) {
                char *_p = p;
                while (_p < p+4*GB) {
                        assert(*_p == *(_p+4*GB));
                        _p += 4096;
                        asm volatile ("": : :"memory");
                }
        }

hzp:
 Performance counter stats for 'taskset -c 0 ./test_memcmp2' (5 runs):

       3505.727639 task-clock                #    0.998 CPUs utilized            ( +-  0.26% )
                 9 context-switches          #    0.003 K/sec                    ( +-  4.97% )
             4,384 page-faults               #    0.001 M/sec                    ( +-  0.00% )
     8,318,482,466 cycles                    #    2.373 GHz                      ( +-  0.26% ) [33.31%]
     5,134,318,786 stalled-cycles-frontend   #   61.72% frontend cycles idle     ( +-  0.42% ) [33.32%]
     2,193,266,208 stalled-cycles-backend    #   26.37% backend  cycles idle     ( +-  5.51% ) [33.33%]
     9,494,670,537 instructions              #    1.14  insns per cycle
                                             #    0.54  stalled cycles per insn  ( +-  0.13% ) [41.68%]
     2,108,522,738 branches                  #  601.451 M/sec                    ( +-  0.09% ) [41.68%]
           158,746 branch-misses             #    0.01% of all branches          ( +-  1.60% ) [41.71%]
     3,168,102,115 L1-dcache-loads
          #  903.693 M/sec                    ( +-  0.11% ) [41.70%]
     1,048,710,998 L1-dcache-misses
         #   33.10% of all L1-dcache hits    ( +-  0.11% ) [41.72%]
     1,047,699,685 LLC-load
                 #  298.854 M/sec                    ( +-  0.03% ) [33.38%]
             2,287 LLC-misses
               #    0.00% of all LL-cache hits     ( +-  8.27% ) [33.37%]
     3,166,187,367 dTLB-loads
               #  903.147 M/sec                    ( +-  0.02% ) [33.35%]
         4,266,538 dTLB-misses
              #    0.13% of all dTLB cache hits   ( +-  0.03% ) [33.33%]

       3.513339813 seconds time elapsed                                          ( +-  0.26% )

vhzp:
 Performance counter stats for 'taskset -c 0 ./test_memcmp2' (5 runs):

      27313.891128 task-clock                #    0.998 CPUs utilized            ( +-  0.24% )
                62 context-switches          #    0.002 K/sec                    ( +-  0.61% )
             4,384 page-faults               #    0.160 K/sec                    ( +-  0.01% )
    64,747,374,606 cycles                    #    2.370 GHz                      ( +-  0.24% ) [33.33%]
    61,341,580,278 stalled-cycles-frontend   #   94.74% frontend cycles idle     ( +-  0.26% ) [33.33%]
    56,702,237,511 stalled-cycles-backend    #   87.57% backend  cycles idle     ( +-  0.07% ) [33.33%]
    10,033,724,846 instructions              #    0.15  insns per cycle
                                             #    6.11  stalled cycles per insn  ( +-  0.09% ) [41.65%]
     2,190,424,932 branches                  #   80.195 M/sec                    ( +-  0.12% ) [41.66%]
         1,028,630 branch-misses             #    0.05% of all branches          ( +-  1.50% ) [41.66%]
     3,302,006,540 L1-dcache-loads
          #  120.891 M/sec                    ( +-  0.11% ) [41.68%]
       271,374,358 L1-dcache-misses
         #    8.22% of all L1-dcache hits    ( +-  0.04% ) [41.66%]
        20,385,476 LLC-load
                 #    0.746 M/sec                    ( +-  1.64% ) [33.34%]
            76,754 LLC-misses
               #    0.38% of all LL-cache hits     ( +-  2.35% ) [33.34%]
     3,309,927,290 dTLB-loads
               #  121.181 M/sec                    ( +-  0.03% ) [33.34%]
     2,098,967,427 dTLB-misses
              #   63.41% of all dTLB cache hits   ( +-  0.03% ) [33.34%]

      27.364448741 seconds time elapsed                                          ( +-  0.24% )

--------------------------------------------------------------------------

I personally prefer implementation present in this patchset. It doesn't
touch arch-specific code.



This patch:

Huge zero page (hzp) is a non-movable huge page (2M on x86-64) filled with
zeros.

For now let's allocate the page on hugepage_init().  We'll switch to lazy
allocation later.

We are not going to map the huge zero page until we can handle it properly
on all code paths.

is_huge_zero_{pfn,pmd}() functions will be used by following patches to
check whether the pfn/pmd is huge zero page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN mm/huge_memory.c~thp-huge-zero-page-basic-preparation mm/huge_memory.c
--- a/mm/huge_memory.c~thp-huge-zero-page-basic-preparation
+++ a/mm/huge_memory.c
@@ -48,6 +48,7 @@ static unsigned int khugepaged_scan_slee
 /* during fragmentation poll the hugepage allocator once every minute */
 static unsigned int khugepaged_alloc_sleep_millisecs __read_mostly = 60000;
 static struct task_struct *khugepaged_thread __read_mostly;
+static unsigned long huge_zero_pfn __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);
 static DEFINE_SPINLOCK(khugepaged_mm_lock);
 static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
@@ -160,6 +161,29 @@ static int start_khugepaged(void)
 	return err;
 }
 
+static int init_huge_zero_page(void)
+{
+	struct page *hpage;
+
+	hpage = alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
+			HPAGE_PMD_ORDER);
+	if (!hpage)
+		return -ENOMEM;
+
+	huge_zero_pfn = page_to_pfn(hpage);
+	return 0;
+}
+
+static inline bool is_huge_zero_pfn(unsigned long pfn)
+{
+	return pfn == huge_zero_pfn;
+}
+
+static inline bool is_huge_zero_pmd(pmd_t pmd)
+{
+	return is_huge_zero_pfn(pmd_pfn(pmd));
+}
+
 #ifdef CONFIG_SYSFS
 
 static ssize_t double_flag_show(struct kobject *kobj,
@@ -541,6 +565,10 @@ static int __init hugepage_init(void)
 	if (err)
 		return err;
 
+	err = init_huge_zero_page();
+	if (err)
+		goto out;
+
 	err = khugepaged_slab_init();
 	if (err)
 		goto out;
@@ -563,6 +591,8 @@ static int __init hugepage_init(void)
 
 	return 0;
 out:
+	if (huge_zero_pfn)
+		__free_page(pfn_to_page(huge_zero_pfn));
 	hugepage_exit_sysfs(hugepage_kobj);
 	return err;
 }
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

linux-next.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-huge-zero-page-basic-preparation.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-change_huge_pmd-keep-huge-zero-page-write-protected.patch
thp-change-split_huge_page_pmd-interface.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch

