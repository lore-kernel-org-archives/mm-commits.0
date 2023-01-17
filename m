Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E80ABC00A5A
	for <mm-commits@archiver.kernel.org>; Tue, 17 Jan 2023 23:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjAQXrU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Jan 2023 18:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAQXqf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2023 18:46:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC26613FD
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 14:53:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53A7A614C7
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 22:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7D7C433D2;
        Tue, 17 Jan 2023 22:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673996013;
        bh=x/GaLw2Jd7drdK7r4ed0nAGln9AACJM6D1Sru5nv/T0=;
        h=Date:To:From:Subject:From;
        b=Yfx0dkkOAR7Ch9Bx9pEo82Fa6Q3s4PJBjTJOiYI20cw6XWqrdorwqO6x38bNXU/N3
         YABkIC3PmjHGk4oRP7HKkMXrPpdv4lcEnRK1+wg6QQE9XHpbsMKYLRemIiMz2LdTps
         L3tsgJF+bWV5GtVuRwANx0Liojb4I97Z4jULinH8=
Date:   Tue, 17 Jan 2023 14:53:32 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        quic_charante@quicinc.com, mhocko@suse.com, lizhe.67@bytedance.com,
        david@redhat.com, pasha.tatashin@soleen.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed-v4.patch added to mm-unstable branch
Message-Id: <20230117225333.9C7D7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed-v4
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed-v4.patch

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
mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed-v4.patch
mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages.patch

