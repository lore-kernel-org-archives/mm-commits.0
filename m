Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130A5C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjBCGj7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbjBCGjE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:39:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73F48E6AE
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6620EB82986
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D7CC433EF;
        Fri,  3 Feb 2023 06:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406214;
        bh=YPvtnCdos+SvHyZOFCCPFilM2FWkXtWjcQ12YnhUMhw=;
        h=Date:To:From:Subject:From;
        b=BLKl6AD3L3jK4M+VYeowt755hPCL2GboNEE1R7jElk+e1vxufoAEGHa4t2V4dS32i
         GoyFGTYivvTTRT65iAheNZdvp0Y2yvdb0P5qNkGx/coXoBrRBkmO7MANT3MIVrX60h
         /b07dBS7V3pI42XK1XNV5/darz1lKXQnYjESSo3c=
Date:   Thu, 02 Feb 2023 22:36:53 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        rientjes@google.com, quic_charante@quicinc.com, mhocko@suse.com,
        lizhe.67@bytedance.com, david@redhat.com,
        pasha.tatashin@soleen.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed.patch removed from -mm tree
Message-Id: <20230203063654.03D7CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_ext: do not allocate space for page_ext->flags if not needed
has been removed from the -mm tree.  Its filename was
     mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm/page_ext: do not allocate space for page_ext->flags if not needed
Date: Fri, 13 Jan 2023 15:42:53 +0000

There is 8 byte page_ext->flags field allocated per page whenever
CONFIG_PAGE_EXTENSION is enabled.  However, not every user of page_ext
uses flags.  Therefore, check whether flags is needed at least by one user
and if so allocate space for it.

For example when page_table_check is enabled, on a machine with 128G
of memory before the fix:

[    2.244288] allocated 536870912 bytes of page_ext
after the fix:
[    2.160154] allocated 268435456 bytes of page_ext

Also, add a kernel-doc comment before page_ext_operations that describes
the fields, and remove check if need() is set, as that is now a required
field.

[pasha.tatashin@soleen.com: address comments from Mike Rapoport]
  Link: https://lkml.kernel.org/r/20230117202103.1412449-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20230113154253.92480-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/page_ext.h~mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed
+++ a/include/linux/page_ext.h
@@ -7,15 +7,33 @@
 #include <linux/stackdepot.h>
 
 struct pglist_data;
+
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
+ * Each Page Extension client must define page_ext_operations in
+ * page_ext_ops array.
+ */
 struct page_ext_operations {
 	size_t offset;
 	size_t size;
 	bool (*need)(void);
 	void (*init)(void);
+	bool need_shared_flags;
 };
 
 #ifdef CONFIG_PAGE_EXTENSION
 
+/*
+ * The page_ext_flags users must set need_shared_flags to true.
+ */
 enum page_ext_flags {
 	PAGE_EXT_OWNER,
 	PAGE_EXT_OWNER_ALLOCATED,
--- a/mm/page_ext.c~mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed
+++ a/mm/page_ext.c
@@ -71,6 +71,7 @@ static bool need_page_idle(void)
 }
 static struct page_ext_operations page_idle_ops __initdata = {
 	.need = need_page_idle,
+	.need_shared_flags = true,
 };
 #endif
 
@@ -86,7 +87,7 @@ static struct page_ext_operations *page_
 #endif
 };
 
-unsigned long page_ext_size = sizeof(struct page_ext);
+unsigned long page_ext_size;
 
 static unsigned long total_usage;
 static struct page_ext *lookup_page_ext(const struct page *page);
@@ -106,7 +107,16 @@ static bool __init invoke_need_callbacks
 	bool need = false;
 
 	for (i = 0; i < entries; i++) {
-		if (page_ext_ops[i]->need && page_ext_ops[i]->need()) {
+		if (page_ext_ops[i]->need()) {
+			if (page_ext_ops[i]->need_shared_flags) {
+				page_ext_size = sizeof(struct page_ext);
+				break;
+			}
+		}
+	}
+
+	for (i = 0; i < entries; i++) {
+		if (page_ext_ops[i]->need()) {
 			page_ext_ops[i]->offset = page_ext_size;
 			page_ext_size += page_ext_ops[i]->size;
 			need = true;
--- a/mm/page_owner.c~mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed
+++ a/mm/page_owner.c
@@ -99,6 +99,7 @@ struct page_ext_operations page_owner_op
 	.size = sizeof(struct page_owner),
 	.need = need_page_owner,
 	.init = init_page_owner,
+	.need_shared_flags = true,
 };
 
 static inline struct page_owner *get_page_owner(struct page_ext *page_ext)
--- a/mm/page_table_check.c~mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed
+++ a/mm/page_table_check.c
@@ -45,6 +45,7 @@ struct page_ext_operations page_table_ch
 	.size = sizeof(struct page_table_check),
 	.need = need_page_table_check,
 	.init = init_page_table_check,
+	.need_shared_flags = false,
 };
 
 static struct page_table_check *get_page_table_check(struct page_ext *page_ext)
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are


