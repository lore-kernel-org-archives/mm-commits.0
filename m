Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A916C43334
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 04:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbiGQEd1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 00:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiGQEd0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 00:33:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C49D205E2
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 21:33:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC8C460F98
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 04:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C154C3411E;
        Sun, 17 Jul 2022 04:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658032404;
        bh=mlXVxYYBWE4bWNcFJoF0cN1rzj4cWZRkqJ8AEjuPyzM=;
        h=Date:To:From:Subject:From;
        b=RgUAS8UW1lbc6m3BqGdqnAm970mKp+VVejF+Ch6VInIblIFFuK1KtOoT3ncX/99C+
         QDdrA6rmflf4I0eOvBX6ExXmjNogr+SATtGVZD0ylFXn3wrdf930u3zKTpEugSGvIP
         qgaFZ1era4SUwnjaZOsq4vutEdDa1lpKbGFLhSSs=
Date:   Sat, 16 Jul 2022 21:33:23 -0700
To:     mm-commits@vger.kernel.org, zhangxiaoxu5@huawei.com,
        yi.zhang@huawei.com, yin31149@gmail.com, liuyongqiang13@huawei.com,
        anton@tuxera.com, chenxiaosong2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3.patch removed from -mm tree
Message-Id: <20220717043324.1C154C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3
has been removed from the -mm tree.  Its filename was
     ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3.patch

This patch was dropped because it was folded into ntfs-fix-use-after-free-in-ntfs_ucsncmp.patch

------------------------------------------------------
From: ChenXiaoSong <chenxiaosong2@huawei.com>
Subject: ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3
Date: Sat, 9 Jul 2022 14:45:11 +0800

Cleanup suggested by Hawkins Jiawei

Link: https://lkml.kernel.org/r/20220709064511.3304299-1-chenxiaosong2@huawei.com
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Cc: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/attrib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs/attrib.c~ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3
+++ a/fs/ntfs/attrib.c
@@ -595,7 +595,7 @@ static int ntfs_attr_find(const ATTR_TYP
 		u8 *mrec_end = (u8 *)ctx->mrec +
 		               le32_to_cpu(ctx->mrec->bytes_allocated);
 		u8 *name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
-		               a->name_length;
+		               a->name_length * sizeof(ntfschar);
 		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > mrec_end ||
 		    name_end > mrec_end)
 			break;
_

Patches currently in -mm which might be from chenxiaosong2@huawei.com are

ntfs-fix-use-after-free-in-ntfs_ucsncmp.patch

