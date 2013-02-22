From: akpm@linux-foundation.org
Subject: [merged] configfs-move-the-dereference-below-the-null-test.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:39:01 -0800
Message-ID: <20130222203901.A92B65A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:55211 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3BVUjC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:39:02 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so103831ggn.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:39:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, jlbec@evilplan.org, mm-commits@vger.kernel.org


The patch titled
     Subject: configfs: move the dereference below the NULL test
has been removed from the -mm tree.  Its filename was
     configfs-move-the-dereference-below-the-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: configfs: move the dereference below the NULL test

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/dir.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/configfs/dir.c~configfs-move-the-dereference-below-the-null-test fs/configfs/dir.c
--- a/fs/configfs/dir.c~configfs-move-the-dereference-below-the-null-test
+++ a/fs/configfs/dir.c
@@ -1037,10 +1037,11 @@ static int configfs_dump(struct configfs
 static int configfs_depend_prep(struct dentry *origin,
 				struct config_item *target)
 {
-	struct configfs_dirent *child_sd, *sd = origin->d_fsdata;
+	struct configfs_dirent *child_sd, *sd;
 	int ret = 0;
 
-	BUG_ON(!origin || !sd);
+	BUG_ON(!origin || !origin->d_fsdata);
+	sd = origin->d_fsdata;
 
 	if (sd->s_element == target)  /* Boo-yah */
 		goto out;
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch
memstick-move-the-dereference-below-the-null-test.patch

