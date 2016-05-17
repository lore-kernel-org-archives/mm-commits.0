From: akpm@linux-foundation.org
Subject: + fs-efs-fix-return-value.patch added to -mm tree
Date: Tue, 17 May 2016 16:19:17 -0700
Message-ID: <573ba6f5.z/Q4jMXennoQKuQZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbcEQXTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2016 19:19:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: os@iscas.ac.cn, firogm@gmail.com, hannes@cmpxchg.org, vdavydov@virtuozzo.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/efs/super.c: fix return value
has been added to the -mm tree.  Its filename is
     fs-efs-fix-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-efs-fix-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-efs-fix-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-efs-fix-return-value.patch

