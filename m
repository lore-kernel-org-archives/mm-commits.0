Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FB2C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 766F7206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196136;
	bh=RyzsBiFvZLmv9MPcTa8mOrOLl8m4fKcS2XKfsd24VAo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=c+b4O4oNj00MkE6/r4dabJAoBsFdVZzIeNPltxRp6UB4FelJgjlicndaKcJOr3YVb
	 H7+QBnNjpCW5CoO2u8TA4OLZnICRYrIycr92lpQ/vOnv/zGvzDyeTiuNtPc1nCAgXD
	 UyKXTA/oBWK52b6wQOHsvLWwORuRdwss6q21eAVc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHLBfg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbgHLBfg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:35:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 371A82054F;
        Wed, 12 Aug 2020 01:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196134;
        bh=RyzsBiFvZLmv9MPcTa8mOrOLl8m4fKcS2XKfsd24VAo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=abRLhRRwNoVW+spCfHvKS2XnxEYyJ9miFolCOzFpG4RnOiiq7bl6sjy4eZuZfE9EP
         zedv7yXaIXYudCW9dg+PoPAon1ji2AqZTlGKLkeYEvQ3t3h9o74hzjlV+G+OJvVA6v
         qZJS3PKZenmwT28xfHDuF65W/4uWl6uMGhzmYzMw=
Date:   Tue, 11 Aug 2020 18:35:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anenbupt@gmail.com, ebiggers@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 101/165] fs/minix: set s_maxbytes correctly
Message-ID: <20200812013533.6sYRpYX75%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>
Subject: fs/minix: set s_maxbytes correctly

The minix filesystem leaves super_block::s_maxbytes at MAX_NON_LFS rather
than setting it to the actual filesystem-specific limit.  This is broken
because it means userspace doesn't see the standard behavior like getting
EFBIG and SIGXFSZ when exceeding the maximum file size.

Fix this by setting s_maxbytes correctly.

Link: http://lkml.kernel.org/r/20200628060846.682158-5-ebiggers@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Qiujun Huang <anenbupt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c    |   12 +++++++-----
 fs/minix/itree_v1.c |    2 +-
 fs/minix/itree_v2.c |    3 +--
 fs/minix/minix.h    |    1 -
 4 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/minix/inode.c~fs-minix-set-s_maxbytes-correctly
+++ a/fs/minix/inode.c
@@ -150,8 +150,10 @@ static int minix_remount (struct super_b
 	return 0;
 }
 
-static bool minix_check_superblock(struct minix_sb_info *sbi)
+static bool minix_check_superblock(struct super_block *sb)
 {
+	struct minix_sb_info *sbi = minix_sb(sb);
+
 	if (sbi->s_imap_blocks == 0 || sbi->s_zmap_blocks == 0)
 		return false;
 
@@ -161,7 +163,7 @@ static bool minix_check_superblock(struc
 	 * of indirect blocks which places the limit well above U32_MAX.
 	 */
 	if (sbi->s_version == MINIX_V1 &&
-	    sbi->s_max_size > (7 + 512 + 512*512) * BLOCK_SIZE)
+	    sb->s_maxbytes > (7 + 512 + 512*512) * BLOCK_SIZE)
 		return false;
 
 	return true;
@@ -202,7 +204,7 @@ static int minix_fill_super(struct super
 	sbi->s_zmap_blocks = ms->s_zmap_blocks;
 	sbi->s_firstdatazone = ms->s_firstdatazone;
 	sbi->s_log_zone_size = ms->s_log_zone_size;
-	sbi->s_max_size = ms->s_max_size;
+	s->s_maxbytes = ms->s_max_size;
 	s->s_magic = ms->s_magic;
 	if (s->s_magic == MINIX_SUPER_MAGIC) {
 		sbi->s_version = MINIX_V1;
@@ -233,7 +235,7 @@ static int minix_fill_super(struct super
 		sbi->s_zmap_blocks = m3s->s_zmap_blocks;
 		sbi->s_firstdatazone = m3s->s_firstdatazone;
 		sbi->s_log_zone_size = m3s->s_log_zone_size;
-		sbi->s_max_size = m3s->s_max_size;
+		s->s_maxbytes = m3s->s_max_size;
 		sbi->s_ninodes = m3s->s_ninodes;
 		sbi->s_nzones = m3s->s_zones;
 		sbi->s_dirsize = 64;
@@ -245,7 +247,7 @@ static int minix_fill_super(struct super
 	} else
 		goto out_no_fs;
 
-	if (!minix_check_superblock(sbi))
+	if (!minix_check_superblock(s))
 		goto out_illegal_sb;
 
 	/*
--- a/fs/minix/itree_v1.c~fs-minix-set-s_maxbytes-correctly
+++ a/fs/minix/itree_v1.c
@@ -29,7 +29,7 @@ static int block_to_path(struct inode *
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %pg\n",
 			block, inode->i_sb->s_bdev);
-	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/BLOCK_SIZE)) {
+	} else if (block >= inode->i_sb->s_maxbytes/BLOCK_SIZE) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %pg\n",
--- a/fs/minix/itree_v2.c~fs-minix-set-s_maxbytes-correctly
+++ a/fs/minix/itree_v2.c
@@ -32,8 +32,7 @@ static int block_to_path(struct inode *
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %pg\n",
 			block, sb->s_bdev);
-	} else if ((u64)block * (u64)sb->s_blocksize >=
-			minix_sb(sb)->s_max_size) {
+	} else if ((u64)block * (u64)sb->s_blocksize >= sb->s_maxbytes) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %pg\n",
--- a/fs/minix/minix.h~fs-minix-set-s_maxbytes-correctly
+++ a/fs/minix/minix.h
@@ -32,7 +32,6 @@ struct minix_sb_info {
 	unsigned long s_zmap_blocks;
 	unsigned long s_firstdatazone;
 	unsigned long s_log_zone_size;
-	unsigned long s_max_size;
 	int s_dirsize;
 	int s_namelen;
 	struct buffer_head ** s_imap;
_
