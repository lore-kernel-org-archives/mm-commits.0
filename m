From: akpm@linux-foundation.org
Subject: + mm-madvise-clean-up-madv_soft_offline-and-madv_hwpoison.patch
 added to -mm tree
Date: Mon, 10 Apr 2017 15:12:21 -0700
Message-ID: <58ec0345.pGFFmLO7E/vn5HO4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752155AbdDJWMW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 18:12:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise.c: clean up MADV_SOFT_OFFLINE and MADV_HWPOISON
has been added to the -mm tree.  Its filename is
     mm-madvise-clean-up-madv_soft_offline-and-madv_hwpoison.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-clean-up-madv_soft_offline-and-madv_hwpoison.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-clean-up-madv_soft_offline-and-madv_hwpoison.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm/madvise.c: clean up MADV_SOFT_OFFLINE and MADV_HWPOISON

This cleans up handling MADV_SOFT_OFFLINE and MADV_HWPOISON called
through madvise() system call.

* madvise_memory_failure() was misleading to accommodate handling of
  both memory_failure() as well as soft_offline_page() functions.
  Basically it handles memory error injection from user space which
  can go either way as memory failure or soft offline. Renamed as
  madvise_inject_error() instead.

* Renamed struct page pointer 'p' to 'page'.

* pr_info() was essentially printing PFN value but it said 'page'
  which was misleading. Made the process virtual address explicit.

Before the patch:

Soft offlining page 0x15e3e at 0x3fff8c230000
Soft offlining page 0x1f3 at 0x3fffa0da0000
Soft offlining page 0x744 at 0x3fff7d200000
Soft offlining page 0x1634d at 0x3fff95e20000
Soft offlining page 0x16349 at 0x3fff95e30000
Soft offlining page 0x1d6 at 0x3fff9e8b0000
Soft offlining page 0x5f3 at 0x3fff91bd0000

Injecting memory failure for page 0x15c8b at 0x3fff83280000
Injecting memory failure for page 0x16190 at 0x3fff83290000
Injecting memory failure for page 0x740 at 0x3fff9a2e0000
Injecting memory failure for page 0x741 at 0x3fff9a2f0000

After the patch:

Soft offlining pfn 0x1484e at process virtual address 0x3fff883c0000
Soft offlining pfn 0x1484f at process virtual address 0x3fff883d0000
Soft offlining pfn 0x14850 at process virtual address 0x3fff883e0000
Soft offlining pfn 0x14851 at process virtual address 0x3fff883f0000
Soft offlining pfn 0x14852 at process virtual address 0x3fff88400000
Soft offlining pfn 0x14853 at process virtual address 0x3fff88410000
Soft offlining pfn 0x14854 at process virtual address 0x3fff88420000
Soft offlining pfn 0x1521c at process virtual address 0x3fff6bc70000

Injecting memory failure for pfn 0x10fcf at process virtual address 0x3fff86310000
Injecting memory failure for pfn 0x10fd0 at process virtual address 0x3fff86320000
Injecting memory failure for pfn 0x10fd1 at process virtual address 0x3fff86330000
Injecting memory failure for pfn 0x10fd2 at process virtual address 0x3fff86340000
Injecting memory failure for pfn 0x10fd3 at process virtual address 0x3fff86350000
Injecting memory failure for pfn 0x10fd4 at process virtual address 0x3fff86360000
Injecting memory failure for pfn 0x10fd5 at process virtual address 0x3fff86370000

Link: http://lkml.kernel.org/r/20170410084701.11248-1-khandual@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff -puN mm/madvise.c~mm-madvise-clean-up-madv_soft_offline-and-madv_hwpoison mm/madvise.c
--- a/mm/madvise.c~mm-madvise-clean-up-madv_soft_offline-and-madv_hwpoison
+++ a/mm/madvise.c
@@ -605,34 +605,40 @@ static long madvise_remove(struct vm_are
 /*
  * Error injection support for memory error handling.
  */
-static int madvise_hwpoison(int bhv, unsigned long start, unsigned long end)
+static int madvise_inject_error(int behavior,
+		unsigned long start, unsigned long end)
 {
-	struct page *p;
+	struct page *page;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
+
 	for (; start < end; start += PAGE_SIZE <<
-				compound_order(compound_head(p))) {
+				compound_order(compound_head(page))) {
 		int ret;
 
-		ret = get_user_pages_fast(start, 1, 0, &p);
+		ret = get_user_pages_fast(start, 1, 0, &page);
 		if (ret != 1)
 			return ret;
 
-		if (PageHWPoison(p)) {
-			put_page(p);
+		if (PageHWPoison(page)) {
+			put_page(page);
 			continue;
 		}
-		if (bhv == MADV_SOFT_OFFLINE) {
-			pr_info("Soft offlining page %#lx at %#lx\n",
-				page_to_pfn(p), start);
-			ret = soft_offline_page(p, MF_COUNT_INCREASED);
+
+		if (behavior == MADV_SOFT_OFFLINE) {
+			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
+						page_to_pfn(page), start);
+
+			ret = soft_offline_page(page, MF_COUNT_INCREASED);
 			if (ret)
 				return ret;
 			continue;
 		}
-		pr_info("Injecting memory failure for page %#lx at %#lx\n",
-		       page_to_pfn(p), start);
-		ret = memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
+		pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
+						page_to_pfn(page), start);
+
+		ret = memory_failure(page_to_pfn(page), 0, MF_COUNT_INCREASED);
 		if (ret)
 			return ret;
 	}
@@ -756,7 +762,7 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 
 #ifdef CONFIG_MEMORY_FAILURE
 	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
-		return madvise_hwpoison(behavior, start, start+len_in);
+		return madvise_inject_error(behavior, start, start + len_in);
 #endif
 	if (!madvise_behavior_valid(behavior))
 		return error;
_

Patches currently in -mm which might be from khandual@linux.vnet.ibm.com are

mm-mmap-replace-shm_huge_mask-with-map_huge_mask-inside-mmap_pgoff.patch
mm-madvise-clean-up-madv_soft_offline-and-madv_hwpoison.patch

