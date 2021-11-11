Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C668C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 347D06187A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhKKCoS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:49692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhKKCoS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9662A610F7;
        Thu, 11 Nov 2021 02:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598489;
        bh=ScCJyg9NLlK/+yEAfxEH4rlh7Cy07r9yv9IjG8O1vn8=;
        h=Date:From:To:Subject:From;
        b=ljoBH6qfmGgdi9EyJYsosdLbe943XK7p2iYviIXrGEhwd0iDLEkl+BMGQzbD9+C6w
         thU/gtc8mXnUsvQsyIjC+g/ZA1x+2/5qrrUsyhnfQskFKk5yt/4uu/nQlY7OAq1OXV
         eyaAb1TJOceMwAiK8Zl3B7FnoxoRwQ5m+jQbob9U=
Date:   Wed, 10 Nov 2021 18:41:29 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, jack@suse.cz, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at, vigneshr@ti.com
Subject:  [merged]
 fs-explicitly-unregister-per-superblock-bdis.patch removed from -mm tree
Message-ID: <20211111024129.spD8phYW6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: explicitly unregister per-superblock BDIs
has been removed from the -mm tree.  Its filename was
     fs-explicitly-unregister-per-superblock-bdis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

