Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1393BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAFEC61458
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhJVDAC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 23:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232626AbhJVDAB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 23:00:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBF6561251;
        Fri, 22 Oct 2021 02:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634871465;
        bh=3XEOp/c4aMH7THAgIrG5MmGHOysw3E8ICLsaYkZ36dY=;
        h=Date:From:To:Subject:From;
        b=GgzVNrqW8UbcjmT5WnpFN03FR/A/9VcJa1u0K10ViIp6ShsOUGpx4v+b/JuSBt8ic
         687nPdyLEYhuVaT7YTeiW33Lw+GT7bzkOKV3KA5f8ziN2s8VJHEQ3vm9uZrKzUW/uv
         ye4ca1eHtO0ACzboIYG678Xq4Wygromj0aYR1abE=
Date:   Thu, 21 Oct 2021 19:57:44 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, jack@suse.cz, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at, vigneshr@ti.com
Subject:  + fs-explicitly-unregister-per-superblock-bdis.patch
 added to -mm tree
Message-ID: <20211022025744.141JQmGjZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: explicitly unregister per-superblock BDIs
has been added to the -mm tree.  Its filename is
     fs-explicitly-unregister-per-superblock-bdis.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-explicitly-unregister-per-superblock-bdis.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-explicitly-unregister-per-superblock-bdis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: fs: explicitly unregister per-superblock BDIs

Add a new SB_I_ flag to mark superblocks that have an ephemeral bdi
associated with them, and unregister it when the superblock is shut down.

Link: https://lkml.kernel.org/r/20211021124441.668816-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
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

Patches currently in -mm which might be from hch@lst.de are

mm-dont-include-linux-daxh-in-linux-mempolicyh.patch
mm-export-bdi_unregister.patch
mtd-call-bdi_unregister-explicitly.patch
fs-explicitly-unregister-per-superblock-bdis.patch
mm-dont-automatically-unregister-bdis.patch
mm-simplify-bdi-refcounting.patch
mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

