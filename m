Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8F9ECAAD5
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiILE6h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiILE5F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:57:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841762871C
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20E78B80B21
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6D9C433D6;
        Mon, 12 Sep 2022 04:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958621;
        bh=JHuAeynQtBtdspKHvuxgneGpOWJJgNCksCdXRZ5f6TI=;
        h=Date:To:From:Subject:From;
        b=oBREWia3Okj/3lzfhnlflqjTfM/zbb/NREigTGzexclfkfG2ZQ5xsONjbrLeHPOth
         Dxsca1eHDFe8kQdYQUm5Ca5jxMdfUIwbLUDO6qCqZXpzlXf+fDG7/SQ5H0sQ7e20ic
         BFUZPAIcOho6bH57P5pphvIghUcYRZfyslCYJHA4=
Date:   Sun, 11 Sep 2022 21:57:00 -0700
To:     mm-commits@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        dan.carpenter@oracle.com, chenxiaosong2@huawei.com,
        anton@tuxera.com, yin31149@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ntfs-check-overflow-when-iterates-attr_records.patch removed from -mm tree
Message-Id: <20220912045701.AF6D9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ntfs: check overflow when iterating ATTR_RECORDs
has been removed from the -mm tree.  Its filename was
     ntfs-check-overflow-when-iterates-attr_records.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hawkins Jiawei <yin31149@gmail.com>
Subject: ntfs: check overflow when iterating ATTR_RECORDs
Date: Thu, 1 Sep 2022 00:09:38 +0800

Kernel iterates over ATTR_RECORDs in mft record in ntfs_attr_find(). 
Because the ATTR_RECORDs are next to each other, kernel can get the next
ATTR_RECORD from end address of current ATTR_RECORD, through current
ATTR_RECORD length field.

The problem is that during iteration, when kernel calculates the end
address of current ATTR_RECORD, kernel may trigger an integer overflow bug
in executing `a = (ATTR_RECORD*)((u8*)a + le32_to_cpu(a->length))`.  This
may wrap, leading to a forever iteration on 32bit systems.

This patch solves it by adding some checks on calculating end address
of current ATTR_RECORD during iteration.

Link: https://lkml.kernel.org/r/20220831160935.3409-4-yin31149@gmail.com
Link: https://lore.kernel.org/all/20220827105842.GM2030@kadam/
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: chenxiaosong (A) <chenxiaosong2@huawei.com>
Cc: syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/attrib.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ntfs/attrib.c~ntfs-check-overflow-when-iterates-attr_records
+++ a/fs/ntfs/attrib.c
@@ -617,6 +617,14 @@ static int ntfs_attr_find(const ATTR_TYP
 			return -ENOENT;
 		if (unlikely(!a->length))
 			break;
+
+		/* check whether ATTR_RECORD's length wrap */
+		if ((u8 *)a + le32_to_cpu(a->length) < (u8 *)a)
+			break;
+		/* check whether ATTR_RECORD's length is within bounds */
+		if ((u8 *)a + le32_to_cpu(a->length) > mrec_end)
+			break;
+
 		if (a->type != type)
 			continue;
 		/*
_

Patches currently in -mm which might be from yin31149@gmail.com are


