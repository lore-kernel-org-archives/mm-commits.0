Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C47CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbiATCJz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:09:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51200 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiATCJx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:09:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26442B81C9F
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4604C004E1;
        Thu, 20 Jan 2022 02:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644590;
        bh=OGoH40tmNboM4Q9w0ReRvZcrS1vzgLhJ/ARQ2rU3RiQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hB9FXAkhau7OUL3gdFK2dI0aMam+Uil/3HSX538YXog9+toHKMg+50Pb8JqW0jzZf
         oCVz1fcFjqLs0oeFFEOf3LgqJCuIOVrooZo+plMmK84S1CMWhq1Ns9IrpDt6xBLVhD
         F2ZdDjQTQBFTfEOA6xMIb07643/ConlaaPHlc1fc=
Date:   Wed, 19 Jan 2022 18:09:50 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, neilb@suse.de,
        torvalds@linux-foundation.org
Subject:  [patch 40/55]  FAT: use io_schedule_timeout() instead of
 congestion_wait()
Message-ID: <20220120020950.xuF6ThKFO%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "NeilBrown" <neilb@suse.de>
Subject:  FAT: use io_schedule_timeout() instead of congestion_wait()

congestion_wait() in this context is just a sleep - block devices do not
support congestion signalling any more.

The goal for this wait, which was introduced in Commit ae78bf9c4f5f
("[PATCH] add -o flush for fat") is to wait for any recently written data
to get to storage.  We currently have no direct mechanism to do this, so a
simple wait that behaves identically to the current congestion_wait() is
the best we can do.

This is a step towards removing congestion_wait()

Link: https://lkml.kernel.org/r/163936544519.22433.13400436295732112065@noble.neil.brown.name
Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/fat/file.c~fat-use-io_schedule_timeout-instead-of-congestion_wait
+++ a/fs/fat/file.c
@@ -175,9 +175,10 @@ long fat_generic_ioctl(struct file *filp
 static int fat_file_release(struct inode *inode, struct file *filp)
 {
 	if ((filp->f_mode & FMODE_WRITE) &&
-	     MSDOS_SB(inode->i_sb)->options.flush) {
+	    MSDOS_SB(inode->i_sb)->options.flush) {
 		fat_flush_inodes(inode->i_sb, inode, NULL);
-		congestion_wait(BLK_RW_ASYNC, HZ/10);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		io_schedule_timeout(HZ/10);
 	}
 	return 0;
 }
_
