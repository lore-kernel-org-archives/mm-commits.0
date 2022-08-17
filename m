Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDBBC25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 17:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237343AbiHQRyv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 13:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiHQRyv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 13:54:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465935FF5D
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 10:54:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 802F961298
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 17:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB033C433C1;
        Wed, 17 Aug 2022 17:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660758888;
        bh=K83Ord5CTl3Z5orsKjLnciMv9lcC5Zy7t0wMs0IR50U=;
        h=Date:To:From:Subject:From;
        b=K4QM5uG/AdnUrhUn6oshNE7IY0HnEnhIMqyDDD0Fay1phy5ntJle5B6+VZjCP4c9S
         h6Nu1az7ath16c/RA8bMTuDgdINKwgYflIVepa+BhgVnwSF9gs1HnL0aXZtEGsAqcg
         t8QA9nWwQcSrBizKTIzlWCd7eNmTuaUdup+3cUUQ=
Date:   Wed, 17 Aug 2022 10:54:47 -0700
To:     mm-commits@vger.kernel.org, yang.shi@linaro.org, vbabka@suse.cz,
        rostedt@goodmis.org, Pavel.Tatashin@microsoft.com,
        mhocko@kernel.org, mhiramat@kernel.org,
        mgorman@techsingularity.net, mark-pk.tsai@mediatek.com,
        lizefan.x@bytedance.com, keescook@chromium.org, Jason@zx2c4.com,
        iamjoonsoo.kim@lge.com, cai@lca.pw, lizhe.67@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + page_ext-move-up-page_ext_init-to-catch-early-page-allocation-if-deferred_struct_page_init-is-n.patch added to mm-unstable branch
Message-Id: <20220817175448.CB033C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: page_ext: move up page_ext_init() to catch early page allocation if DEFERRED_STRUCT_PAGE_INIT is n
has been added to the -mm mm-unstable branch.  Its filename is
     page_ext-move-up-page_ext_init-to-catch-early-page-allocation-if-deferred_struct_page_init-is-n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/page_ext-move-up-page_ext_init-to-catch-early-page-allocation-if-deferred_struct_page_init-is-n.patch

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
From: Li Zhe <lizhe.67@bytedance.com>
Subject: page_ext: move up page_ext_init() to catch early page allocation if DEFERRED_STRUCT_PAGE_INIT is n
Date: Mon, 15 Aug 2022 20:09:54 +0800

In commit 2f1ee0913ce5 ("Revert "mm: use early_pfn_to_nid in
page_ext_init"") we call page_ext_init() after page_alloc_init_late() to
avoid some panic problem.  It seems that we cannot track early page
allocations in current kernel even if page structure has been initialized
early.

This patch moves up page_ext_init() to catch early page allocations when
DEFERRED_STRUCT_PAGE_INIT is n.  After this patch, we only need to turn
DEFERRED_STRUCT_PAGE_INIT to n then we are able to analyze the early page
allocations.  This is useful especially when we find that the free memory
value is not the same right after different kernel booting.

Link: https://lkml.kernel.org/r/20220815120954.65957-1-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pasha Tatashin <Pavel.Tatashin@microsoft.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |   30 +++++++++++++++++++++++++++---
 init/main.c              |    7 +++++--
 mm/page_ext.c            |    2 +-
 3 files changed, 33 insertions(+), 6 deletions(-)

--- a/include/linux/page_ext.h~page_ext-move-up-page_ext_init-to-catch-early-page-allocation-if-deferred_struct_page_init-is-n
+++ a/include/linux/page_ext.h
@@ -43,14 +43,34 @@ extern void pgdat_page_ext_init(struct p
 static inline void page_ext_init_flatmem(void)
 {
 }
-extern void page_ext_init(void);
 static inline void page_ext_init_flatmem_late(void)
 {
 }
+extern void _page_ext_init(void);
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+static inline void page_ext_init_early(void)
+{
+}
+static inline void page_ext_init_late(void)
+{
+	_page_ext_init();
+}
+#else
+static inline void page_ext_init_early(void)
+{
+	_page_ext_init();
+}
+static inline void page_ext_init_late(void)
+{
+}
+#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 #else
 extern void page_ext_init_flatmem(void);
 extern void page_ext_init_flatmem_late(void);
-static inline void page_ext_init(void)
+static inline void page_ext_init_early(void)
+{
+}
+static inline void page_ext_init_late(void)
 {
 }
 #endif
@@ -72,7 +92,11 @@ static inline void pgdat_page_ext_init(s
 {
 }
 
-static inline void page_ext_init(void)
+static inline void page_ext_init_early(void)
+{
+}
+
+static inline void page_ext_init_late(void)
 {
 }
 
--- a/init/main.c~page_ext-move-up-page_ext_init-to-catch-early-page-allocation-if-deferred_struct_page_init-is-n
+++ a/init/main.c
@@ -845,6 +845,7 @@ static void __init mm_init(void)
 	 * slab is ready so that stack_depot_init() works properly
 	 */
 	page_ext_init_flatmem_late();
+	page_ext_init_early();
 	kmemleak_init();
 	pgtable_init();
 	debug_objects_mem_init();
@@ -1605,8 +1606,10 @@ static noinline void __init kernel_init_
 
 	padata_init();
 	page_alloc_init_late();
-	/* Initialize page ext after all struct pages are initialized. */
-	page_ext_init();
+	/* Initialize page ext after all struct pages are initialized if
+	 * CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled
+	 */
+	page_ext_init_late();
 
 	do_basic_setup();
 
--- a/mm/page_ext.c~page_ext-move-up-page_ext_init-to-catch-early-page-allocation-if-deferred_struct_page_init-is-n
+++ a/mm/page_ext.c
@@ -458,7 +458,7 @@ static int __meminit page_ext_callback(s
 	return notifier_from_errno(ret);
 }
 
-void __init page_ext_init(void)
+void __init _page_ext_init(void)
 {
 	unsigned long pfn;
 	int nid;
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

page_ext-move-up-page_ext_init-to-catch-early-page-allocation-if-deferred_struct_page_init-is-n.patch

