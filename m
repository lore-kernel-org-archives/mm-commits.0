Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5563C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 01:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbiCGBCM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbiCGBCL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 20:02:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E86B65C7
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 17:01:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EFBFB80F88
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 01:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C96C340EC;
        Mon,  7 Mar 2022 01:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646614876;
        bh=71gb6eXey6JNW76DbBnCNG++sbs+jkkzsnL/1l7sz/A=;
        h=Date:To:From:Subject:From;
        b=HVT7niZ1ZNKSp6VWFISPrC/9QtlOA4dod8kdMMxPV1sOnvTrQkD/JID4YMawhEXeZ
         /RgliK1ZJavIISTTvhtrJ1vTNwQ8KfM/IXP76CjRXcwRdGMYn4gNpF4jiach5yZPD0
         we57OjdyAu+BP7bmqFe5gudYg3yMTv9M4qHMkvQA=
Date:   Sun, 06 Mar 2022 17:01:15 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com, lpf.vector@gmail.com,
        libang.linuxer@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-comments-about-vmap_area-struct.patch added to -mm tree
Message-Id: <20220307010116.00C96C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix comments about vmap_area struct
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-comments-about-vmap_area-struct.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-comments-about-vmap_area-struct.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-comments-about-vmap_area-struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bang Li <libang.linuxer@gmail.com>
Subject: mm/vmalloc: fix comments about vmap_area struct

The vmap_area_root should be in the "busy" tree and the
free_vmap_area_root should be in the "free" tree.

Link: https://lkml.kernel.org/r/20220305011510.33596-1-libang.linuxer@gmail.com
Fixes: 688fcbfc06e4 ("mm/vmalloc: modify struct vmap_area to reduce its size")
Signed-off-by: Bang Li <libang.linuxer@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Pengfei Li <lpf.vector@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-fix-comments-about-vmap_area-struct
+++ a/include/linux/vmalloc.h
@@ -80,8 +80,8 @@ struct vmap_area {
 	/*
 	 * The following two variables can be packed, because
 	 * a vmap_area object can be either:
-	 *    1) in "free" tree (root is vmap_area_root)
-	 *    2) or "busy" tree (root is free_vmap_area_root)
+	 *    1) in "free" tree (root is free_vmap_area_root)
+	 *    2) or "busy" tree (root is vmap_area_root)
 	 */
 	union {
 		unsigned long subtree_max_size; /* in "free" tree */
_

Patches currently in -mm which might be from libang.linuxer@gmail.com are

mm-vmalloc-fix-comments-about-vmap_area-struct.patch

