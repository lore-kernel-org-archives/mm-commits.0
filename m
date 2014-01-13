From: akpm@linux-foundation.org
Subject: [merged] video-mmp-delete-a-stray-mutex_unlock.patch removed from -mm tree
Date: Mon, 13 Jan 2014 13:21:48 -0800
Message-ID: <52d458ec.oibBCmcM859BgPpt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaAMVVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 16:21:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zzhu3@marvell.com, tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, haojian.zhuang@gmail.com, epure.andrei@gmail.com, cldu@marvell.com, dan.carpenter@oracle.com

Subject: [merged] video-mmp-delete-a-stray-mutex_unlock.patch removed from -mm tree
To: dan.carpenter@oracle.com,cldu@marvell.com,epure.andrei@gmail.com,haojian.zhuang@gmail.com,plagnioj@jcrosoft.com,tomi.valkeinen@ti.com,zzhu3@marvell.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 13:21:48 -0800


The patch titled
     Subject: drivers/video/mmp/core.c: delete a stray mutex_unlock()
has been removed from the -mm tree.  Its filename was
     video-mmp-delete-a-stray-mutex_unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/video/mmp/core.c: delete a stray mutex_unlock()

We aren't holding the disp_lock so we shouldn't release it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Andrei Epure <epure.andrei@gmail.com>
Cc: Lisa Du <cldu@marvell.com>
Cc: Zhou Zhu <zzhu3@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mmp/core.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/video/mmp/core.c~video-mmp-delete-a-stray-mutex_unlock drivers/video/mmp/core.c
--- a/drivers/video/mmp/core.c~video-mmp-delete-a-stray-mutex_unlock
+++ a/drivers/video/mmp/core.c
@@ -173,7 +173,7 @@ struct mmp_path *mmp_register_path(struc
 		+ sizeof(struct mmp_overlay) * info->overlay_num;
 	path = kzalloc(size, GFP_KERNEL);
 	if (!path)
-		goto failed;
+		return NULL;
 
 	/* path set */
 	mutex_init(&path->access_ok);
@@ -219,11 +219,6 @@ struct mmp_path *mmp_register_path(struc
 
 	mutex_unlock(&disp_lock);
 	return path;
