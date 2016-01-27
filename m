From: akpm@linux-foundation.org
Subject: +
 mm-provide-debug_pagealloc_enabled-without-config_debug_pagealloc.patch
 added to -mm tree
Date: Wed, 27 Jan 2016 11:52:20 -0800
Message-ID: <56a91ff4.uEMpQtta8hqiF9eL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935185AbcA0TwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 14:52:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, rientjes@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: provide debug_pagealloc_enabled() without CONFIG_DEBUG_PAGEALLOC
has been added to the -mm tree.  Its filename is
     mm-provide-debug_pagealloc_enabled-without-config_debug_pagealloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-provide-debug_pagealloc_enabled-without-config_debug_pagealloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-provide-debug_pagealloc_enabled-without-config_debug_pagealloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: mm: provide debug_pagealloc_enabled() without CONFIG_DEBUG_PAGEALLOC

We can provide debug_pagealloc_enabled() also if CONFIG_DEBUG_PAGEALLOC
is not set. It will return false in that case.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-provide-debug_pagealloc_enabled-without-config_debug_pagealloc include/linux/mm.h
--- a/include/linux/mm.h~mm-provide-debug_pagealloc_enabled-without-config_debug_pagealloc
+++ a/include/linux/mm.h
@@ -2206,13 +2206,18 @@ kernel_map_pages(struct page *page, int
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif /* CONFIG_HIBERNATION */
-#else
+#else  /* CONFIG_DEBUG_PAGEALLOC */
+static inline bool debug_pagealloc_enabled(void)
+{
+	return false;
+}
+
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable) {}
 #ifdef CONFIG_HIBERNATION
 static inline bool kernel_page_present(struct page *page) { return true; }
 #endif /* CONFIG_HIBERNATION */
-#endif
+#endif /* CONFIG_DEBUG_PAGEALLOC */
 
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
_

Patches currently in -mm which might be from borntraeger@de.ibm.com are

mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc.patch
mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc-v3.patch
mm-provide-debug_pagealloc_enabled-without-config_debug_pagealloc.patch
x86-query-dynamic-debug_pagealloc-setting.patch
s390-query-dynamic-debug_pagealloc-setting.patch

