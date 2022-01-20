Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B69C4C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347573AbiATVXk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347243AbiATVXj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91659C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:23:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B7FBB81E66
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA918C340E0;
        Thu, 20 Jan 2022 21:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713817;
        bh=AYJKVBDQOIuwUkrvqehVkcYCOyVz6WkfSM8nHODkTVQ=;
        h=Date:From:To:Subject:From;
        b=TMZUeH3r68siy75N7Ld35/pEDL7EW2tpFj/ns/UqVH9nR/KUV6GfERe35R0+Nl0t8
         eGWujBRoVKoaPAxKMWS2mwKxxZSjx0OgG6F2yp7Nz/yMA8aOva5nxwKjelPzMernX5
         SOfUOGq8oq4rgL6Dg1tlrZsBM8XkXJSjIE7v666M=
Date:   Thu, 20 Jan 2022 13:23:36 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, dvyukov@google.com, elver@google.com,
        glider@google.com, iamjoonsoo.kim@lge.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [merged]
 mm-slab_common-use-warn-if-cache-still-has-objects-on-destroy.patch removed
 from -mm tree
Message-ID: <20220120212336.h-4jD_MVm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common: use WARN() if cache still has objects on destroy
has been removed from the -mm tree.  Its filename was
     mm-slab_common-use-warn-if-cache-still-has-objects-on-destroy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from elver@google.com are

lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save.patch

