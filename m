Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3E5C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjBCFnM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjBCFnM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:43:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06899757
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:43:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 882A861D79
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD75C433EF;
        Fri,  3 Feb 2023 05:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675402987;
        bh=TFSvFyNfpcyftqf5aSn78JSNZo2800fqLfLXX/1MzzQ=;
        h=Date:To:From:Subject:From;
        b=EjjGfvqWD5YVe3dWjFG79b2j4cic21DbMRSEfMGzqNVaeZB8FhCFB1bcs6VqaRa9C
         dfHMjfeSEj7J/w2XsO8x9p/I1ooA4QU3bG+gw/MNDuuLP8vumA4US+ATPeUk/BB/6y
         1GrbzEjsDe1owVJhFBRRNed0d5EtcGDjQCO1oj3s=
Date:   Thu, 02 Feb 2023 21:43:06 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        quic_charante@quicinc.com, mhocko@suse.com, lizhe.67@bytedance.com,
        david@redhat.com, pasha.tatashin@soleen.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed-v4.patch removed from -mm tree
Message-Id: <20230203054306.DBD75C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed-v4
has been removed from the -mm tree.  Its filename was
     mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed-v4.patch

This patch was dropped because it was folded into mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed.patch

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed-v4
Date: Tue, 17 Jan 2023 20:21:03 +0000

address comments from Mike Rapoport

Link: https://lkml.kernel.org/r/20230117202103.1412449-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/page_ext.h~mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed-v4
+++ a/include/linux/page_ext.h
@@ -8,29 +8,31 @@
 
 struct pglist_data;
 
-/*
+/**
+ * struct page_ext_operations - per page_ext client operations
+ * @offset: Offset to the client's data within page_ext. Offset is returned to
+ *          the client by page_ext_init.
+ * @size: The size of the client data within page_ext.
+ * @need: Function that returns true if client requires page_ext.
+ * @init: (optional) Called to initialize client once page_exts are allocated.
+ * @need_shared_flags: True when client is using shared page_ext->flags
+ *                     field.
+ *
  * Each Page Extension client must define page_ext_operations in
  * page_ext_ops array.
- * offset  offset to the client's data within page_ext. Offset is returned to
- *         the client by page_ext_init.
- * size    the size of the client data within page_ext.
- * need()  function that returns true if client requires page_ext
- * init()  (optional) called to initialize client once page_exts are allocated.
- * using_shared_ext_flags  true when client is using shared page_ext->flags
- *         field.
  */
 struct page_ext_operations {
 	size_t offset;
 	size_t size;
 	bool (*need)(void);
 	void (*init)(void);
-	bool using_shared_ext_flags;
+	bool need_shared_flags;
 };
 
 #ifdef CONFIG_PAGE_EXTENSION
 
 /*
- * The page_ext_flags users must set using_shared_ext_flags to true.
+ * The page_ext_flags users must set need_shared_flags to true.
  */
 enum page_ext_flags {
 	PAGE_EXT_OWNER,
@@ -47,9 +49,6 @@ enum page_ext_flags {
  * page_ext helps us add more information about the page.
  * All page_ext are allocated at boot or memory hotplug event,
  * then the page_ext for pfn always exists.
- * Note: that if none of the users of page_ext is setting
- * using_shared_ext_flags to true, the field cannot be used,
- * as it will be overlapped with another data.
  */
 struct page_ext {
 	unsigned long flags;
--- a/mm/page_ext.c~mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed-v4
+++ a/mm/page_ext.c
@@ -71,7 +71,7 @@ static bool need_page_idle(void)
 }
 static struct page_ext_operations page_idle_ops __initdata = {
 	.need = need_page_idle,
-	.using_shared_ext_flags = true,
+	.need_shared_flags = true,
 };
 #endif
 
@@ -108,7 +108,7 @@ static bool __init invoke_need_callbacks
 
 	for (i = 0; i < entries; i++) {
 		if (page_ext_ops[i]->need()) {
-			if (page_ext_ops[i]->using_shared_ext_flags) {
+			if (page_ext_ops[i]->need_shared_flags) {
 				page_ext_size = sizeof(struct page_ext);
 				break;
 			}
--- a/mm/page_owner.c~mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed-v4
+++ a/mm/page_owner.c
@@ -99,7 +99,7 @@ struct page_ext_operations page_owner_op
 	.size = sizeof(struct page_owner),
 	.need = need_page_owner,
 	.init = init_page_owner,
-	.using_shared_ext_flags = true,
+	.need_shared_flags = true,
 };
 
 static inline struct page_owner *get_page_owner(struct page_ext *page_ext)
--- a/mm/page_table_check.c~mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed-v4
+++ a/mm/page_table_check.c
@@ -45,7 +45,7 @@ struct page_ext_operations page_table_ch
 	.size = sizeof(struct page_table_check),
 	.need = need_page_table_check,
 	.init = init_page_table_check,
-	.using_shared_ext_flags = false,
+	.need_shared_flags = false,
 };
 
 static struct page_table_check *get_page_table_check(struct page_ext *page_ext)
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed.patch
mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages.patch
mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages-v2.patch

