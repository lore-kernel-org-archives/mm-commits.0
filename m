Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE454C433DB
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 20:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 897C064F06
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 20:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbhCOUJ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 16:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232273AbhCOUJC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 16:09:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6C4464E83;
        Mon, 15 Mar 2021 20:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615838942;
        bh=EnFwX/JUzTGQ1/+H6nx8VqRiS+qMLSrao1TOsqvd0aA=;
        h=Date:From:To:Subject:From;
        b=AD0K9l/T0dY0a/iy6TwfjeChHjN/GqtEwGjcgY9jiKAtIG2pSydiGix4Kmqcpq0pC
         8AdUJysInUdrjN28D0b5+gTZkT0siNpsYUecBHLaoR3fBsJZhWq+M3dNMKsEMy9xRB
         BIyHhB0UO4cBRx1jWF7xSiCJ3f+S7pzZ7v5GrUYI=
Date:   Mon, 15 Mar 2021 13:09:01 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, glittao@gmail.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-slub-enable-slub=5Fdebug-static-key-when-creating-cache?=
 =?US-ASCII?Q?-with-explicit-debug-flags.patch?= added to -mm tree
Message-ID: <20210315200901.aHjtUiZ2P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: enable slub_debug static key when creating cache with explicit debug flags
has been added to the -mm tree.  Its filename is
     mm-slub-enable-slub_debug-static-key-when-creating-cache-with-explicit-debug-flags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-enable-slub_debug-static-key-when-creating-cache-with-explicit-debug-flags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-enable-slub_debug-static-key-when-creating-cache-with-explicit-debug-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -3886,6 +3886,15 @@ static int calculate_sizes(struct kmem_c
 
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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-enable-slub_debug-static-key-when-creating-cache-with-explicit-debug-flags.patch

