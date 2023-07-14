Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F11FEB64DC
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jul 2023 18:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236288AbjGNSLt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jul 2023 14:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236417AbjGNSLs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2023 14:11:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C123C1E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 11:11:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE3A661DBB
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 17:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F06AC433C8;
        Fri, 14 Jul 2023 17:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689357281;
        bh=bfRdDJTJQvLtra+P/XG8iISJxCN4mCh7JlAV+bDd9ag=;
        h=Date:To:From:Subject:From;
        b=spBTVw+EUCyCH7a5BxlY8GAvJpIdKvBgOyY9Cou0zwtXmAP5ZNk98MrVooKyIs8HS
         HfbW4o4eDZGZbJLWmaCLeFKslIGcAfj3AfZH/6nrevDogh+2N9y/y22/NHaAsa6xxu
         im1Ee7A8KP5c3eG4RVoQG8UdFNqSNXhgI7JMMsEc=
Date:   Fri, 14 Jul 2023 10:54:40 -0700
To:     mm-commits@vger.kernel.org, iamjoonsoo.kim@lge.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ext-move-functions-around-for-minor-cleanups-to-page_ext.patch added to mm-unstable branch
Message-Id: <20230714175441.4F06AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ext: move functions around for minor cleanups to page_ext
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ext-move-functions-around-for-minor-cleanups-to-page_ext.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-move-functions-around-for-minor-cleanups-to-page_ext.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_ext: move functions around for minor cleanups to page_ext
Date: Fri, 14 Jul 2023 19:47:49 +0800

1. move page_ext_get and page_ext_put down to remove forward
   declaration of lookup_page_ext.

2. move page_ext_init_flatmem_late down to existing non SPARS block to
   remove a new non SPARS block and to keep code for non SPARS tight.

Link: https://lkml.kernel.org/r/20230714114749.1743032-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |   96 +++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 50 deletions(-)

--- a/mm/page_ext.c~mm-page_ext-move-functions-around-for-minor-cleanups-to-page_ext
+++ a/mm/page_ext.c
@@ -90,7 +90,6 @@ static struct page_ext_operations *page_
 unsigned long page_ext_size;
 
 static unsigned long total_usage;
-static struct page_ext *lookup_page_ext(const struct page *page);
 
 bool early_page_ext __meminitdata;
 static int __init setup_early_page_ext(char *str)
@@ -137,62 +136,16 @@ static void __init invoke_init_callbacks
 	}
 }
 
-#ifndef CONFIG_SPARSEMEM
-void __init page_ext_init_flatmem_late(void)
-{
-	invoke_init_callbacks();
-}
-#endif
-
 static inline struct page_ext *get_entry(void *base, unsigned long index)
 {
 	return base + page_ext_size * index;
 }
 
-/**
- * page_ext_get() - Get the extended information for a page.
- * @page: The page we're interested in.
- *
- * Ensures that the page_ext will remain valid until page_ext_put()
- * is called.
- *
- * Return: NULL if no page_ext exists for this page.
- * Context: Any context.  Caller may not sleep until they have called
- * page_ext_put().
- */
-struct page_ext *page_ext_get(struct page *page)
-{
-	struct page_ext *page_ext;
-
-	rcu_read_lock();
-	page_ext = lookup_page_ext(page);
-	if (!page_ext) {
-		rcu_read_unlock();
-		return NULL;
-	}
-
-	return page_ext;
-}
-
-/**
- * page_ext_put() - Working with page extended information is done.
- * @page_ext: Page extended information received from page_ext_get().
- *
- * The page extended information of the page may not be valid after this
- * function is called.
- *
- * Return: None.
- * Context: Any context with corresponding page_ext_get() is called.
- */
-void page_ext_put(struct page_ext *page_ext)
+#ifndef CONFIG_SPARSEMEM
+void __init page_ext_init_flatmem_late(void)
 {
-	if (unlikely(!page_ext))
-		return;
-
-	rcu_read_unlock();
+	invoke_init_callbacks();
 }
-#ifndef CONFIG_SPARSEMEM
-
 
 void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
 {
@@ -536,3 +489,46 @@ void __meminit pgdat_page_ext_init(struc
 }
 
 #endif
+
+/**
+ * page_ext_get() - Get the extended information for a page.
+ * @page: The page we're interested in.
+ *
+ * Ensures that the page_ext will remain valid until page_ext_put()
+ * is called.
+ *
+ * Return: NULL if no page_ext exists for this page.
+ * Context: Any context.  Caller may not sleep until they have called
+ * page_ext_put().
+ */
+struct page_ext *page_ext_get(struct page *page)
+{
+	struct page_ext *page_ext;
+
+	rcu_read_lock();
+	page_ext = lookup_page_ext(page);
+	if (!page_ext) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	return page_ext;
+}
+
+/**
+ * page_ext_put() - Working with page extended information is done.
+ * @page_ext: Page extended information received from page_ext_get().
+ *
+ * The page extended information of the page may not be valid after this
+ * function is called.
+ *
+ * Return: None.
+ * Context: Any context with corresponding page_ext_get() is called.
+ */
+void page_ext_put(struct page_ext *page_ext)
+{
+	if (unlikely(!page_ext))
+		return;
+
+	rcu_read_unlock();
+}
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-correct-stale-comment-of-function-check_pte.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_clear.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set.patch
mm-page_ext-remove-unused-return-value-of-offline_page_ext.patch
mm-page_ext-remove-rollback-for-untouched-mem_section-in-online_page_ext.patch
mm-page_ext-move-functions-around-for-minor-cleanups-to-page_ext.patch

