From: akpm@linux-foundation.org
Subject: [folded-merged] ufs-sb-mutex-merge-mutex_destroy-fix.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 16:00:45 -0700
Message-ID: <53447f9d.zhjXGY9sn06wDUZf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880AbaDHXAq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 19:00:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jet.chen@intel.com, fengguang.wu@intel.com, dushistov@mail.ru, fabf@skynet.be

Subject: [folded-merged] ufs-sb-mutex-merge-mutex_destroy-fix.patch removed from -mm tree
To: fabf@skynet.be,dushistov@mail.ru,fengguang.wu@intel.com,jet.chen@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 16:00:45 -0700


The patch titled
     Subject: ufs: sb mutex merge + mutex_destroy: fix
has been removed from the -mm tree.  Its filename was
     ufs-sb-mutex-merge-mutex_destroy-fix.patch

This patch was dropped because it was folded into ufs-sb-mutex-merge-mutex_destroy.patch

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: ufs: sb mutex merge + mutex_destroy: fix

mutex_destroy was also called when trying to mount volume in read/write
without write support enabled.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/ufs/super.c~ufs-sb-mutex-merge-mutex_destroy-fix fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-sb-mutex-merge-mutex_destroy-fix
+++ a/fs/ufs/super.c
@@ -798,7 +798,7 @@ static int ufs_fill_super(struct super_b
 	if (!(sb->s_flags & MS_RDONLY)) {
 		printk("ufs was compiled with read-only support, "
 		"can't be mounted as read-write\n");
-		goto failed;
+		goto failed_noreadwrite;
 	}
 #endif
 	mutex_init(&sbi->mutex);
@@ -1255,10 +1255,12 @@ magic_found:
 	return 0;
 
 failed:
+	mutex_destroy(&sbi->mutex);
+
+failed_noreadwrite:
 	if (ubh)
 		ubh_brelse_uspi (uspi);
 	kfree (uspi);
-	mutex_destroy(&sbi->mutex);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT (FAILED)\n");
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
ufs-sb-mutex-merge-mutex_destroy.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch

