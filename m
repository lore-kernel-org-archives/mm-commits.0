Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37D8C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9023E207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266278;
	bh=Png3DwWmsbK1j7uXPnegUOSBMUjVVXCcP8PSAOh2tzM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=aYd+/Gbo6zfuOQHp6CN9jcy9Wh3U1L8sxfz18zWOKYJhFMDODWCAi6v73CBcr/wfw
	 NajqLTqdzlgCW+4SvR7AtoTlQCpYcsmw8Q+QFATu7lfaj60nUlcYBYIWqhPjh6xxbO
	 cRecGEI2qBF5l1cl++rzypZ3muKl/2xzCXNsJnEw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHLVEi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHLVEi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 652C120774;
        Wed, 12 Aug 2020 21:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266277;
        bh=Png3DwWmsbK1j7uXPnegUOSBMUjVVXCcP8PSAOh2tzM=;
        h=Date:From:To:Subject:From;
        b=K2B+epQNJimHFYFgY8RfplLJIkmlCnEYH3bMsw2Nd5alnsX+OkbgGzeGvCZM8ue+2
         3Y0uzoH2x4ljxgMis1EmcClHYSzZpSEJpW6qoasxh/NACyaXoYxDFD3RNaBLTzoEvW
         kOjTP4yYE4Gn4psmZaYeoEKlVEfn1UBh9TTTRju0=
Date:   Wed, 12 Aug 2020 14:04:37 -0700
From:   akpm@linux-foundation.org
To:     anenbupt@gmail.com, ebiggers@google.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged] fs-minix-dont-allow-getting-deleted-inodes.patch
 removed from -mm tree
Message-ID: <20200812210437.bMqVKURjT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/minix: don't allow getting deleted inodes
has been removed from the -mm tree.  Its filename was
     fs-minix-dont-allow-getting-deleted-inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: fs/minix: don't allow getting deleted inodes

If an inode has no links, we need to mark it bad rather than allowing it
to be accessed.  This avoids WARNINGs in inc_nlink() and drop_nlink() when
doing directory operations on a fuzzed filesystem.

Link: http://lkml.kernel.org/r/20200628060846.682158-3-ebiggers@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+a9ac3de1b5de5fb10efc@syzkaller.appspotmail.com
Reported-by: syzbot+df958cf5688a96ad3287@syzkaller.appspotmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Qiujun Huang <anenbupt@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/minix/inode.c~fs-minix-dont-allow-getting-deleted-inodes
+++ a/fs/minix/inode.c
@@ -468,6 +468,13 @@ static struct inode *V1_minix_iget(struc
 		iget_failed(inode);
 		return ERR_PTR(-EIO);
 	}
+	if (raw_inode->i_nlinks == 0) {
+		printk("MINIX-fs: deleted inode referenced: %lu\n",
+		       inode->i_ino);
+		brelse(bh);
+		iget_failed(inode);
+		return ERR_PTR(-ESTALE);
+	}
 	inode->i_mode = raw_inode->i_mode;
 	i_uid_write(inode, raw_inode->i_uid);
 	i_gid_write(inode, raw_inode->i_gid);
@@ -501,6 +508,13 @@ static struct inode *V2_minix_iget(struc
 		iget_failed(inode);
 		return ERR_PTR(-EIO);
 	}
+	if (raw_inode->i_nlinks == 0) {
+		printk("MINIX-fs: deleted inode referenced: %lu\n",
+		       inode->i_ino);
+		brelse(bh);
+		iget_failed(inode);
+		return ERR_PTR(-ESTALE);
+	}
 	inode->i_mode = raw_inode->i_mode;
 	i_uid_write(inode, raw_inode->i_uid);
 	i_gid_write(inode, raw_inode->i_gid);
_

Patches currently in -mm which might be from ebiggers@google.com are


