From: akpm@linux-foundation.org
Subject: + video-mmp-using-plain-integer-as-null-pointer.patch added to
 -mm tree
Date: Mon, 16 Dec 2013 11:55:52 -0800
Message-ID: <52af5ac8.66FR+uJ04mr+ltu0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3LPTzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:55:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zzhu3@marvell.com, tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, haojian.zhuang@gmail.com, epure.andrei@gmail.com, cldu@marvell.com, dan.carpenter@oracle.com

Subject: + video-mmp-using-plain-integer-as-null-pointer.patch added to -mm tree
To: dan.carpenter@oracle.com,cldu@marvell.com,epure.andrei@gmail.com,haojian.zhuang@gmail.com,plagnioj@jcrosoft.com,tomi.valkeinen@ti.com,zzhu3@marvell.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:52 -0800


The patch titled
     Subject: drivers/video/mmp/core.c: using plain integer as NULL pointer
has been added to the -mm tree.  Its filename is
     video-mmp-using-plain-integer-as-null-pointer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/video-mmp-using-plain-integer-as-null-pointer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/video-mmp-using-plain-integer-as-null-pointer.patch

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
Subject: drivers/video/mmp/core.c: using plain integer as NULL pointer

Sparse complains here:

	drivers/video/mmp/core.c:33:16:
		warning: Using plain integer as NULL pointer

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Andrei Epure <epure.andrei@gmail.com>
Cc: Lisa Du <cldu@marvell.com>
Cc: Zhou Zhu <zzhu3@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mmp/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/mmp/core.c~video-mmp-using-plain-integer-as-null-pointer drivers/video/mmp/core.c
--- a/drivers/video/mmp/core.c~video-mmp-using-plain-integer-as-null-pointer
+++ a/drivers/video/mmp/core.c
@@ -30,7 +30,7 @@ static struct mmp_overlay *path_get_over
 {
 	if (path && overlay_id < path->overlay_num)
 		return &path->overlays[overlay_id];
-	return 0;
+	return NULL;
 }
 
 static int path_check_status(struct mmp_path *path)
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
video-mmp-delete-a-stray-mutex_unlock.patch
video-mmp-using-plain-integer-as-null-pointer.patch
ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch
drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch
drivers-block-paride-pgc-underflow-bug-in-pg_write.patch
fs-compat_ioctlc-fix-an-underflow-issue-harmless.patch
drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
linux-next.patch

