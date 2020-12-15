Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B281BC4743A
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A97922D08
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbgLPAA1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgLOX1v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:51 -0500
Date:   Tue, 15 Dec 2020 15:16:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074193;
        bh=vJxSiLQxWRe7CDLX2+zeaUc90AL2SssXebevjEmqvhs=;
        h=From:To:Subject:From;
        b=iUgEYOlM2G22al+8m27gPBVBF2ZMrTBpGctYCK4I2GlGgreFMXYv2XY+9OmSujjAe
         yU8VxZoYN5y6TPSMEDinr9PuxBrZhYTFl9doSKB9ncb9Hed6Du/lQYJKBQJ4Mi5FQL
         uKAFV9Zk3L9Z0jnk6I3uihegSaVdCtuDf7qA6BYY=
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, alexander.shishkin@linux.intel.com,
        andriy.shevchenko@linux.intel.com, bgolaszewski@baylibre.com,
        bp@alien8.de, bp@suse.de, christian.koenig@amd.com, cl@linux.com,
        daniel.vetter@ffwll.ch, daniel@ffwll.ch, gustavo@padovan.org,
        iamjoonsoo.kim@lge.com, james.morse@arm.com, jasowang@redhat.com,
        linus.walleij@linaro.org, maarten.lankhorst@linux.intel.com,
        mchehab@kernel.org, mm-commits@vger.kernel.org, mripard@kernel.org,
        mst@redhat.com, penberg@kernel.org, perex@perex.cz,
        rientjes@google.com, rric@kernel.org, sumit.semwal@linaro.org,
        tiwai@suse.com, tiwai@suse.de, tony.luck@intel.com,
        tzimmermann@suse.de, vbabka@suse.cz
Subject:  [merged] drm-atomic-use-krealloc_array.patch removed from
 -mm tree
Message-ID: <20201215231631.RTfr18rmg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm: atomic: use krealloc_array()
has been removed from the -mm tree.  Its filename was
     drm-atomic-use-krealloc_array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: drm: atomic: use krealloc_array()

Use the helper that checks for overflows internally instead of manually
calculating the size of the new array.

Link: https://lkml.kernel.org/r/20201109110654.12547-8-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: David Rientjes <rientjes@google.com>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: James Morse <james.morse@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Robert Richter <rric@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_atomic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_atomic.c~drm-atomic-use-krealloc_array
+++ a/drivers/gpu/drm/drm_atomic.c
@@ -960,7 +960,8 @@ drm_atomic_get_connector_state(struct dr
 		struct __drm_connnectors_state *c;
 		int alloc = max(index + 1, config->num_connector);
 
-		c = krealloc(state->connectors, alloc * sizeof(*state->connectors), GFP_KERNEL);
+		c = krealloc_array(state->connectors, alloc,
+				   sizeof(*state->connectors), GFP_KERNEL);
 		if (!c)
 			return ERR_PTR(-ENOMEM);
 
_

Patches currently in -mm which might be from bgolaszewski@baylibre.com are


