Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284E1C4360C
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 01:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDF232075E
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 01:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbhANBxj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jan 2021 20:53:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729686AbhANAAH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Jan 2021 19:00:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EFF82339D;
        Wed, 13 Jan 2021 23:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610581852;
        bh=mZJStB/CMVQyRmx6fbkcSrYw2Zx+pW+X86bnfg0S8ew=;
        h=Date:From:To:Subject:From;
        b=fQ2dLjcr5jtTHtuQ5yYlLa4lxAOMH/8fymQacFrBX/cuR2go9wTzubZINY84a/lP5
         R8ntM1hbqlMcjMFC/JtEkTw+40iWKUrinZCgyytHyfE8fkHyjk+t9BFgOeyHMLwaBE
         X7aEkxQ89duZXu18eA2mV0KIacAC07AlubLx7IkM=
Date:   Wed, 13 Jan 2021 15:50:51 -0800
From:   akpm@linux-foundation.org
To:     cai@redhat.com, cl@linux.com, david@redhat.com,
        iamjoonsoo.kim@lge.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vdavydov.dev@gmail.com
Subject:  + mm-slab-slub-stop-taking-cpu-hotplug-lock.patch added
 to -mm tree
Message-ID: <20210113235051.5MIjZX9IB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab, slub: stop taking cpu hotplug lock
has been added to the -mm tree.  Its filename is
     mm-slab-slub-stop-taking-cpu-hotplug-lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slab-slub-stop-taking-cpu-hotplug-lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-slub-stop-taking-cpu-hotplug-lock.patch

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
Subject: mm, slab, slub: stop taking cpu hotplug lock

SLAB has been using get/put_online_cpus() around creating, destroying and
shrinking kmem caches since 95402b382901 ("cpu-hotplug: replace
per-subsystem mutexes with get_online_cpus()") in 2008, which is supposed
to be replacing a private mutex (cache_chain_mutex, called slab_mutex
today) with system-wide mechanism, but in case of SLAB it's in fact used
in addition to the existing mutex, without explanation why.

SLUB appears to have avoided the cpu hotplug lock initially, but gained it
due to common code unification, such as 20cea9683ecc ("mm, sl[aou]b: Move
kmem_cache_create mutex handling to common code").

Regardless of the history, checking if the hotplug lock is actually needed
today suggests that it's not, and therefore it's better to avoid this
system-wide lock and the ordering this imposes wrt other locks (such as
slab_mutex).

Specifically, in SLAB we have for_each_online_cpu() in do_tune_cpucache()
protected by slab_mutex, and cpu hotplug callbacks that also take the
slab_mutex, which is also taken by the common slab function that currently
also take the hotplug lock.  Thus the slab_mutex protection should be
sufficient.  Also per-cpu array caches are allocated for each possible
cpu, so not affected by their online/offline state.

In SLUB we have for_each_online_cpu() in functions that show statistics
and are already unprotected today, as racing with hotplug is not harmful. 
Otherwise SLUB relies on percpu allocator.  The slub_cpu_dead() hotplug
callback takes the slab_mutex.

To sum up, this patch removes get/put_online_cpus() calls from slab as it
should be safe without further adjustments.

Link: https://lkml.kernel.org/r/20210113131634.3671-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Qian Cai <cai@redhat.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/mm/slab_common.c~mm-slab-slub-stop-taking-cpu-hotplug-lock
+++ a/mm/slab_common.c
@@ -309,8 +309,6 @@ kmem_cache_create_usercopy(const char *n
 	const char *cache_name;
 	int err;
 
-	get_online_cpus();
-
 	mutex_lock(&slab_mutex);
 
 	err = kmem_cache_sanity_check(name, size);
@@ -359,8 +357,6 @@ kmem_cache_create_usercopy(const char *n
 out_unlock:
 	mutex_unlock(&slab_mutex);
 
-	put_online_cpus();
-
 	if (err) {
 		if (flags & SLAB_PANIC)
 			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
@@ -484,8 +480,6 @@ void kmem_cache_destroy(struct kmem_cach
 	if (unlikely(!s))
 		return;
 
-	get_online_cpus();
-
 	mutex_lock(&slab_mutex);
 
 	s->refcount--;
@@ -500,8 +494,6 @@ void kmem_cache_destroy(struct kmem_cach
 	}
 out_unlock:
 	mutex_unlock(&slab_mutex);
-
-	put_online_cpus();
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
@@ -518,12 +510,10 @@ int kmem_cache_shrink(struct kmem_cache
 {
 	int ret;
 
-	get_online_cpus();
 
 	kasan_cache_shrink(cachep);
 	ret = __kmem_cache_shrink(cachep);
 
-	put_online_cpus();
 	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
_

Patches currently in -mm which might be from vbabka@suse.cz are

maintainers-add-myself-as-slab-allocators-maintainer.patch
mm-slub-stop-freeing-kmem_cache_node-structures-on-node-offline.patch
mm-slab-slub-stop-taking-memory-hotplug-lock.patch
mm-slab-slub-stop-taking-cpu-hotplug-lock.patch

