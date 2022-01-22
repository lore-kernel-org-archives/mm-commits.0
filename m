Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC59C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbiAVBXw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:23:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50850 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiAVBXu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:23:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27F0661ABC
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B23C340E1;
        Sat, 22 Jan 2022 01:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814629;
        bh=dJjqOotdUulwc+fFLNVVQ5D4ldLJ+bt3sGgE7FILiek=;
        h=Date:From:To:Subject:From;
        b=G7BBkVep6/Uq3UkXY8WQfBXntVgD6jH+6E0z0m9UbbTbCy/4V6yXiEH0Llfn4ASxz
         /IuIoGhEvOtupVFPGqc8w07wp08EMtdFCEVgyxm+55EGvWM1zwn9nlv4flsmt6nfBW
         NBKdbixA8KucEDYmvNi41T+PjHwozKsf/W5AwU5U=
Date:   Fri, 21 Jan 2022 17:23:48 -0800
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, andreyknvl@gmail.com, daniel@ffwll.ch,
        dvyukov@google.com, elver@google.com, geert@linux-m68k.org,
        glider@google.com, glittao@gmail.com, imran.f.khan@oracle.com,
        jani.nikula@intel.com, maarten.lankhorst@linux.intel.com,
        mm-commits@vger.kernel.org, mripard@kernel.org,
        naresh.kamboju@linaro.org, ryabinin.a.a@gmail.com,
        sfr@canb.auug.org.au, tzimmermann@suse.de, vbabka@suse.cz,
        vjitta@codeaurora.org
Subject:  [folded-merged]
 =?US-ASCII?Q?lib-stackdepot-allow-optional-init-and-stack=5Ftable-allocat?=
 =?US-ASCII?Q?ion-by-kvmalloc-fixup3.patch?= removed from -mm tree
Message-ID: <20220122012348.dLHJ51Cj2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: allow optional init and stack_table allocation by kvmalloc() - fixup3
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup3.patch

This patch was dropped because it was folded into lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: lib/stackdepot: allow optional init and stack_table allocation by kvmalloc() - fixup3

Due to cd06ab2fd48f ("drm/locking: add backtrace for locking contended
locks without backoff") landing recently to -next adding a new stack depot
user in drivers/gpu/drm/drm_modeset_lock.c we need to add an appropriate
call to stack_depot_init() there as well.

Link: https://lkml.kernel.org/r/2a692365-cfa1-64f2-34e0-8aa5674dce5e@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Marco Elver <elver@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Oliver Glitta <glittao@gmail.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_modeset_lock.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/drm_modeset_lock.c~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup3
+++ a/drivers/gpu/drm/drm_modeset_lock.c
@@ -107,6 +107,11 @@ static void __drm_stack_depot_print(depo
 
 	kfree(buf);
 }
+
+static void __drm_stack_depot_init(void)
+{
+	stack_depot_init();
+}
 #else /* CONFIG_DRM_DEBUG_MODESET_LOCK */
 static depot_stack_handle_t __drm_stack_depot_save(void)
 {
@@ -115,6 +120,9 @@ static depot_stack_handle_t __drm_stack_
 static void __drm_stack_depot_print(depot_stack_handle_t stack_depot)
 {
 }
+static void __drm_stack_depot_init(void)
+{
+}
 #endif /* CONFIG_DRM_DEBUG_MODESET_LOCK */
 
 /**
@@ -359,6 +367,7 @@ void drm_modeset_lock_init(struct drm_mo
 {
 	ww_mutex_init(&lock->mutex, &crtc_ww_class);
 	INIT_LIST_HEAD(&lock->head);
+	__drm_stack_depot_init();
 }
 EXPORT_SYMBOL(drm_modeset_lock_init);
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc.patch
lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup4.patch

