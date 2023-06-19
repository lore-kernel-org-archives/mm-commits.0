Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE99EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 20:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjFSUUl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjFSUUV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 16:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1D6E72;
        Mon, 19 Jun 2023 13:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEF3A60E71;
        Mon, 19 Jun 2023 20:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E3EC433C8;
        Mon, 19 Jun 2023 20:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687206014;
        bh=HKe1NGP8yuXUskuzioApkh4IpwjKI1Syd6kQ2fVdKv4=;
        h=Date:To:From:Subject:From;
        b=pQDKXo5phWbktGNFRMMN66GkvG/lwR5H4ieOxfc9GF9cUKT5qwJHxXLyc7zvuaRXP
         kUjVK4a4rUmqM88Vr76Sonp99set68xXL1q2FoLixhtbPqNUS7GHcV61sPQ/+TF85o
         9u+7pDmCMoBbKti4cV0V099ihN0PAc4UAO/3/88s=
Date:   Mon, 19 Jun 2023 13:20:13 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-buffer-corruption-due-to-concurrent-device-reads.patch removed from -mm tree
Message-Id: <20230619202014.45E3EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: fix buffer corruption due to concurrent device reads
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-buffer-corruption-due-to-concurrent-device-reads.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix buffer corruption due to concurrent device reads
Date: Fri, 9 Jun 2023 12:57:32 +0900

As a result of analysis of a syzbot report, it turned out that in three
cases where nilfs2 allocates block device buffers directly via sb_getblk,
concurrent reads to the device can corrupt the allocated buffers.

Nilfs2 uses sb_getblk for segment summary blocks, that make up a log
header, and the super root block, that is the trailer, and when moving and
writing the second super block after fs resize.

In any of these, since the uptodate flag is not set when storing metadata
to be written in the allocated buffers, the stored metadata will be
overwritten if a device read of the same block occurs concurrently before
the write.  This causes metadata corruption and misbehavior in the log
write itself, causing warnings in nilfs_btree_assign() as reported.

Fix these issues by setting an uptodate flag on the buffer head on the
first or before modifying each buffer obtained with sb_getblk, and
clearing the flag on failure.

When setting the uptodate flag, the lock_buffer/unlock_buffer pair is used
to perform necessary exclusive control, and the buffer is filled to ensure
that uninitialized bytes are not mixed into the data read from others.  As
for buffers for segment summary blocks, they are filled incrementally, so
if the uptodate flag was unset on their allocation, set the flag and zero
fill the buffer once at that point.

Also, regarding the superblock move routine, the starting point of the
memset call to zerofill the block is incorrectly specified, which can
cause a buffer overflow on file systems with block sizes greater than
4KiB.  In addition, if the superblock is moved within a large block, it is
necessary to assume the possibility that the data in the superblock will
be destroyed by zero-filling before copying.  So fix these potential
issues as well.

Link: https://lkml.kernel.org/r/20230609035732.20426-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+31837fe952932efc8fb9@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/00000000000030000a05e981f475@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segbuf.c  |    6 ++++++
 fs/nilfs2/segment.c |    7 +++++++
 fs/nilfs2/super.c   |   23 ++++++++++++++++++++++-
 3 files changed, 35 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/segbuf.c~nilfs2-fix-buffer-corruption-due-to-concurrent-device-reads
+++ a/fs/nilfs2/segbuf.c
@@ -101,6 +101,12 @@ int nilfs_segbuf_extend_segsum(struct ni
 	if (unlikely(!bh))
 		return -ENOMEM;
 
+	lock_buffer(bh);
+	if (!buffer_uptodate(bh)) {
+		memset(bh->b_data, 0, bh->b_size);
+		set_buffer_uptodate(bh);
+	}
+	unlock_buffer(bh);
 	nilfs_segbuf_add_segsum_buffer(segbuf, bh);
 	return 0;
 }
--- a/fs/nilfs2/segment.c~nilfs2-fix-buffer-corruption-due-to-concurrent-device-reads
+++ a/fs/nilfs2/segment.c
@@ -981,10 +981,13 @@ static void nilfs_segctor_fill_in_super_
 	unsigned int isz, srsz;
 
 	bh_sr = NILFS_LAST_SEGBUF(&sci->sc_segbufs)->sb_super_root;
+
+	lock_buffer(bh_sr);
 	raw_sr = (struct nilfs_super_root *)bh_sr->b_data;
 	isz = nilfs->ns_inode_size;
 	srsz = NILFS_SR_BYTES(isz);
 
+	raw_sr->sr_sum = 0;  /* Ensure initialization within this update */
 	raw_sr->sr_bytes = cpu_to_le16(srsz);
 	raw_sr->sr_nongc_ctime
 		= cpu_to_le64(nilfs_doing_gc() ?
@@ -998,6 +1001,8 @@ static void nilfs_segctor_fill_in_super_
 	nilfs_write_inode_common(nilfs->ns_sufile, (void *)raw_sr +
 				 NILFS_SR_SUFILE_OFFSET(isz), 1);
 	memset((void *)raw_sr + srsz, 0, nilfs->ns_blocksize - srsz);
+	set_buffer_uptodate(bh_sr);
+	unlock_buffer(bh_sr);
 }
 
 static void nilfs_redirty_inodes(struct list_head *head)
@@ -1780,6 +1785,7 @@ static void nilfs_abort_logs(struct list
 	list_for_each_entry(segbuf, logs, sb_list) {
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
+			clear_buffer_uptodate(bh);
 			if (bh->b_page != bd_page) {
 				if (bd_page)
 					end_page_writeback(bd_page);
@@ -1791,6 +1797,7 @@ static void nilfs_abort_logs(struct list
 				    b_assoc_buffers) {
 			clear_buffer_async_write(bh);
 			if (bh == segbuf->sb_super_root) {
+				clear_buffer_uptodate(bh);
 				if (bh->b_page != bd_page) {
 					end_page_writeback(bd_page);
 					bd_page = bh->b_page;
--- a/fs/nilfs2/super.c~nilfs2-fix-buffer-corruption-due-to-concurrent-device-reads
+++ a/fs/nilfs2/super.c
@@ -372,10 +372,31 @@ static int nilfs_move_2nd_super(struct s
 		goto out;
 	}
 	nsbp = (void *)nsbh->b_data + offset;
-	memset(nsbp, 0, nilfs->ns_blocksize);
 
+	lock_buffer(nsbh);
 	if (sb2i >= 0) {
+		/*
+		 * The position of the second superblock only changes by 4KiB,
+		 * which is larger than the maximum superblock data size
+		 * (= 1KiB), so there is no need to use memmove() to allow
+		 * overlap between source and destination.
+		 */
 		memcpy(nsbp, nilfs->ns_sbp[sb2i], nilfs->ns_sbsize);
+
+		/*
+		 * Zero fill after copy to avoid overwriting in case of move
+		 * within the same block.
+		 */
+		memset(nsbh->b_data, 0, offset);
+		memset((void *)nsbp + nilfs->ns_sbsize, 0,
+		       nsbh->b_size - offset - nilfs->ns_sbsize);
+	} else {
+		memset(nsbh->b_data, 0, nsbh->b_size);
+	}
+	set_buffer_uptodate(nsbh);
+	unlock_buffer(nsbh);
+
+	if (sb2i >= 0) {
 		brelse(nilfs->ns_sbh[sb2i]);
 		nilfs->ns_sbh[sb2i] = nsbh;
 		nilfs->ns_sbp[sb2i] = nsbp;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


