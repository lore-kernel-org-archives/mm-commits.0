Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B280C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiANWEA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:04:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45690 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiANWEA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:04:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0F2861FF8
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7327C36AE9;
        Fri, 14 Jan 2022 22:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197839;
        bh=iOVyw2IzQSARaWNOIL3nAQMty30KC8WIeK0cp2QJhL8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QCQTMvAIal2ShTmLmYp3amdPcmFbO2oSKRCpFQ9s1wBfPh2sfp6qzK5xWf35Q7zJS
         KMc6Dt54qytQ3FbsLUFJ6DOvrfFLSN9MrNXtDLI7Ep3wtffRTYPoFfBpGI5eyhiucI
         RwfAVDh5klhGzKrXWUvHCf1EoaffzGjqPD0SZN3E=
Date:   Fri, 14 Jan 2022 14:03:58 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, dvyukov@google.com,
        elver@google.com, glider@google.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 021/146] mm/slab_common: use WARN() if cache still
 has objects on destroy
Message-ID: <20220114220358.-PVz8K_7b%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: mm/slab_common: use WARN() if cache still has objects on destroy

Calling kmem_cache_destroy() while the cache still has objects allocated
is a kernel bug, and will usually result in the entire cache being leaked.
While the message in kmem_cache_destroy() resembles a warning, it is
currently not implemented using a real WARN().

This is problematic for infrastructure testing the kernel, all of which
rely on the specific format of WARN()s to pick up on bugs.

Some 13 years ago this used to be a simple WARN_ON() in slub, but
d629d8195793 ("slub: improve kmem_cache_destroy() error message") changed
it into an open-coded warning to avoid confusion with a bug in slub
itself.

Instead, turn the open-coded warning into a real WARN() with the message
preserved, so that test systems can actually identify these issues, and we
get all the other benefits of using a normal WARN().  The warning message
is extended with "when called from <caller-ip>" to make it even clearer
where the fault lies.

For most configurations this is only a cosmetic change, however, note that
WARN() here will now also respect panic_on_warn.

Link: https://lkml.kernel.org/r/20211102170733.648216-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/mm/slab_common.c~mm-slab_common-use-warn-if-cache-still-has-objects-on-destroy
+++ a/mm/slab_common.c
@@ -489,8 +489,6 @@ void slab_kmem_cache_release(struct kmem
 
 void kmem_cache_destroy(struct kmem_cache *s)
 {
-	int err;
-
 	if (unlikely(!s))
 		return;
 
@@ -501,12 +499,9 @@ void kmem_cache_destroy(struct kmem_cach
 	if (s->refcount)
 		goto out_unlock;
 
-	err = shutdown_cache(s);
-	if (err) {
-		pr_err("%s %s: Slab cache still has objects\n",
-		       __func__, s->name);
-		dump_stack();
-	}
+	WARN(shutdown_cache(s),
+	     "%s %s: Slab cache still has objects when called from %pS",
+	     __func__, s->name, (void *)_RET_IP_);
 out_unlock:
 	mutex_unlock(&slab_mutex);
 	cpus_read_unlock();
_
