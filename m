Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B87C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 164BB61D03
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhF2ChU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:37:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231750AbhF2ChU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:37:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D09D261A2B;
        Tue, 29 Jun 2021 02:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934093;
        bh=VqQgY4n2gWm6hlmSggaX4/pFgWht4gF6KPNu9KOKny8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ggl0Qargyaw+2df9eQl0/Ow+NYEFfNKVAf2Uec1psUopuPz7qT3RTYrQ34mxm5VrA
         ACsoY04U00KakJwgDjyUyKJk/svnT5Di7nacKPQZotVQSj4lPq3uLKtELpJpWlej2J
         Y621dWgbN0dE1Xk2c8Pq4Tib3Ys6IbSpV+jN9OVY=
Date:   Mon, 28 Jun 2021 19:34:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, pmladek@suse.com, rientjes@google.com,
        songmuchun@bytedance.com, swboyd@chromium.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 030/192] slub: force on no_hash_pointers when
 slub_debug is enabled
Message-ID: <20210629023452.xXbavb1ls%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>
Subject: slub: force on no_hash_pointers when slub_debug is enabled

Obscuring the pointers that slub shows when debugging makes for some
confusing slub debug messages:

 Padding overwritten. 0x0000000079f0674a-0x000000000d4dce17

Those addresses are hashed for kernel security reasons.  If we're trying
to be secure with slub_debug on the commandline we have some big problems
given that we dump whole chunks of kernel memory to the kernel logs. 
Let's force on the no_hash_pointers commandline flag when slub_debug is on
the commandline.  This makes slub debug messages more meaningful and if by
chance a kernel address is in some slub debug object dump we will have a
better chance of figuring out what went wrong.

Note that we don't use %px in the slub code because we want to reduce the
number of places that %px is used in the kernel.  This also nicely prints
a big fat warning at kernel boot if slub_debug is on the commandline so
that we know that this kernel shouldn't be used on production systems.

[akpm@linux-foundation.org: fix build with CONFIG_SLUB_DEBUG=n]
Link: https://lkml.kernel.org/r/20210601182202.3011020-5-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Petr Mladek <pmladek@suse.com>
Cc: Joe Perches <joe@perches.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 ++
 lib/vsprintf.c         |    2 +-
 mm/slub.c              |   20 +++++++++++++++++++-
 3 files changed, 22 insertions(+), 2 deletions(-)

--- a/include/linux/kernel.h~slub-force-on-no_hash_pointers-when-slub_debug-is-enabled
+++ a/include/linux/kernel.h
@@ -357,6 +357,8 @@ int sscanf(const char *, const char *, .
 extern __scanf(2, 0)
 int vsscanf(const char *, const char *, va_list);
 
+extern int no_hash_pointers_enable(char *str);
+
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
--- a/lib/vsprintf.c~slub-force-on-no_hash_pointers-when-slub_debug-is-enabled
+++ a/lib/vsprintf.c
@@ -2186,7 +2186,7 @@ char *fwnode_string(char *buf, char *end
 bool no_hash_pointers __ro_after_init;
 EXPORT_SYMBOL_GPL(no_hash_pointers);
 
-static int __init no_hash_pointers_enable(char *str)
+int __init no_hash_pointers_enable(char *str)
 {
 	if (no_hash_pointers)
 		return 0;
--- a/mm/slub.c~slub-force-on-no_hash_pointers-when-slub_debug-is-enabled
+++ a/mm/slub.c
@@ -118,12 +118,26 @@
  */
 
 #ifdef CONFIG_SLUB_DEBUG
+
 #ifdef CONFIG_SLUB_DEBUG_ON
 DEFINE_STATIC_KEY_TRUE(slub_debug_enabled);
 #else
 DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
 #endif
-#endif
+
+static inline bool __slub_debug_enabled(void)
+{
+	return static_branch_unlikely(&slub_debug_enabled);
+}
+
+#else		/* CONFIG_SLUB_DEBUG */
+
+static inline bool __slub_debug_enabled(void)
+{
+	return false;
+}
+
+#endif		/* CONFIG_SLUB_DEBUG */
 
 static inline bool kmem_cache_debug(struct kmem_cache *s)
 {
@@ -4487,6 +4501,10 @@ void __init kmem_cache_init(void)
 	if (debug_guardpage_minorder())
 		slub_max_order = 0;
 
+	/* Print slub debugging pointers without hashing */
+	if (__slub_debug_enabled())
+		no_hash_pointers_enable(NULL);
+
 	kmem_cache_node = &boot_kmem_cache_node;
 	kmem_cache = &boot_kmem_cache;
 
_
