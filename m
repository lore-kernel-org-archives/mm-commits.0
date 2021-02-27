Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBD7C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F28F64F3E
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhB0CbP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:31:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230165AbhB0Cap (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 690E464F1F;
        Sat, 27 Feb 2021 02:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393023;
        bh=4A1XLS0eo+gtRUbzXyaquVfY8ik3boK3nUYm5s3bRSA=;
        h=Date:From:To:Subject:From;
        b=eyyOuJCs9qHMe30ycWrxb2uXmhSxqdOb7+MBAD54snuRjGsNhOLNwKuLAoBiRT/Tw
         Mh2ynihFVGrIv5mDxSSJaILK6BM3M1itEEXIZd1qy13XDIDg/Fo9ykhYPwOEMcJPu3
         nPq+hkoYeYXsbM0CfyP2n5aH/Na/IPqiGyorv+jg=
Date:   Fri, 26 Feb 2021 18:30:23 -0800
From:   akpm@linux-foundation.org
To:     daniel.vetter@ffwll.ch, daniel.vetter@intel.com,
        mm-commits@vger.kernel.org
Subject:  [merged] bdi-use-might_alloc.patch removed from -mm tree
Message-ID: <20210227023023.SDopeERGh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/backing-dev.c: use might_alloc()
has been removed from the -mm tree.  Its filename was
     bdi-use-might_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are


