From: akpm@linux-foundation.org
Subject: + scsi-rename-random32-to-prandom_u32-fix.patch added to -mm tree
Date: Mon, 11 Mar 2013 16:11:32 -0700
Message-ID: <20130311231132.6C18E5A4121@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:64781 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3CKXLd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 19:11:33 -0400
Received: by mail-qa0-f73.google.com with SMTP id g10so243435qah.0
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 16:11:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, JBottomley@parallels.com, andrew.vasquez@qlogic.com


The patch titled
     Subject: scsi: fix the wrong position of the comment
has been added to the -mm tree.  Its filename is
     scsi-rename-random32-to-prandom_u32-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: scsi: fix the wrong position of the comment

This fixes the wrong position of the comment introduced by
scsi-rename-random32-to-prandom_u32.patch in the -mm tree.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_attr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_attr.c~scsi-rename-random32-to-prandom_u32-fix drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c~scsi-rename-random32-to-prandom_u32-fix
+++ a/drivers/scsi/qla2xxx/qla_attr.c
@@ -1939,13 +1939,13 @@ qla24xx_vport_delete(struct fc_vport *fc
 	}
 
 	/* No pending activities shall be there on the vha now */
-	if (ql2xextended_error_logging & ql_dbg_user)
-		msleep(prandom_u32() % 10);
+	if (ql2xextended_error_logging & ql_dbg_user) {
 		/*
 		 * Just to see if something falls on the net we have placed
 		 * below
 		 */
-
+		msleep(prandom_u32() % 10);
+	}
 	BUG_ON(atomic_read(&vha->vref_count));
 
 	qla2x00_free_fcports(vha);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
gfs2-use-memchr_inv.patch
raid6test-use-prandom_bytes.patch
uuid-use-prandom_bytes.patch
x86-pageattr-test-remove-srandom32-call.patch
x86-rename-random32-to-prandom_u32.patch
lib-rename-random32-to-prandom_u32.patch
mm-rename-random32-to-prandom_u32.patch
kernel-rename-random32-to-prandom_u32.patch
drbd-rename-random32-to-prandom_u32.patch
infiniband-rename-random32-to-prandom_u32.patch
mmc-rename-random32-to-prandom_u32.patch
video-uvesafb-rename-random32-to-prandom_u32.patch
xfs-rename-random32-to-prandom_u32.patch
uwb-rename-random32-to-prandom_u32.patch
lguest-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch

