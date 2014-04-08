From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-const-char-insted-of-char-for-reason-in-dump_page.patch removed from -mm tree
Date: Tue, 08 Apr 2014 13:49:15 -0700
Message-ID: <534460cb.G8mlaYZQChRs2z1E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHUtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:49:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dave.hansen@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: [merged] mm-use-const-char-insted-of-char-for-reason-in-dump_page.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,dave.hansen@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:49:15 -0700


The patch titled
     Subject: mm: use 'const char *' insted of 'char *' for reason in dump_page()
has been removed from the -mm tree.  Its filename was
     mm-use-const-char-insted-of-char-for-reason-in-dump_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: use 'const char *' insted of 'char *' for reason in dump_page()

I tried to use 'dump_page(page, __func__)' for debugging, but it triggers
warning:

  warning: passing argument 2 of `dump_page' discards `const' qualifier from pointer target type [enabled by default]

Let's convert 'reason' to 'const char *' in dump_page() and friends: we
shouldn't modify it anyway.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    4 ++--
 mm/page_alloc.c         |   12 +++++++-----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN include/linux/mmdebug.h~mm-use-const-char-insted-of-char-for-reason-in-dump_page include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-use-const-char-insted-of-char-for-reason-in-dump_page
+++ a/include/linux/mmdebug.h
@@ -3,8 +3,8 @@
 
 struct page;
 
-extern void dump_page(struct page *page, char *reason);
-extern void dump_page_badflags(struct page *page, char *reason,
+extern void dump_page(struct page *page, const char *reason);
+extern void dump_page_badflags(struct page *page, const char *reason,
 			       unsigned long badflags);
 
 #ifdef CONFIG_DEBUG_VM
diff -puN mm/page_alloc.c~mm-use-const-char-insted-of-char-for-reason-in-dump_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-const-char-insted-of-char-for-reason-in-dump_page
+++ a/mm/page_alloc.c
@@ -295,7 +295,8 @@ static inline int bad_range(struct zone
 }
 #endif
 
-static void bad_page(struct page *page, char *reason, unsigned long bad_flags)
+static void bad_page(struct page *page, const char *reason,
+		unsigned long bad_flags)
 {
 	static unsigned long resume;
 	static unsigned long nr_shown;
@@ -623,7 +624,7 @@ out:
 
 static inline int free_pages_check(struct page *page)
 {
-	char *bad_reason = NULL;
+	const char *bad_reason = NULL;
 	unsigned long bad_flags = 0;
 
 	if (unlikely(page_mapcount(page)))
@@ -859,7 +860,7 @@ static inline void expand(struct zone *z
  */
 static inline int check_new_page(struct page *page)
 {
-	char *bad_reason = NULL;
+	const char *bad_reason = NULL;
 	unsigned long bad_flags = 0;
 
 	if (unlikely(page_mapcount(page)))
@@ -6545,7 +6546,8 @@ static void dump_page_flags(unsigned lon
 	printk(")\n");
 }
 
-void dump_page_badflags(struct page *page, char *reason, unsigned long badflags)
+void dump_page_badflags(struct page *page, const char *reason,
+		unsigned long badflags)
 {
 	printk(KERN_ALERT
 	       "page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
@@ -6561,7 +6563,7 @@ void dump_page_badflags(struct page *pag
 	mem_cgroup_print_bad_page(page);
 }
 
-void dump_page(struct page *page, char *reason)
+void dump_page(struct page *page, const char *reason)
 {
 	dump_page_badflags(page, reason, 0);
 }
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch

