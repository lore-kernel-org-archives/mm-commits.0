Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 831C3C2BBD4
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B5AC22CF8
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgLPAAX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727410AbgLOX1s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:48 -0500
Date:   Tue, 15 Dec 2020 15:16:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074169;
        bh=O8B1KNJ0eSY6OVi9v2eSsMMAetPRrgnccGNvjQW6JY0=;
        h=From:To:Subject:From;
        b=0Gmyk+tnfS097kxGyfSqhWC0TRoBdgpPKJxYxBXT3Ap75+hCqLiWgxrTbl78Hfzl0
         2ppGsDtQV5BNH15pNW86R6Gp30tN3kIFF6dVf84KhCu9lxKVGwTzrjO08rhiNXKQKM
         3KfwK8NK7LB0dRQBRJx80tUi3raw1a1MTyV1mwLI=
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
Subject:  [merged]
 mm-slab-clarify-kreallocs-behavior-with-__gfp_zero.patch removed from -mm
 tree
Message-ID: <20201215231607.Et_uWt3uc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slab: clarify krealloc()'s behavior with __GFP_ZERO
has been removed from the -mm tree.  Its filename was
     mm-slab-clarify-kreallocs-behavior-with-__gfp_zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: mm: slab: clarify krealloc()'s behavior with __GFP_ZERO

Patch series "slab: provide and use krealloc_array()", v3.

Andy brought to my attention the fact that users allocating an array of
equally sized elements should check if the size multiplication doesn't
overflow.  This is why we have helpers like kmalloc_array().

However we don't have krealloc_array() equivalent and there are many users
who do their own multiplication when calling krealloc() for arrays.

This series provides krealloc_array() and uses it in a couple places.

A separate series will follow adding devm_krealloc_array() which is needed
in the xilinx adc driver.


This patch (of 9):

__GFP_ZERO is ignored by krealloc() (unless we fall-back to kmalloc()
path, in which case it's honored).  Point that out in the kerneldoc.

Link: https://lkml.kernel.org/r/20201109110654.12547-1-brgl@bgdev.pl
Link: https://lkml.kernel.org/r/20201109110654.12547-2-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: James Morse <james.morse@arm.com>
Cc: Robert Richter <rric@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/slab_common.c~mm-slab-clarify-kreallocs-behavior-with-__gfp_zero
+++ a/mm/slab_common.c
@@ -1091,9 +1091,9 @@ static __always_inline void *__do_kreall
  * @flags: the type of memory to allocate.
  *
  * The contents of the object pointed to are preserved up to the
- * lesser of the new and old sizes.  If @p is %NULL, krealloc()
- * behaves exactly like kmalloc().  If @new_size is 0 and @p is not a
- * %NULL pointer, the object pointed to is freed.
+ * lesser of the new and old sizes (__GFP_ZERO flag is effectively ignored).
+ * If @p is %NULL, krealloc() behaves exactly like kmalloc().  If @new_size
+ * is 0 and @p is not a %NULL pointer, the object pointed to is freed.
  *
  * Return: pointer to the allocated memory or %NULL in case of error
  */
_

Patches currently in -mm which might be from bgolaszewski@baylibre.com are


