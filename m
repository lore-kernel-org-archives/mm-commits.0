From: akpm@linux-foundation.org
Subject: + video-mmp-delete-a-stray-mutex_unlock.patch added to -mm tree
Date: Mon, 16 Dec 2013 11:55:52 -0800
Message-ID: <52af5ac8.P3zYYB3jhz3lGx2p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3LPTzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:55:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zzhu3@marvell.com, tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, haojian.zhuang@gmail.com, epure.andrei@gmail.com, cldu@marvell.com, dan.carpenter@oracle.com

Subject: + video-mmp-delete-a-stray-mutex_unlock.patch added to -mm tree
To: dan.carpenter@oracle.com,cldu@marvell.com,epure.andrei@gmail.com,haojian.zhuang@gmail.com,plagnioj@jcrosoft.com,tomi.valkeinen@ti.com,zzhu3@marvell.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:52 -0800


The patch titled
     Subject: drivers/video/mmp/core.c: delete a stray mutex_unlock()
has been added to the -mm tree.  Its filename is
     video-mmp-delete-a-stray-mutex_unlock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/video-mmp-delete-a-stray-mutex_unlock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/video-mmp-delete-a-stray-mutex_unlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
