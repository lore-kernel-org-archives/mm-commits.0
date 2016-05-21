From: akpm@linux-foundation.org
Subject: [patch 158/162] fs/efs/super.c: fix return value
Date: Fri, 20 May 2016 17:04:25 -0700
Message-ID: <573fa609.kDYNH7cK+1kHNvGB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbcEUAE0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:04:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, os@iscas.ac.cn, firogm@gmail.com, hannes@cmpxchg.org, vdavydov@virtuozzo.com, viro@zeniv.linux.org.uk

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
