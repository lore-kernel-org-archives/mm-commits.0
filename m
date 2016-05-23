From: akpm@linux-foundation.org
Subject: [merged] fs-efs-fix-return-value.patch removed from -mm tree
Date: Mon, 23 May 2016 12:51:49 -0700
Message-ID: <57435f55.IA+I+OjTQCj0KTJS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbcEWTvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:51:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: os@iscas.ac.cn, firogm@gmail.com, hannes@cmpxchg.org, vdavydov@virtuozzo.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/efs/super.c: fix return value
has been removed from the -mm tree.  Its filename was
     fs-efs-fix-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heloise <os@iscas.ac.cn>
Subject: fs/efs/super.c: fix return value

When sb_bread() fails, the return value should be -EIO, fix it.

Link: http://lkml.kernel.org/r/1463464943-4142-1-git-send-email-os@iscas.ac.cn
Signed-off-by: Heloise <os@iscas.ac.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Firo Yang <firogm@gmail.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/efs/super.c~fs-efs-fix-return-value fs/efs/super.c
--- a/fs/efs/super.c~fs-efs-fix-return-value
+++ a/fs/efs/super.c
@@ -275,7 +275,7 @@ static int efs_fill_super(struct super_b
 
 	if (!bh) {
 		pr_err("cannot read volume header\n");
-		return -EINVAL;
+		return -EIO;
 	}
 
 	/*
@@ -293,7 +293,7 @@ static int efs_fill_super(struct super_b
 	bh = sb_bread(s, sb->fs_start + EFS_SUPER);
 	if (!bh) {
 		pr_err("cannot read superblock\n");
-		return -EINVAL;
+		return -EIO;
 	}
 		
 	if (efs_validate_super(sb, (struct efs_super *) bh->b_data)) {
_

Patches currently in -mm which might be from os@iscas.ac.cn are


