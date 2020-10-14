Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 245B3C43467
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBBFE22254
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708962;
	bh=5NQuXl8HrR4MFunF6S44wC7LllCGh1N4YBM8y0DfO8g=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=K5fHNqO90B2kNv5qlrznbD3AoSRjqpwwJLL0ISI/mM3ix24M8UFmLhX8Gvy13pJKt
	 DNjXTQWQmXc2WXv76gIRPI1bDDxESUSAnLXACU6Er2Xn7sfsrXJ/Yrpptwrg84P7j+
	 6HBjeJCGArl/jwK/m0feMH52RD2hsQC4sFyLxqWY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbgJNU4C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgJNU4C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:56:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A714022250;
        Wed, 14 Oct 2020 20:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708961;
        bh=5NQuXl8HrR4MFunF6S44wC7LllCGh1N4YBM8y0DfO8g=;
        h=Date:From:To:Subject:From;
        b=PL9lMxo++laagLtmtwXC2Ax7BlvQprDYEbWZTEZtZ+hqrQwM9X6u1DQpIy0l0bhbz
         tbhmmplHP5tQS+9dridO9XuMUdDrq30lZDICAuZTQMEk8/I7j3qJO/krjYFisC2Acl
         tdK96H9+Rle33dW86fsIK6R6W3B1t3PjMQIh/9ig=
Date:   Wed, 14 Oct 2020 13:56:01 -0700
From:   akpm@linux-foundation.org
To:     anton@tuxera.com, mm-commits@vger.kernel.org, rkovhaev@gmail.com
Subject:  [merged]
 ntfs-add-check-for-mft-record-size-in-superblock.patch removed from -mm
 tree
Message-ID: <20201014205601.rwKgz7HFr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: add check for mft record size in superblock
has been removed from the -mm tree.  Its filename was
     ntfs-add-check-for-mft-record-size-in-superblock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rustam Kovhaev <rkovhaev@gmail.com>
Subject: ntfs: add check for mft record size in superblock

Number of bytes allocated for mft record should be equal to the mft record
size stored in ntfs superblock as reported by syzbot, userspace might
trigger out-of-bounds read by dereferencing ctx->attr in ntfs_attr_find()

Link: https://syzkaller.appspot.com/bug?extid=aed06913f36eff9b544e
Link: https://lkml.kernel.org/r/20200824022804.226242-1-rkovhaev@gmail.com
Reported-by: syzbot+aed06913f36eff9b544e@syzkaller.appspotmail.com
Tested-by: syzbot+aed06913f36eff9b544e@syzkaller.appspotmail.com
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ntfs/inode.c~ntfs-add-check-for-mft-record-size-in-superblock
+++ a/fs/ntfs/inode.c
@@ -1810,6 +1810,12 @@ int ntfs_read_inode_mount(struct inode *
 		brelse(bh);
 	}
 
+	if (le32_to_cpu(m->bytes_allocated) != vol->mft_record_size) {
+		ntfs_error(sb, "Incorrect mft record size %u in superblock, should be %u.",
+				le32_to_cpu(m->bytes_allocated), vol->mft_record_size);
+		goto err_out;
+	}
+
 	/* Apply the mst fixups. */
 	if (post_read_mst_fixup((NTFS_RECORD*)m, vol->mft_record_size)) {
 		/* FIXME: Try to use the $MFTMirr now. */
_

Patches currently in -mm which might be from rkovhaev@gmail.com are


