Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE689C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0EF521744
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779191;
	bh=F4OlPeqedwfHbAcT7QZEdPG3RmYjxHhnqaiYQisL834=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1lqw6OeW62DKXDYDQRm5aAfR5RPMg5gk27iI6Fh6W+zeiDSgizOsO4U3Qtd3WTNeX
	 yx6cto2c4SWTAEiAoBDIfhJlo3GsbqlhMaPh76abZKrShbHC5LNH/fR789YT9mI/kx
	 sr+9i4L/Q5BuKx06bcg2sfQUmGMviXzRhfokbagw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgHGFqb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgHGFqb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:46:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E85D20866;
        Fri,  7 Aug 2020 05:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779190;
        bh=F4OlPeqedwfHbAcT7QZEdPG3RmYjxHhnqaiYQisL834=;
        h=Date:From:To:Subject:From;
        b=MV6pn0S+j+Zigp3nn9be1g6EPeJlWwb91x+osA/groWp2UgmC8uV+JchzvcYjT2fP
         iJVTAjKBkhRRC4N+yNnnADh5afVOyln6VVlePrhj2AV6npOvL399xMvMIi+Qzgv3gw
         AAX1l0u+0JNDPow91lYqNPSj7JVSR4eRn1wpjKes=
Date:   Thu, 06 Aug 2020 22:46:29 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vjitta@codeaurora.org
Subject:  [folded-merged]
 mm-slub-introduce-kmem_cache_debug_flags-fix.patch removed from -mm tree
Message-ID: <20200807054629.gS1pIT1wI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: introduce kmem_cache_debug_flags()-fix
has been removed from the -mm tree.  Its filename was
     mm-slub-introduce-kmem_cache_debug_flags-fix.patch

This patch was dropped because it was folded into mm-slub-introduce-kmem_cache_debug_flags.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: introduce kmem_cache_debug_flags()-fix

Change return from int to bool, per Kees.  Add VM_WARN_ON_ONCE() for
invalid flags, per Roman.

Link: http://lkml.kernel.org/r/949b90ed-e0f0-07d7-4d21-e30ec0958a7c@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slub-introduce-kmem_cache_debug_flags-fix
+++ a/mm/slub.c
@@ -127,16 +127,17 @@ DEFINE_STATIC_KEY_FALSE(slub_debug_enabl
  * cache. Use only for flags parsed by setup_slub_debug() as it also enables
  * the static key.
  */
-static inline int kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t flags)
+static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t flags)
 {
+	VM_WARN_ON_ONCE(!(flags & SLAB_DEBUG_FLAGS));
 #ifdef CONFIG_SLUB_DEBUG
 	if (static_branch_unlikely(&slub_debug_enabled))
 		return s->flags & flags;
 #endif
-	return 0;
+	return false;
 }
 
-static inline int kmem_cache_debug(struct kmem_cache *s)
+static inline bool kmem_cache_debug(struct kmem_cache *s)
 {
 	return kmem_cache_debug_flags(s, SLAB_DEBUG_FLAGS);
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch
mm-slub-make-some-slub_debug-related-attributes-read-only.patch
mm-slub-remove-runtime-allocation-order-changes.patch
mm-slub-make-remaining-slub_debug-related-attributes-read-only.patch
mm-slub-make-reclaim_account-attribute-read-only.patch
mm-slub-introduce-static-key-for-slub_debug.patch
mm-slub-introduce-kmem_cache_debug_flags.patch
mm-slub-extend-checks-guarded-by-slub_debug-static-key.patch
mm-slab-slub-move-and-improve-cache_from_obj.patch
mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj.patch
mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj-fix.patch
mm-page_alloc-use-unlikely-in-task_capc.patch

