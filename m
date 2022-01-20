Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9A9C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377937AbiATVbW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377943AbiATVbS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0771C06161C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:31:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D9A7618CC
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88646C340E0;
        Thu, 20 Jan 2022 21:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714277;
        bh=PbhnIYgTTTpHEEn1wAU+/7AyDx+iJu5B/rzlhf80UZE=;
        h=Date:From:To:Subject:From;
        b=ovBbCBKsFVW3n747YynNt7LUBfK78uYPBUz8EoOg4uYIoUhxC0+J5U9bfWwQC7ZJ0
         l2egyz/SMVLDALSXgLD98N3Mn/6eXgc5DJiF4KOWld4BqpTo/BPifpegtJhtUDhgCe
         XBbTNHZzbxeMkFt+hUXyqlRzM7dbr20STiIxO1HM=
Date:   Thu, 20 Jan 2022 13:31:17 -0800
From:   akpm@linux-foundation.org
To:     hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org,
        neilb@suse.de
Subject:  [merged]
 fat-use-io_schedule_timeout-instead-of-congestion_wait.patch removed from
 -mm tree
Message-ID: <20220120213117.MoeycSh7t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject:  FAT: use io_schedule_timeout() instead of congestion_wait()
has been removed from the -mm tree.  Its filename was
     fat-use-io_schedule_timeout-instead-of-congestion_wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

