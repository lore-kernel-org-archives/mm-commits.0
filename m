Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C57EFC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 20:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D0AE61164
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 20:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbhIHUfb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 16:35:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229677AbhIHUfb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Sep 2021 16:35:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4526E6115B;
        Wed,  8 Sep 2021 20:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631133263;
        bh=Q/oXorxdAWOgD1uEGLwFR5tR24s1JRP8XN/+q/+vHEw=;
        h=Date:From:To:Subject:From;
        b=bSWFyMPWy7YB+5l/th9i3PVHBPtHdvSPL5+wZMWbb6frC5V53gORNAYz7xIQjJA/8
         xEBusjZ5bOJatr2GR7TKWSS1Aij+0CPFl5juDxMA/S5d1Stmi0qKWrcj8D8P3ODpLX
         Q6owKvD6taqc4Ht9kpN0gzCEwm+rYXqyhscNmJDk=
Date:   Wed, 08 Sep 2021 13:34:22 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-rejects.patch removed from -mm tree
Message-ID: <20210908203422.ODmFPRuQS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/mctp/Makefile |    1 
 include/linux/page_idle.h |   47 +++++++++++++++++++++++++++++-------
 mm/page_alloc.c           |    4 +--
 3 files changed, 41 insertions(+), 11 deletions(-)

--- a/drivers/net/mctp/Makefile~linux-next-rejects
+++ a/drivers/net/mctp/Makefile
@@ -0,0 +1 @@
+#dummy
--- a/include/linux/page_idle.h~linux-next-rejects
+++ a/include/linux/page_idle.h
@@ -65,46 +65,75 @@ static inline void folio_set_idle(struct
 	set_bit(PAGE_EXT_IDLE, &page_ext->flags);
 }
 
-static inline void clear_page_idle(struct page *page)
+static inline void folio_clear_idle(struct folio *folio)
 {
-	struct page_ext *page_ext = lookup_page_ext(page);
+	struct page_ext *page_ext = lookup_page_ext(&folio->page);
 
 	if (unlikely(!page_ext))
 		return;
 
 	clear_bit(PAGE_EXT_IDLE, &page_ext->flags);
 }
-#endif /* CONFIG_64BIT */
+#endif /* !CONFIG_64BIT */
 
 #else /* !CONFIG_PAGE_IDLE_FLAG */
 
-static inline bool page_is_young(struct page *page)
+static inline bool folio_test_young(struct folio *folio)
 {
 	return false;
 }
 
-static inline void set_page_young(struct page *page)
+static inline void folio_set_young(struct folio *folio)
 {
 }
 
-static inline bool test_and_clear_page_young(struct page *page)
+static inline bool folio_test_clear_young(struct folio *folio)
 {
 	return false;
 }
 
-static inline bool page_is_idle(struct page *page)
+static inline bool folio_test_idle(struct folio *folio)
 {
 	return false;
 }
 
-static inline void set_page_idle(struct page *page)
+static inline void folio_set_idle(struct folio *folio)
 {
 }
 
-static inline void clear_page_idle(struct page *page)
+static inline void folio_clear_idle(struct folio *folio)
 {
 }
 
 #endif /* CONFIG_PAGE_IDLE_FLAG */
 
+static inline bool page_is_young(struct page *page)
+{
+	return folio_test_young(page_folio(page));
+}
+
+static inline void set_page_young(struct page *page)
+{
+	folio_set_young(page_folio(page));
+}
+
+static inline bool test_and_clear_page_young(struct page *page)
+{
+	return folio_test_clear_young(page_folio(page));
+}
+
+static inline bool page_is_idle(struct page *page)
+{
+	return folio_test_idle(page_folio(page));
+}
+
+static inline void set_page_idle(struct page *page)
+{
+	folio_set_idle(page_folio(page));
+}
+
+static inline void clear_page_idle(struct page *page)
+{
+	folio_clear_idle(page_folio(page));
+}
 #endif /* _LINUX_MM_PAGE_IDLE_H */
--- a/mm/page_alloc.c~linux-next-rejects
+++ a/mm/page_alloc.c
@@ -1296,7 +1296,7 @@ static __always_inline bool free_pages_p
 		 * Do not let hwpoison pages hit pcplists/buddy
 		 * Untie memcg state and reset page's owner
 		 */
-		if (memcg_kmem_enabled() && PageMemcgKmem(page))
+		if (memcg_kmem_enabled() && folio_memcg_kmem(page_folio(page)))
 			__memcg_kmem_uncharge_page(page, order);
 		reset_page_owner(page, order);
 		return false;
@@ -1326,7 +1326,7 @@ static __always_inline bool free_pages_p
 	}
 	if (PageMappingFlags(page))
 		page->mapping = NULL;
-	if (memcg_kmem_enabled() && PageMemcgKmem(page))
+	if (memcg_kmem_enabled() && folio_memcg_kmem(page_folio(page)))
 		__memcg_kmem_uncharge_page(page, order);
 	if (check_free)
 		bad += check_free_page(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

