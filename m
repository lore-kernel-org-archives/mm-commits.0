Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D57C433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4485B64F26
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbhBXUDQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:55902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235186AbhBXUCe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57F9664F23;
        Wed, 24 Feb 2021 20:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196876;
        bh=sUsO3EhZIzAc5iCkRXCgeaT0vg9qFPJbgpzN4SykNpk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ik8LH3+0Gw/ORMtmV4I3olNvPpSs++/WKVjHKEApDG7NypUQTcGFqCBb9+xQxOFAG
         aspsFWyZyCQ3pmw71jyHId4lMWycIzm1TNE83WBGCUbjAY0PnkxeZjrOAgdiiq2lkD
         ZjGp3DQxWdjGotePAtLRxYJyF9k1+MjCLnfFiPWo=
Date:   Wed, 24 Feb 2021 12:01:15 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@redhat.com, cl@linux.com,
        david@redhat.com, iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [patch 020/173] mm, slab, slub: stop taking cpu hotplug
 lock
Message-ID: <20210224200115.Sn4XTbiPC%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
