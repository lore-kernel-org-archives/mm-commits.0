Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1545CC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C620720B1F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817993;
	bh=6YcLCOUQXZ2ntkjYAme5xEqoox+dHPHnr65b2caziY4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=G/6DJP4buqHPiZYcQtWz7KeDnxH3vKRnPD6nlLu669FsOi46Fjb1E3dqfZBessWwM
	 sufPZM/loacRRj7u6MxTrHLMeIAeIacjP09IPMadJXLiYfiXcZMm/2Ev7g8KkNESme
	 91jLf7m4zyTdulgFV01U/n2yIEAbE95/3E+luaP8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393955AbgJPDNN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:13:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393799AbgJPDNN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:13:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 418722078A;
        Fri, 16 Oct 2020 03:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817992;
        bh=6YcLCOUQXZ2ntkjYAme5xEqoox+dHPHnr65b2caziY4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QL9Sn36QktmlSlSJSepr/5k1zov2ILOpjqvEBDYu2NQU+M3qQ7GEjvpNNuY24JRMY
         mXsRsgQkTJrFl6O2UfuO2eaqCLoP6eo5cXc5OWeTDp/fIlqYMbZGud+ENRInYj+iVf
         rdmczAr46lvROIT4VcYZ/iUp66PMWRXIEaWBvgL4=
Date:   Thu, 15 Oct 2020 20:13:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, konishi.ryusuke@gmail.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        wanghai38@huawei.com
Subject:  [patch 145/156] nilfs2: fix some kernel-doc warnings for
 nilfs2
Message-ID: <20201016031311.l0ysCKsCj%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Subject: nilfs2: fix some kernel-doc warnings for nilfs2

Fixes the following W=1 kernel build warning(s):

fs/nilfs2/bmap.c:378: warning: Excess function parameter 'bhp' description in 'nilfs_bmap_assign'
fs/nilfs2/cpfile.c:907: warning: Excess function parameter 'status' description in 'nilfs_cpfile_change_cpmode'
fs/nilfs2/cpfile.c:946: warning: Excess function parameter 'stat' description in 'nilfs_cpfile_get_stat'
fs/nilfs2/page.c:76: warning: Excess function parameter 'inode' description in 'nilfs_forget_buffer'
fs/nilfs2/sufile.c:563: warning: Excess function parameter 'stat' description in 'nilfs_sufile_get_stat'

Link: https://lkml.kernel.org/r/1601386269-2423-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c   |    2 +-
 fs/nilfs2/cpfile.c |    6 +++---
 fs/nilfs2/page.c   |    1 -
 fs/nilfs2/sufile.c |    4 ++--
 4 files changed, 6 insertions(+), 7 deletions(-)

--- a/fs/nilfs2/bmap.c~nilfs2-fix-some-kernel-doc-warnings-for-nilfs2
+++ a/fs/nilfs2/bmap.c
@@ -355,7 +355,7 @@ void nilfs_bmap_lookup_dirty_buffers(str
 /**
  * nilfs_bmap_assign - assign a new block number to a block
  * @bmap: bmap
- * @bhp: pointer to buffer head
+ * @bh: pointer to buffer head
  * @blocknr: block number
  * @binfo: block information
  *
--- a/fs/nilfs2/cpfile.c~nilfs2-fix-some-kernel-doc-warnings-for-nilfs2
+++ a/fs/nilfs2/cpfile.c
@@ -889,7 +889,7 @@ int nilfs_cpfile_is_snapshot(struct inod
  * nilfs_cpfile_change_cpmode - change checkpoint mode
  * @cpfile: inode of checkpoint file
  * @cno: checkpoint number
- * @status: mode of checkpoint
+ * @mode: mode of checkpoint
  *
  * Description: nilfs_change_cpmode() changes the mode of the checkpoint
  * specified by @cno. The mode @mode is NILFS_CHECKPOINT or NILFS_SNAPSHOT.
@@ -930,12 +930,12 @@ int nilfs_cpfile_change_cpmode(struct in
 /**
  * nilfs_cpfile_get_stat - get checkpoint statistics
  * @cpfile: inode of checkpoint file
- * @stat: pointer to a structure of checkpoint statistics
+ * @cpstat: pointer to a structure of checkpoint statistics
  *
  * Description: nilfs_cpfile_get_stat() returns information about checkpoints.
  *
  * Return Value: On success, 0 is returned, and checkpoints information is
- * stored in the place pointed by @stat. On error, one of the following
+ * stored in the place pointed by @cpstat. On error, one of the following
  * negative error codes is returned.
  *
  * %-EIO - I/O error.
--- a/fs/nilfs2/page.c~nilfs2-fix-some-kernel-doc-warnings-for-nilfs2
+++ a/fs/nilfs2/page.c
@@ -69,7 +69,6 @@ struct buffer_head *nilfs_grab_buffer(st
 
 /**
  * nilfs_forget_buffer - discard dirty state
- * @inode: owner inode of the buffer
  * @bh: buffer head of the buffer to be discarded
  */
 void nilfs_forget_buffer(struct buffer_head *bh)
--- a/fs/nilfs2/sufile.c~nilfs2-fix-some-kernel-doc-warnings-for-nilfs2
+++ a/fs/nilfs2/sufile.c
@@ -546,13 +546,13 @@ int nilfs_sufile_set_segment_usage(struc
 /**
  * nilfs_sufile_get_stat - get segment usage statistics
  * @sufile: inode of segment usage file
- * @stat: pointer to a structure of segment usage statistics
+ * @sustat: pointer to a structure of segment usage statistics
  *
  * Description: nilfs_sufile_get_stat() returns information about segment
  * usage.
  *
  * Return Value: On success, 0 is returned, and segment usage information is
- * stored in the place pointed by @stat. On error, one of the following
+ * stored in the place pointed by @sustat. On error, one of the following
  * negative error codes is returned.
  *
  * %-EIO - I/O error.
_
