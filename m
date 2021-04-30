Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8DCC43600
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0203961468
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhD3Fzb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhD3Fza (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:55:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDD3661459;
        Fri, 30 Apr 2021 05:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762083;
        bh=TXgHM08k6mPTcn+ffJUCUw8xzBUU+ZwWKvTztiR9Qak=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xOsDphUSNm6AU/8hU/sPPK8c0QXcgBvptCR1ik9+V9P3loqASbpKztFuEsl9/Eqlc
         tXUXUF4TZGq50UMP6DcPENCJj/LFRREfJNbiENcfLa7P/lsi6aUWjH1S4kdy3jpnl+
         P8QYgU1MVCLc3yBfSzjcrmSK99UQ6msDbg+7vZWI=
Date:   Thu, 29 Apr 2021 22:54:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, glittao@gmail.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 029/178] mm, slub: enable slub_debug static key
 when creating cache with explicit debug flags
Message-ID: <20210430055442.MXMLO5jMs%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: enable slub_debug static key when creating cache with explicit debug flags

Commit ca0cab65ea2b ("mm, slub: introduce static key for slub_debug()")
introduced a static key to optimize the case where no debugging is enabled
for any cache.  The static key is enabled when slub_debug boot parameter
is passed, or CONFIG_SLUB_DEBUG_ON enabled.

However, some caches might be created with one or more debugging flags
explicitly passed to kmem_cache_create(), and the commit missed this. 
Thus the debugging functionality would not be actually performed for these
caches unless the static key gets enabled by boot param or config.

This patch fixes it by checking for debugging flags passed to
kmem_cache_create() and enabling the static key accordingly.

Note such explicit debugging flags should not be used outside of debugging
and testing as they will now enable the static key globally. 
btrfs_init_cachep() creates a cache with SLAB_RED_ZONE but that's a
mistake that's being corrected [1].  rcu_torture_stats() creates a cache
with SLAB_STORE_USER, but that is a testing module so it's OK and will
start working as intended after this patch.

Also note that in case of backports to kernels before v5.12 that don't
have 59450bbc12be ("mm, slab, slub: stop taking cpu hotplug lock"),
static_branch_enable_cpuslocked() should be used.

[1] https://lore.kernel.org/linux-btrfs/20210315141824.26099-1-dsterba@suse.com/

Link: https://lkml.kernel.org/r/20210315153415.24404-1-vbabka@suse.cz
Fixes: ca0cab65ea2b ("mm, slub: introduce static key for slub_debug()")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Oliver Glitta <glittao@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/slub.c~mm-slub-enable-slub_debug-static-key-when-creating-cache-with-explicit-debug-flags
+++ a/mm/slub.c
@@ -3828,6 +3828,15 @@ static int calculate_sizes(struct kmem_c
 
 static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
 {
+#ifdef CONFIG_SLUB_DEBUG
+	/*
+	 * If no slub_debug was enabled globally, the static key is not yet
+	 * enabled by setup_slub_debug(). Enable it if the cache is being
+	 * created with any of the debugging flags passed explicitly.
+	 */
+	if (flags & SLAB_DEBUG_FLAGS)
+		static_branch_enable(&slub_debug_enabled);
+#endif
 	s->flags = kmem_cache_flags(s->size, flags, s->name);
 #ifdef CONFIG_SLAB_FREELIST_HARDENED
 	s->random = get_random_long();
_
