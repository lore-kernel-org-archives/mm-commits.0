Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544B4C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FAD4611C0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhKEUjj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231842AbhKEUjj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:39:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9EDF61242;
        Fri,  5 Nov 2021 20:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144619;
        bh=3V0DVgLklK+DGdkQfrAXN3hgTsfYdiu9kND4RGYZZwQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=anFzLvbsvWXpWiDh6UeSUzV+ekyMFYobQleZO/gzuLlyHl68H4W+wjDukFNeS9chf
         deU5KLVNAiPiVLH0kxULAZ7wgbM+spzlL7GlxJHRHTfAx7TgxSMimziNNMZ403yVuz
         63HnCsqcaW+zSOJv24GNUmWFGiRISvsGT1VcZmMA=
Date:   Fri, 05 Nov 2021 13:36:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, jack@suse.cz,
        linux-mm@kvack.org, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at,
        torvalds@linux-foundation.org, vigneshr@ti.com
Subject:  [patch 044/262] fs: explicitly unregister per-superblock
 BDIs
Message-ID: <20211105203658.rCpMjLKAt%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: fs: explicitly unregister per-superblock BDIs

Add a new SB_I_ flag to mark superblocks that have an ephemeral bdi
associated with them, and unregister it when the superblock is shut down.

Link: https://lkml.kernel.org/r/20211021124441.668816-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c         |    3 +++
 include/linux/fs.h |    1 +
 2 files changed, 4 insertions(+)

--- a/fs/super.c~fs-explicitly-unregister-per-superblock-bdis
+++ a/fs/super.c
@@ -476,6 +476,8 @@ void generic_shutdown_super(struct super
 	spin_unlock(&sb_lock);
 	up_write(&sb->s_umount);
 	if (sb->s_bdi != &noop_backing_dev_info) {
+		if (sb->s_iflags & SB_I_PERSB_BDI)
+			bdi_unregister(sb->s_bdi);
 		bdi_put(sb->s_bdi);
 		sb->s_bdi = &noop_backing_dev_info;
 	}
@@ -1562,6 +1564,7 @@ int super_setup_bdi_name(struct super_bl
 	}
 	WARN_ON(sb->s_bdi != &noop_backing_dev_info);
 	sb->s_bdi = bdi;
+	sb->s_iflags |= SB_I_PERSB_BDI;
 
 	return 0;
 }
--- a/include/linux/fs.h~fs-explicitly-unregister-per-superblock-bdis
+++ a/include/linux/fs.h
@@ -1443,6 +1443,7 @@ extern int send_sigurg(struct fown_struc
 #define SB_I_UNTRUSTED_MOUNTER		0x00000040
 
 #define SB_I_SKIP_SYNC	0x00000100	/* Skip superblock at global sync */
+#define SB_I_PERSB_BDI	0x00000200	/* has a per-sb bdi */
 
 /* Possible states of 'frozen' field */
 enum {
_
