From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-page_poisoningc-allow-for-zero-poisoning.patch removed from -mm tree
Date: Fri, 04 Mar 2016 15:59:11 -0800
Message-ID: <56da214f.yx+EPBQgkhMwVDO8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760507AbcCDX7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 18:59:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@fedoraproject.org, dave.hansen@intel.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, mhocko@suse.com, minipli@googlemail.com, nasa4836@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_poisoning.c: allow for zero poisoning
has been removed from the -mm tree.  Its filename was
     mm-page_poisoningc-allow-for-zero-poisoning.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Laura Abbott <labbott@fedoraproject.org>
Subject: mm/page_poisoning.c: allow for zero poisoning

By default, page poisoning uses a poison value (0xaa) on free.  If this is
changed to 0, the page is not only sanitized but zeroing on alloc with
__GFP_ZERO can be skipped as well.  The tradeoff is that detecting
corruption from the poisoning is harder to detect.  This feature also
cannot be used with hibernation since pages are not guaranteed to be
zeroed after hibernation.

Credit to Mathias Krause and grsecurity for original work

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    4 ++++
 mm/Kconfig.debug       |   13 +++++++++++++
 mm/page_alloc.c        |    8 +++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff -puN include/linux/poison.h~mm-page_poisoningc-allow-for-zero-poisoning include/linux/poison.h
--- a/include/linux/poison.h~mm-page_poisoningc-allow-for-zero-poisoning
+++ a/include/linux/poison.h
@@ -30,7 +30,11 @@
 #define TIMER_ENTRY_STATIC	((void *) 0x300 + POISON_POINTER_DELTA)
 
 /********** mm/debug-pagealloc.c **********/
+#ifdef CONFIG_PAGE_POISONING_ZERO
+#define PAGE_POISON 0x00
+#else
 #define PAGE_POISON 0xaa
+#endif
 
 /********** mm/page_alloc.c ************/
 
diff -puN mm/Kconfig.debug~mm-page_poisoningc-allow-for-zero-poisoning mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-page_poisoningc-allow-for-zero-poisoning
+++ a/mm/Kconfig.debug
@@ -62,3 +62,16 @@ config PAGE_POISONING_NO_SANITY
 
 	   If you are only interested in sanitization, say Y. Otherwise
 	   say N.
+
+config PAGE_POISONING_ZERO
+	bool "Use zero for poisoning instead of random data"
+	depends on !HIBERNATION
+	depends on PAGE_POISONING
+	---help---
+	   Instead of using the existing poison value, fill the pages with
+	   zeros. This makes it harder to detect when errors are occuring
+	   due to sanitization but the zeroing at free means that it is
+	   no longer necessary to write zeros when GFP_ZERO is used on
+	   allocation.
+
+	   If unsure, say N
diff -puN mm/page_alloc.c~mm-page_poisoningc-allow-for-zero-poisoning mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_poisoningc-allow-for-zero-poisoning
+++ a/mm/page_alloc.c
@@ -1387,6 +1387,12 @@ static inline int check_new_page(struct
 	return 0;
 }
 
+static inline bool should_zero(void)
+{
+	return !IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) ||
+		!page_poisoning_enabled();
+}
+
 static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
 								int alloc_flags)
 {
@@ -1406,7 +1412,7 @@ static int prep_new_page(struct page *pa
 	kernel_map_pages(page, 1 << order, 1);
 	kasan_alloc_pages(page, order);
 
-	if (gfp_flags & __GFP_ZERO)
+	if (should_zero() && gfp_flags & __GFP_ZERO)
 		for (i = 0; i < (1 << order); i++)
 			clear_highpage(page + i);
 
_

Patches currently in -mm which might be from labbott@fedoraproject.org are

slub-drop-lock-at-the-end-of-free_debug_processing.patch
slub-fix-clean-free_debug_processing-return-paths.patch
slub-convert-slab_debug_free-to-slab_consistency_checks.patch
slub-relax-cmpxchg-consistency-restrictions.patch

