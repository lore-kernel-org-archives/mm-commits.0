From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 khugepaged-allow-to-collapse-a-page-shared-across-fork-fix.patch added to
 -mm tree
Date: Mon, 18 May 2020 13:25:51 -0700
Message-ID: <20200518202551.W7YxrEYxd%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgERUZx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 16:25:53 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: khugepaged: remove error message when checking external pins
has been added to the -mm tree.  Its filename is
     khugepaged-allow-to-collapse-a-page-shared-across-fork-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-allow-to-collapse-a-page-shared-across-fork-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-allow-to-collapse-a-page-shared-across-fork-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: khugepaged: remove error message when checking external pins

When running khugepaged with higher frequency (for example, set
scan_sleep_millisecs to 0), the below error message was reported:

khugepaged: expected_refcount (1024) > refcount (512)
page:ffffd75784258000 count:511 mapcount:1 mapping:ffff968de06c7421 index:0x7fa288600
 compound_mapcount: 0
 flags: 0x17fffc00009003c(uptodate|dirty|lru|active|head|swapbacked)
 raw: 017fffc00009003c ffffd7578ba70788 ffffd7578bdb5148 ffff968de06c7421
 raw: 00000007fa288600 0000000000000000 000001ff00000000 ffff968e5e7d6000
 page dumped because: Unexpected refcount
 page->mem_cgroup:ffff968e5e7d6000

This is introduced by allowing collapsing fork shared and PTE-mapped
THPs.  The check may run into the below race:

Assuming parent process forked child process, then they do

	CPU A		CPU B			CPU C
	-----		-----			-----
Parent			Child			khugepaged

MADV_DONTNEED
  split huge pmd
  Double mapped
			MADV_DONTNEED
			  zap_huge_pmd
			    remove_page_rmap
			      Clear double map
						khugepaged_scan_pmd(parent)
						  check mapcount and refcount
						  --> total_mapcount > refcount
			      dec mapcount

The issue can be reproduced by the below test program.

---8<---
void main()
{
        void *addr;
        int ret;
        pid_t pid;

        addr = memalign(ALIGN, 2 * 1024 * 1024);
        if (!addr) {
                printf("malloc failed
");
                return;
        }

        ret = madvise(addr, 2 * 1024 * 1024, MADV_HUGEPAGE);
        if (ret < 0) {
                printf("madvise failed
");
                return;
        }

        memset(addr, 0xdeadbeef, 2 * 1024 * 1024);

        pid = fork();

        if (pid == 0) {
                /* Child process */
                ret = madvise(addr + (2 * 1024 * 1024) - 4096, 4096, MADV_DONTNEED);
                if (ret < 0) {
                        printf("madvise failed in child
");
                        return;
                }
                sleep(120);
        } else if (pid > 0) {
                sleep(5);
                /* Parent process */
                ret = madvise(addr, 2 * 1024 * 1024, MADV_DONTNEED);
                if (ret < 0) {
                        printf("madvise failed in parent
");
                        return;
                }
        } else {
                printf("fork failed
");
                return;
        }

        sleep(120);
}
---8<---

So, total_mapcount > refcount seems not unexpected due to the inherent
race.  Removed the error message even though it is protected by
CONFIG_VM_DEBUG since we have to live with the race and AFAIK some
distros may have CONFIG_VM_DEBUG enabled dy default.

Since such case is ephemeral we could always try collapse the area again
later, so it sounds not harmful.  But, it might report false positive if
the page has excessive GUP pins (i.e. 512), however it might be not that
bad since the same check will be done later.  I didn't figure out a
simple way to prevent the false positive.

Added some notes to elaborate the race and the consequence as well.

Link: http://lkml.kernel.org/r/1589317383-9595-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~khugepaged-allow-to-collapse-a-page-shared-across-fork-fix
+++ a/mm/khugepaged.c
@@ -535,12 +535,6 @@ static bool is_refcount_suitable(struct
 	if (PageSwapCache(page))
 		expected_refcount += compound_nr(page);
 
-	if (IS_ENABLED(CONFIG_DEBUG_VM) && expected_refcount > refcount) {
-		pr_err("expected_refcount (%d) > refcount (%d)\n",
-				expected_refcount, refcount);
-		dump_page(page, "Unexpected refcount");
-	}
-
 	return page_count(page) == expected_refcount;
 }
 
@@ -1239,7 +1233,23 @@ static int khugepaged_scan_pmd(struct mm
 			goto out_unmap;
 		}
 
-		/* Check if the page has any GUP (or other external) pins */
+		/*
+		 * Check if the page has any GUP (or other external) pins.
+		 *
+		 * Here the check is racy it may see totmal_mapcount > refcount
+		 * in some cases.
+		 * For example, one process with one forked child process.
+		 * The parent has the PMD split due to MADV_DONTNEED, then
+		 * the child is trying unmap the whole PMD, but khugepaged
+		 * may be scanning the parent between the child has
+		 * PageDoubleMap flag cleared and dec the mapcount.  So
+		 * khugepaged may see total_mapcount > refcount.
+		 *
+		 * But such case is ephemeral we could always retry collapse
+		 * later.  However it may report false positive if the page
+		 * has excessive GUP pins (i.e. 512).  Anyway the same check
+		 * will be done again later the risk seems low.
+		 */
 		if (!is_refcount_suitable(page)) {
 			result = SCAN_PAGE_COUNT;
 			goto out_unmap;
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

khugepaged-allow-to-collapse-a-page-shared-across-fork-fix.patch
mm-thp-dont-need-drain-lru-cache-when-splitting-and-mlocking-thp.patch
