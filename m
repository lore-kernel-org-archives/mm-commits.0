Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AADDC3DA78
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 04:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjANEWn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbjANEW2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 23:22:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED169D
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 20:22:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 315AEB82281
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 04:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D717BC433EF;
        Sat, 14 Jan 2023 04:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673670144;
        bh=gp4/5KJxMqrI/G19x7TNe4XfjnDkYvUqLlWIDcQwZps=;
        h=Date:To:From:Subject:From;
        b=09bA6vvmQSQX3IEvn4FgpaOztFOj3nawhPoNLo9MLNc+uOP13IH3gLGzWEv9KrIeu
         5UR8BroCTZgn63fKYPpEl6WrClJMuNeThroEWNZaDfoGuCi2lDfFt8riRx6AwhwT7l
         RBHtj8O4zSVqSc06KB2+vOzBlkY5b5vBs0gMgIcc=
Date:   Fri, 13 Jan 2023 20:22:24 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        quic_charante@quicinc.com, mhocko@suse.com, lizhe.67@bytedance.com,
        david@redhat.com, pasha.tatashin@soleen.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed.patch added to mm-unstable branch
Message-Id: <20230114042224.D717BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ext: do not allocate space for page_ext->flags if not needed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed.patch

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

Also, add a comment before page_ext_operations that describes the
field, and remove check if need() is set, as that is now a required
field.

Link: https://lkml.kernel.org/r/20230113154253.92480-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/page_ext.h~mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed
+++ a/include/linux/page_ext.h
@@ -7,15 +7,31 @@
 #include <linux/stackdepot.h>
 
 struct pglist_data;
+
+/*
+ * Each Page Extension client must define page_ext_operations in
+ * page_ext_ops array.
+ * offset  offset to the client's data within page_ext. Offset is returned to
+ *         the client by page_ext_init.
+ * size    the size of the client data within page_ext.
+ * need()  function that returns true if client requires page_ext
+ * init()  (optional) called to initialize client once page_exts are allocated.
+ * using_shared_ext_flags  true when client is using shared page_ext->flags
+ *         field.
+ */
 struct page_ext_operations {
 	size_t offset;
 	size_t size;
 	bool (*need)(void);
 	void (*init)(void);
+	bool using_shared_ext_flags;
 };
 
 #ifdef CONFIG_PAGE_EXTENSION
 
+/*
+ * The page_ext_flags users must set using_shared_ext_flags to true.
+ */
 enum page_ext_flags {
 	PAGE_EXT_OWNER,
 	PAGE_EXT_OWNER_ALLOCATED,
@@ -31,6 +47,9 @@ enum page_ext_flags {
  * page_ext helps us add more information about the page.
  * All page_ext are allocated at boot or memory hotplug event,
  * then the page_ext for pfn always exists.
+ * Note: that if none of the users of page_ext is setting
+ * using_shared_ext_flags to true, the field cannot be used,
+ * as it will be overlapped with another data.
  */
 struct page_ext {
 	unsigned long flags;
--- a/mm/page_ext.c~mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed
+++ a/mm/page_ext.c
@@ -71,6 +71,7 @@ static bool need_page_idle(void)
 }
 static struct page_ext_operations page_idle_ops __initdata = {
 	.need = need_page_idle,
+	.using_shared_ext_flags = true,
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
+			if (page_ext_ops[i]->using_shared_ext_flags) {
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
+	.using_shared_ext_flags = true,
 };
 
 static inline struct page_owner *get_page_owner(struct page_ext *page_ext)
--- a/mm/page_table_check.c~mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed
+++ a/mm/page_table_check.c
@@ -45,6 +45,7 @@ struct page_ext_operations page_table_ch
 	.size = sizeof(struct page_table_check),
 	.need = need_page_table_check,
 	.init = init_page_table_check,
+	.using_shared_ext_flags = false,
 };
 
 static struct page_table_check *get_page_table_check(struct page_ext *page_ext)
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed.patch

