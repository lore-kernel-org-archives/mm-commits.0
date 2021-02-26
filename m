Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54091C433E9
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1002564F21
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhBZBTG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:19:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhBZBTB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:19:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3A4E64F2C;
        Fri, 26 Feb 2021 01:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302326;
        bh=0Ag/HJ1j9d8tj7P8IcswBjUmM1000KSxYpTWpTiEZq8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=br09TGjpoZfl0jmvcfjGXKM/5BLzbA0/nPyU9Ag7QKbs1i/ho5uafdVhTgHXCPblJ
         f5WGzLhXrkjxBhQIXrRo8KdkC4dNeoaMkgnsdpBttct8TJeYj7Ou/NfFlKxRgZJJdG
         L60YtuB9/FAFdo9UlEKHDlml3JqjKyAkRGcMqfsg=
Date:   Thu, 25 Feb 2021 17:18:45 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, daniel.vetter@ffwll.ch,
        daniel.vetter@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 054/118] mm/backing-dev.c: use might_alloc()
Message-ID: <20210226011845.1L0FuhJb6%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: mm/backing-dev.c: use might_alloc()

Now that my little helper has landed, use it more.  On top of the existing
check this also uses lockdep through the fs_reclaim annotations.

[akpm@linux-foundation.org: include linux/sched/mm.h]
Link: https://lkml.kernel.org/r/20210113135009.3606813-2-daniel.vetter@ffwll.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/backing-dev.c~bdi-use-might_alloc
+++ a/mm/backing-dev.c
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/mm.h>
+#include <linux/sched/mm.h>
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/writeback.h>
@@ -578,7 +579,7 @@ struct bdi_writeback *wb_get_create(stru
 {
 	struct bdi_writeback *wb;
 
-	might_sleep_if(gfpflags_allow_blocking(gfp));
+	might_alloc(gfp);
 
 	if (!memcg_css->parent)
 		return &bdi->wb;
_
