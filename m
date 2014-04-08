From: akpm@linux-foundation.org
Subject: [folded-merged] ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch removed from -mm tree
Date: Tue, 08 Apr 2014 16:00:50 -0700
Message-ID: <53447fa2.k/Xr2hLephn0wdui%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892AbaDHXAv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 19:00:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jet.chen@intel.com, fengguang.wu@intel.com, fabf@skynet.be, dushistov@mail.ru, akpm@linux-foundation.org

Subject: [folded-merged] ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,dushistov@mail.ru,fabf@skynet.be,fengguang.wu@intel.com,jet.chen@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 16:00:50 -0700


The patch titled
     Subject: ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix
has been removed from the -mm tree.  Its filename was
     ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch

This patch was dropped because it was folded into ufs-sb-mutex-merge-mutex_destroy.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix

avoid ifdefs, return -EROFS not -EINVAL.

Cc: "Chen, Jet" <jet.chen@intel.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff -puN fs/ufs/super.c~ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix
+++ a/fs/ufs/super.c
@@ -785,6 +785,14 @@ static int ufs_fill_super(struct super_b
 	flags = 0;
 	
 	UFSD("ENTER\n");
+
+#ifndef CONFIG_UFS_FS_WRITE
+	if (!(sb->s_flags & MS_RDONLY)) {
+		printk("ufs was compiled with read-only support, "
+		       "can't be mounted as read-write\n");
+		return -EROFS;
+	}
+#endif
 		
 	sbi = kzalloc(sizeof(struct ufs_sb_info), GFP_KERNEL);
 	if (!sbi)
@@ -794,13 +802,6 @@ static int ufs_fill_super(struct super_b
 
 	UFSD("flag %u\n", (int)(sb->s_flags & MS_RDONLY));
 	
-#ifndef CONFIG_UFS_FS_WRITE
-	if (!(sb->s_flags & MS_RDONLY)) {
-		printk("ufs was compiled with read-only support, "
-		"can't be mounted as read-write\n");
-		goto failed_noreadwrite;
-	}
-#endif
 	mutex_init(&sbi->mutex);
 	spin_lock_init(&sbi->work_lock);
 	INIT_DELAYED_WORK(&sbi->sync_work, delayed_sync_fs);
@@ -1256,10 +1257,6 @@ magic_found:
 
 failed:
 	mutex_destroy(&sbi->mutex);
