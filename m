Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2A8C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F07261181
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbhKICRS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:17:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238818AbhKICRN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:17:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 315346117A;
        Tue,  9 Nov 2021 02:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636424068;
        bh=hMSGRwZY2pMFdi+bMzZ0gswZNmQ1CqJyPMIJZKnMX90=;
        h=Date:From:To:Subject:From;
        b=QTaJjkgUlnTi+ycHwwh3FIDZwdO73NPixhsYyi3BZhfOzNu/avjtAOkyjGd6vkJqi
         xE0xBJ+c++e5R8rDP1QHkSSBKcOhH2IwfWENx/kL8sPcQCMT55n5YTnONBKtkg8u/w
         eFJlNVl2Qvnkj2NZKDuV3jP1I6uFcz9AgkKuebIE=
Date:   Mon, 08 Nov 2021 18:14:27 -0800
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, andreyknvl@gmail.com, daniel@ffwll.ch,
        dvyukov@google.com, geert@linux-m68k.org, glider@google.com,
        imran.f.khan@oracle.com, maarten.lankhorst@linux.intel.com,
        mm-commits@vger.kernel.org, mripard@kernel.org,
        ryabinin.a.a@gmail.com, tzimmermann@suse.de, vbabka@suse.cz
Subject:  [folded-merged]
 lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v2.patch
 removed from -mm tree
Message-ID: <20211109021427.9HD7NHBrD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v2
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v2.patch

This patch was dropped because it was folded into lib-stackdepot-add-helper-to-print-stack-entries-into-buffer.patch

------------------------------------------------------
From: Imran Khan <imran.f.khan@oracle.com>
Subject: lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v2

fix build error

Link: https://lkml.kernel.org/r/20210915175321.3472770-4-imran.f.khan@oracle.com
Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_mm.c                |    2 +-
 drivers/gpu/drm/i915/intel_runtime_pm.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_mm.c~lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v2
+++ a/drivers/gpu/drm/drm_mm.c
@@ -131,7 +131,7 @@ static void show_leaks(struct drm_mm *mm
 			continue;
 		}
 
-		stack_depot_snprint(node->stack, buf, BUFSZ);
+		stack_depot_snprint(node->stack, buf, BUFSZ, 0);
 		DRM_ERROR("node [%08llx + %08llx]: inserted at\n%s",
 			  node->start, node->size, buf);
 	}
--- a/drivers/gpu/drm/i915/intel_runtime_pm.c~lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v2
+++ a/drivers/gpu/drm/i915/intel_runtime_pm.c
@@ -193,7 +193,7 @@ __print_intel_runtime_pm_wakeref(struct
 		rep = 1;
 		while (i + 1 < dbg->count && dbg->owners[i + 1] == stack)
 			rep++, i++;
-		stack_depot_print(stack, buf, PAGE_SIZE, 2);
+		stack_depot_snprint(stack, buf, PAGE_SIZE, 2);
 		drm_printf(p, "Wakeref x%lu taken at:\n%s", rep, buf);
 	}
 
_

Patches currently in -mm which might be from imran.f.khan@oracle.com are

lib-stackdepot-check-stackdepot-handle-before-accessing-slabs.patch
lib-stackdepot-add-helper-to-print-stack-entries.patch
lib-stackdepot-add-helper-to-print-stack-entries-into-buffer.patch
lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v3.patch

