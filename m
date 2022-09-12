Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6CCC54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiILDdo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiILDcD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D08D1C10B
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEE3E61169
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CEDC433D6;
        Mon, 12 Sep 2022 03:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953396;
        bh=fvRyftG7v52Cv1bDq2y3HTNsa3fhuifJQXMDG5Ly4K8=;
        h=Date:To:From:Subject:From;
        b=RiJ+TPu1BZdhOzn1AUHKL9PNHf5G6DhDHkeQYh9H5qzULyUh+rolQrbl4TPrh5hah
         r5qFWI/roqrGKwNtUBCf4sJUMly0f8/Y2aj8FjWJrLuB6vS0SuMOJi+Acp6ods9QOM
         +E24Z3dhj5cT9Ys1KLyZXwmbzPlc/E6+kYMElZBc=
Date:   Sun, 11 Sep 2022 20:29:55 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rostedt@goodmis.org,
        mhocko@suse.com, mhiramat@kernel.org, mark-pk.tsai@mediatek.com,
        keescook@chromium.org, Jason@zx2c4.com, corbet@lwn.net,
        lizhe.67@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] page_ext-introduce-boot-parameter-early_page_ext.patch removed from -mm tree
Message-Id: <20220912032956.34CEDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: page_ext: introduce boot parameter 'early_page_ext'
has been removed from the -mm tree.  Its filename was
     page_ext-introduce-boot-parameter-early_page_ext.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Zhe <lizhe.67@bytedance.com>
Subject: page_ext: introduce boot parameter 'early_page_ext'
Date: Thu, 25 Aug 2022 18:27:14 +0800

In commit 2f1ee0913ce5 ("Revert "mm: use early_pfn_to_nid in
page_ext_init""), we call page_ext_init() after page_alloc_init_late() to
avoid some panic problem.  It seems that we cannot track early page
allocations in current kernel even if page structure has been initialized
early.

This patch introduces a new boot parameter 'early_page_ext' to resolve
this problem.  If we pass it to the kernel, page_ext_init() will be moved
up and the feature 'deferred initialization of struct pages' will be
disabled to initialize the page allocator early and prevent the panic
problem above.  It can help us to catch early page allocations.  This is
useful especially when we find that the free memory value is not the same
right after different kernel booting.

[akpm@linux-foundation.org: fix section issue by removing __meminitdata]
Link: https://lkml.kernel.org/r/20220825102714.669-1-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    8 ++++++++
 include/linux/page_ext.h                        |   11 +++++++++++
 init/main.c                                     |    6 +++++-
 mm/page_alloc.c                                 |    2 ++
 mm/page_ext.c                                   |    8 ++++++++
 5 files changed, 34 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~page_ext-introduce-boot-parameter-early_page_ext
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1471,6 +1471,14 @@
 			Permit 'security.evm' to be updated regardless of
 			current integrity status.
 
+	early_page_ext [KNL] Enforces page_ext initialization to earlier
+			stages so cover more early boot allocations.
+			Please note that as side effect some optimizations
+			might be disabled to achieve that (e.g. parallelized
+			memory initialization is disabled) so the boot process
+			might take longer, especially on systems with a lot of
+			memory. Available with CONFIG_PAGE_EXTENSION=y.
+
 	failslab=
 	fail_usercopy=
 	fail_page_alloc=
--- a/include/linux/page_ext.h~page_ext-introduce-boot-parameter-early_page_ext
+++ a/include/linux/page_ext.h
@@ -36,9 +36,15 @@ struct page_ext {
 	unsigned long flags;
 };
 
+extern bool early_page_ext;
 extern unsigned long page_ext_size;
 extern void pgdat_page_ext_init(struct pglist_data *pgdat);
 
+static inline bool early_page_ext_enabled(void)
+{
+	return early_page_ext;
+}
+
 #ifdef CONFIG_SPARSEMEM
 static inline void page_ext_init_flatmem(void)
 {
@@ -68,6 +74,11 @@ static inline struct page_ext *page_ext_
 #else /* !CONFIG_PAGE_EXTENSION */
 struct page_ext;
 
+static inline bool early_page_ext_enabled(void)
+{
+	return false;
+}
+
 static inline void pgdat_page_ext_init(struct pglist_data *pgdat)
 {
 }
--- a/init/main.c~page_ext-introduce-boot-parameter-early_page_ext
+++ a/init/main.c
@@ -849,6 +849,9 @@ static void __init mm_init(void)
 	pgtable_init();
 	debug_objects_mem_init();
 	vmalloc_init();
+	/* Should be run after vmap initialization */
+	if (early_page_ext_enabled())
+		page_ext_init();
 	/* Should be run before the first non-init thread is created */
 	init_espfix_bsp();
 	/* Should be run after espfix64 is set up. */
@@ -1618,7 +1621,8 @@ static noinline void __init kernel_init_
 	padata_init();
 	page_alloc_init_late();
 	/* Initialize page ext after all struct pages are initialized. */
-	page_ext_init();
+	if (!early_page_ext_enabled())
+		page_ext_init();
 
 	do_basic_setup();
 
--- a/mm/page_alloc.c~page_ext-introduce-boot-parameter-early_page_ext
+++ a/mm/page_alloc.c
@@ -482,6 +482,8 @@ defer_init(int nid, unsigned long pfn, u
 {
 	static unsigned long prev_end_pfn, nr_initialised;
 
+	if (early_page_ext_enabled())
+		return false;
 	/*
 	 * prev_end_pfn static that contains the end of previous zone
 	 * No need to protect because called very early in boot before smp_init.
--- a/mm/page_ext.c~page_ext-introduce-boot-parameter-early_page_ext
+++ a/mm/page_ext.c
@@ -91,6 +91,14 @@ unsigned long page_ext_size = sizeof(str
 static unsigned long total_usage;
 static struct page_ext *lookup_page_ext(const struct page *page);
 
+bool early_page_ext;
+static int __init setup_early_page_ext(char *str)
+{
+	early_page_ext = true;
+	return 0;
+}
+early_param("early_page_ext", setup_early_page_ext);
+
 static bool __init invoke_need_callbacks(void)
 {
 	int i;
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are


