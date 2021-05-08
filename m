Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB37C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E88D61432
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhEHWy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhEHWy2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A52561402;
        Sat,  8 May 2021 22:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514406;
        bh=VoJsY9tNKFp60luV9Inf8eR3lqxbPUe1F23S2bQt6zM=;
        h=Date:From:To:Subject:From;
        b=2f+ExNUKmhfeFVLfhvFk8YyJXz51aR8N7zhMxls7g5wrnkbLV6ecd/ovBHJHGkTd8
         XInl3OnDroWGRgYV/0C/YHcU45hBcvMxYygtuzGkey3z77YHlhTXLfrMiSR5uFrh3K
         E2lsPyYuYWLI5OlltAl91Fsa3ur75UCLT4S0+DdA=
Date:   Sat, 08 May 2021 15:53:26 -0700
From:   akpm@linux-foundation.org
To:     konishi.ryusuke@gmail.com, lujialin4@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged] nilfs2-fix-typos-in-comments.patch removed from
 -mm tree
Message-ID: <20210508225326.dJTs67_Dw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix typos in comments
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-typos-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lu Jialin <lujialin4@huawei.com>
Subject: nilfs2: fix typos in comments

numer -> number in fs/nilfs2/cpfile.c
Decription -> Description in fs/nilfs2/ioctl.c
isntance -> instance in fs/nilfs2/the_nilfs.c

Link: https://lkml.kernel.org/r/1617942951-14631-1-git-send-email-konishi.ryusuke@gmail.com
Link: https://lore.kernel.org/r/20210409022519.176988-1-lujialin4@huawei.com
Signed-off-by: Lu Jialin <lujialin4@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c    |    2 +-
 fs/nilfs2/ioctl.c     |    4 ++--
 fs/nilfs2/the_nilfs.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/cpfile.c~nilfs2-fix-typos-in-comments
+++ a/fs/nilfs2/cpfile.c
@@ -293,7 +293,7 @@ void nilfs_cpfile_put_checkpoint(struct
  * nilfs_cpfile_delete_checkpoints - delete checkpoints
  * @cpfile: inode of checkpoint file
  * @start: start checkpoint number
- * @end: end checkpoint numer
+ * @end: end checkpoint number
  *
  * Description: nilfs_cpfile_delete_checkpoints() deletes the checkpoints in
  * the period from @start to @end, excluding @end itself. The checkpoints
--- a/fs/nilfs2/ioctl.c~nilfs2-fix-typos-in-comments
+++ a/fs/nilfs2/ioctl.c
@@ -1043,7 +1043,7 @@ out:
  * @inode: inode object
  * @argp: pointer on argument from userspace
  *
- * Decription: nilfs_ioctl_trim_fs is the FITRIM ioctl handle function. It
+ * Description: nilfs_ioctl_trim_fs is the FITRIM ioctl handle function. It
  * checks the arguments from userspace and calls nilfs_sufile_trim_fs, which
  * performs the actual trim operation.
  *
@@ -1085,7 +1085,7 @@ static int nilfs_ioctl_trim_fs(struct in
  * @inode: inode object
  * @argp: pointer on argument from userspace
  *
- * Decription: nilfs_ioctl_set_alloc_range() function defines lower limit
+ * Description: nilfs_ioctl_set_alloc_range() function defines lower limit
  * of segments in bytes and upper limit of segments in bytes.
  * The NILFS_IOCTL_SET_ALLOC_RANGE is used by nilfs_resize utility.
  *
--- a/fs/nilfs2/the_nilfs.c~nilfs2-fix-typos-in-comments
+++ a/fs/nilfs2/the_nilfs.c
@@ -195,7 +195,7 @@ static int nilfs_store_log_cursor(struct
 /**
  * load_nilfs - load and recover the nilfs
  * @nilfs: the_nilfs structure to be released
- * @sb: super block isntance used to recover past segment
+ * @sb: super block instance used to recover past segment
  *
  * load_nilfs() searches and load the latest super root,
  * attaches the last segment, and does recovery if needed.
_

Patches currently in -mm which might be from lujialin4@huawei.com are


