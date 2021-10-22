Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AA2C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17EE8615E3
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbhJVDlW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 23:41:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232868AbhJVDlW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 23:41:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDF10610A4;
        Fri, 22 Oct 2021 03:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634873945;
        bh=x9uCVkue4k9yjuyeBfXPFQASk0lVhhwClI/1K8sOjDI=;
        h=Date:From:To:Subject:From;
        b=2DAUiw6VN2crA1d4F8No++j2j72IJO8BPfz+pOs7jexuXLT0HIhstMkv6KUkU49R8
         lhX7J+DkmbilEgG2NwZ5JA6imOQnoLTsscgQ0JcQfv3W8dR0u1lLaAwNuLRwGifQNm
         VVD0b2ouyWsuD25PfjmzFrLhM4QINqgfqZ4ARVbg=
Date:   Thu, 21 Oct 2021 20:39:04 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, andreyknvl@gmail.com, daniel@ffwll.ch,
        dvyukov@google.com, elver@google.com, geert@linux-m68k.org,
        glider@google.com, glittao@gmail.com, imran.f.khan@oracle.com,
        jani.nikula@intel.com, maarten.lankhorst@linux.intel.com,
        mm-commits@vger.kernel.org, mripard@kernel.org,
        naresh.kamboju@linaro.org, ryabinin.a.a@gmail.com,
        sfr@canb.auug.org.au, tzimmermann@suse.de, vbabka@suse.cz,
        vjitta@codeaurora.org
Subject:  +
 =?US-ASCII?Q?lib-stackdepot-allow-optional-init-and-stack=5Ftable-allocat?=
 =?US-ASCII?Q?ion-by-kvmalloc-fixup3.patch?= added to -mm tree
Message-ID: <20211022033904.5G4B3GgXM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: allow optional init and stack_table allocation by kvmalloc() - fixup3
has been added to the -mm tree.  Its filename is
     lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup3.patch

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

mm-slub-change-percpu-partial-accounting-from-objects-to-pages.patch
mm-slub-increase-default-cpu-partial-list-sizes.patch
lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc.patch
lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix-2.patch
lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup3.patch

