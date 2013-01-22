From: akpm@linux-foundation.org
Subject: + mm-dont-inline-page_mapping.patch added to -mm tree
Date: Tue, 22 Jan 2013 15:00:20 -0800
Message-ID: <20130122230020.A6A9C31C1BF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:52631 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab3AVXAV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 18:00:21 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so417401ggn.4
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 15:00:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shli@kernel.org, akpm@linux-foundation.org, hughd@google.com, minchan.kim@gmail.com, riel@redhat.com, shli@fusionio.com


The patch titled
     Subject: mm: don't inline page_mapping()
has been added to the -mm tree.  Its filename is
     mm-dont-inline-page_mapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: mm: don't inline page_mapping()

According to akpm, this saves 1/2k text and makes things simple for the
next patch.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   13 +------------
 mm/util.c          |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 12 deletions(-)

diff -puN include/linux/mm.h~mm-dont-inline-page_mapping include/linux/mm.h
--- a/include/linux/mm.h~mm-dont-inline-page_mapping
+++ a/include/linux/mm.h
@@ -809,18 +809,7 @@ void page_address_init(void);
 #define PAGE_MAPPING_KSM	2
 #define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM)
 
-extern struct address_space swapper_space;
-static inline struct address_space *page_mapping(struct page *page)
-{
-	struct address_space *mapping = page->mapping;
-
-	VM_BUG_ON(PageSlab(page));
-	if (unlikely(PageSwapCache(page)))
-		mapping = &swapper_space;
-	else if ((unsigned long)mapping & PAGE_MAPPING_ANON)
-		mapping = NULL;
-	return mapping;
-}
+extern struct address_space *page_mapping(struct page *page);
 
 /* Neutral page->mapping pointer to address_space or anon_vma or other */
 static inline void *page_rmapping(struct page *page)
diff -puN mm/util.c~mm-dont-inline-page_mapping mm/util.c
--- a/mm/util.c~mm-dont-inline-page_mapping
+++ a/mm/util.c
@@ -5,6 +5,7 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 #include <linux/security.h>
+#include <linux/swap.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -382,6 +383,21 @@ unsigned long vm_mmap(struct file *file,
 }
 EXPORT_SYMBOL(vm_mmap);
 
+struct address_space *page_mapping(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+
+	VM_BUG_ON(PageSlab(page));
+#ifdef CONFIG_SWAP
+	if (unlikely(PageSwapCache(page)))
+		mapping = &swapper_space;
+	else
+#endif
+	if ((unsigned long)mapping & PAGE_MAPPING_ANON)
+		mapping = NULL;
+	return mapping;
+}
+
 /* Tracepoints definitions. */
 EXPORT_TRACEPOINT_SYMBOL(kmalloc);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
_

Patches currently in -mm which might be from shli@kernel.org are

linux-next.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-dont-inline-page_mapping.patch
smp-make-smp_call_function_many-use-logic-similar-to-smp_call_function_single.patch
kernel-smpc-cleanups.patch

