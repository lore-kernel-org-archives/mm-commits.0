Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21DFFC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 23:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 096DF60234
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 23:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhIOXCw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232733AbhIOXCu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 19:02:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B31DE61185;
        Wed, 15 Sep 2021 23:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631746891;
        bh=Gn9RjbyjmzcJX4Qh9ZlHIN2F2D2NiYdw89+oHsBpT+g=;
        h=Date:From:To:Subject:From;
        b=iv+tB9YFQ7Lt05h0tG+h/k4yBeBFcKNm2+9Z3VINy5RcwNdD+2fLfLD9aDQncJMsy
         1Z88qSG0N5UmY9gZiRur2qmWrz4A/m+wP6cQ2KWF6k9y0/E2jvrwiW0N0/9DWm+fuj
         6kRQi/b3WRi2pxO7Uzy4nzE7WceVvDARZTCnl2HI=
Date:   Wed, 15 Sep 2021 16:01:30 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, andreyknvl@gmail.com, daniel@ffwll.ch,
        dvyukov@google.com, geert@linux-m68k.org, glider@google.com,
        imran.f.khan@oracle.com, maarten.lankhorst@linux.intel.com,
        mm-commits@vger.kernel.org, mripard@kernel.org,
        ryabinin.a.a@gmail.com, tzimmermann@suse.de, vbabka@suse.cz
Subject:  +
 lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v2.patch added
 to -mm tree
Message-ID: <20210915230130.ohUFxXkcO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v2
has been added to the -mm tree.  Its filename is
     lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v2.patch

