From: akpm@linux-foundation.org
Subject: + mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch added to
 -mm tree
Date: Fri, 19 Dec 2014 15:53:00 -0800
Message-ID: <5494ba5c.F+o0ch2AmLZgPXjE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaLSXxB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 18:53:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yalin.Wang@sonymobile.com, kirill@shutemov.name, koct9i@gmail.com, n-horiguchi@ah.jp.nec.com, yalin.wang@sonymobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm:add KPF_ZERO_PAGE flag for /proc/kpageflags
has been added to the -mm tree.  Its filename is
     mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Subject: mm:add KPF_ZERO_PAGE flag for /proc/kpageflags

Add KPF_ZERO_PAGE flag for zero_page, so that userspace processes can
detect zero_page in /proc/kpageflags, and then do memory analysis more
accurately.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt           |    8 ++++++++
 fs/proc/page.c                         |   16 +++++++++++++---
 include/linux/huge_mm.h                |   12 ++++++++++++
 include/uapi/linux/kernel-page-flags.h |    1 +
 mm/huge_memory.c                       |    7 +------
 tools/vm/page-types.c                  |    1 +
 6 files changed, 36 insertions(+), 9 deletions(-)

diff -puN Documentation/vm/pagemap.txt~mm-add-kpf_zero_page-flag-for-proc-kpageflags Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~mm-add-kpf_zero_page-flag-for-proc-kpageflags
+++ a/Documentation/vm/pagemap.txt
@@ -62,6 +62,8 @@ There are three components to pagemap:
     20. NOPAGE
     21. KSM
     22. THP
+    23. BALLOON
+    24. ZERO_PAGE
 
 Short descriptions to the page flags:
 
@@ -102,6 +104,12 @@ Short descriptions to the page flags:
 22. THP
     contiguous pages which construct transparent hugepages
 
+23. BALLOON
+    balloon compaction page
+
+24. ZERO_PAGE
+    zero page for pfn_zero or huge_zero page
+
     [IO related page flags]
  1. ERROR     IO error occurred
  3. UPTODATE  page has up-to-date data
diff -puN fs/proc/page.c~mm-add-kpf_zero_page-flag-for-proc-kpageflags fs/proc/page.c
--- a/fs/proc/page.c~mm-add-kpf_zero_page-flag-for-proc-kpageflags
+++ a/fs/proc/page.c
@@ -5,6 +5,7 @@
 #include <linux/ksm.h>
 #include <linux/mm.h>
 #include <linux/mmzone.h>
+#include <linux/huge_mm.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/hugetlb.h>
@@ -121,9 +122,18 @@ u64 stable_page_flags(struct page *page)
 	 * just checks PG_head/PG_tail, so we need to check PageLRU/PageAnon
 	 * to make sure a given page is a thp, not a non-huge compound page.
 	 */
-	else if (PageTransCompound(page) && (PageLRU(compound_head(page)) ||
-					     PageAnon(compound_head(page))))
-		u |= 1 << KPF_THP;
+	else if (PageTransCompound(page)) {
+		struct page *head = compound_head(page);
+
+		if (PageLRU(head) || PageAnon(head))
+			u |= 1 << KPF_THP;
+		else if (is_huge_zero_page(head)) {
+			u |= 1 << KPF_ZERO_PAGE;
+			u |= 1 << KPF_THP;
+		}
+	} else if (is_zero_pfn(page_to_pfn(page)))
+		u |= 1 << KPF_ZERO_PAGE;
+
 
 	/*
 	 * Caveats on high order pages: page->_count will only be set
diff -puN include/linux/huge_mm.h~mm-add-kpf_zero_page-flag-for-proc-kpageflags include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-add-kpf_zero_page-flag-for-proc-kpageflags
+++ a/include/linux/huge_mm.h
@@ -157,6 +157,13 @@ static inline int hpage_nr_pages(struct
 extern int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				unsigned long addr, pmd_t pmd, pmd_t *pmdp);
 
+extern struct page *huge_zero_page;
+
+static inline bool is_huge_zero_page(struct page *page)
+{
+	return ACCESS_ONCE(huge_zero_page) == page;
+}
+
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
@@ -206,6 +213,11 @@ static inline int do_huge_pmd_numa_page(
 	return 0;
 }
 
+static inline bool is_huge_zero_page(struct page *page)
+{
+	return false;
+}
+
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
diff -puN include/uapi/linux/kernel-page-flags.h~mm-add-kpf_zero_page-flag-for-proc-kpageflags include/uapi/linux/kernel-page-flags.h
--- a/include/uapi/linux/kernel-page-flags.h~mm-add-kpf_zero_page-flag-for-proc-kpageflags
+++ a/include/uapi/linux/kernel-page-flags.h
@@ -32,6 +32,7 @@
 #define KPF_KSM			21
 #define KPF_THP			22
 #define KPF_BALLOON		23
+#define KPF_ZERO_PAGE		24
 
 
 #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
diff -puN mm/huge_memory.c~mm-add-kpf_zero_page-flag-for-proc-kpageflags mm/huge_memory.c
--- a/mm/huge_memory.c~mm-add-kpf_zero_page-flag-for-proc-kpageflags
+++ a/mm/huge_memory.c
@@ -171,12 +171,7 @@ static int start_khugepaged(void)
 }
 
 static atomic_t huge_zero_refcount;
-static struct page *huge_zero_page __read_mostly;
-
-static inline bool is_huge_zero_page(struct page *page)
-{
-	return ACCESS_ONCE(huge_zero_page) == page;
-}
+struct page *huge_zero_page __read_mostly;
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
diff -puN tools/vm/page-types.c~mm-add-kpf_zero_page-flag-for-proc-kpageflags tools/vm/page-types.c
--- a/tools/vm/page-types.c~mm-add-kpf_zero_page-flag-for-proc-kpageflags
+++ a/tools/vm/page-types.c
@@ -133,6 +133,7 @@ static const char * const page_flag_name
 	[KPF_KSM]		= "x:ksm",
 	[KPF_THP]		= "t:thp",
 	[KPF_BALLOON]		= "o:balloon",
+	[KPF_ZERO_PAGE]		= "z:zero_page",
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
_

Patches currently in -mm which might be from Yalin.Wang@sonymobile.com are

origin.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch
mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch

