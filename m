Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC970C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 693DF23750
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731063AbgLOXQ5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:16:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731037AbgLOXQt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:16:49 -0500
Date:   Tue, 15 Dec 2020 15:16:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074181;
        bh=GPmr4sXxjTbCQolMBLFzb2XKkIpUq//9qcZKO8ac4QM=;
        h=From:To:Subject:From;
        b=EHoiP7mSk5EPtnqqJlVsDKnHGRHEmVVUC+Ynrsr4vOgUBqzqrU07CREw/RUmk6sWG
         EsEl5evdfNAxGwnt6NTgAo/kAbe/xBkp+9QHGciqpLex+KDNTgtCPr9hP72OIEJQlm
         ULgmnxI+/5jeEky2FNR7iHwD9DgWdD9SNAos1Av8=
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
Subject:  [merged] vhost-vringh-use-krealloc_array.patch removed
 from -mm tree
Message-ID: <20201215231619.PFxlA2c1p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vhost: vringh: use krealloc_array()
has been removed from the -mm tree.  Its filename was
     vhost-vringh-use-krealloc_array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: vhost: vringh: use krealloc_array()

Use the helper that checks for overflows internally instead of manually
calculating the size of the new array.

Link: https://lkml.kernel.org/r/20201109110654.12547-5-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
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

 drivers/vhost/vringh.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/vhost/vringh.c~vhost-vringh-use-krealloc_array
+++ a/drivers/vhost/vringh.c
@@ -198,7 +198,8 @@ static int resize_iovec(struct vringh_ki
 
 	flag = (iov->max_num & VRINGH_IOV_ALLOCATED);
 	if (flag)
-		new = krealloc(iov->iov, new_num * sizeof(struct iovec), gfp);
+		new = krealloc_array(iov->iov, new_num,
+				     sizeof(struct iovec), gfp);
 	else {
 		new = kmalloc_array(new_num, sizeof(struct iovec), gfp);
 		if (new) {
_

Patches currently in -mm which might be from bgolaszewski@baylibre.com are


