From: akpm@linux-foundation.org
Subject: [folded-merged] ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 16:00:48 -0700
Message-ID: <53447fa0.UPIIQXYCEVzANHIy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892AbaDHXAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 19:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jet.chen@intel.com, fengguang.wu@intel.com, dushistov@mail.ru, fabf@skynet.be

Subject: [folded-merged] ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch removed from -mm tree
To: fabf@skynet.be,dushistov@mail.ru,fengguang.wu@intel.com,jet.chen@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 16:00:48 -0700


The patch titled
     Subject: ufs-sb-mutex-merge-mutex_destroy-fix-v2
has been removed from the -mm tree.  Its filename was
     ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch

This patch was dropped because it was folded into ufs-sb-mutex-merge-mutex_destroy.patch

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: ufs-sb-mutex-merge-mutex_destroy-fix-v2

v2: failed_noreadwrite is only used with CONFIG_UFS_FS_WRITE
    -> add ifndef

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Tested-by: "Chen, Jet" <jet.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ufs/super.c~ufs-sb-mutex-merge-mutex_destroy-fix-v2 fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-sb-mutex-merge-mutex_destroy-fix-v2
+++ a/fs/ufs/super.c
@@ -1257,7 +1257,9 @@ magic_found:
 failed:
 	mutex_destroy(&sbi->mutex);
 
+#ifndef CONFIG_UFS_FS_WRITE
 failed_noreadwrite:
+#endif
 	if (ubh)
 		ubh_brelse_uspi (uspi);
 	kfree (uspi);
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
ufs-sb-mutex-merge-mutex_destroy.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch

