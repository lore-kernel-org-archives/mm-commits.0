From: akpm@linux-foundation.org
Subject: + scsi-bfa-correct-onstack-wait_queue_head-declaration.patch added to -mm tree
Date: Mon, 08 Feb 2010 12:52:27 -0800
Message-ID: <201002082052.o18KqR6b002162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354Ab0BHUxA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 15:53:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yong.zhang0@gmail.com, James.Bottomley@suse.de, huangj@brocade.com, roel.kluin@gmail.com


The patch titled
     scsi: bfa: correct onstack wait_queue_head declaration
has been added to the -mm tree.  Its filename is
     scsi-bfa-correct-onstack-wait_queue_head-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: bfa: correct onstack wait_queue_head declaration
From: Yong Zhang <yong.zhang0@gmail.com>

Use DECLARE_WAIT_QUEUE_HEAD_ONSTACK to make lockdep happy

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Jing Huang <huangj@brocade.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bfa/bfad_im.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/bfa/bfad_im.c~scsi-bfa-correct-onstack-wait_queue_head-declaration drivers/scsi/bfa/bfad_im.c
--- a/drivers/scsi/bfa/bfad_im.c~scsi-bfa-correct-onstack-wait_queue_head-declaration
+++ a/drivers/scsi/bfa/bfad_im.c
@@ -281,7 +281,7 @@ bfad_im_reset_lun_handler(struct scsi_cm
 	struct bfa_tskim_s *tskim;
 	struct bfad_itnim_s   *itnim;
 	struct bfa_itnim_s *bfa_itnim;
-	DECLARE_WAIT_QUEUE_HEAD(wq);
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 	int             rc = SUCCESS;
 	unsigned long   flags;
 	enum bfi_tskim_status task_status;
@@ -343,7 +343,7 @@ bfad_im_reset_bus_handler(struct scsi_cm
 	struct bfad_itnim_s   *itnim;
 	unsigned long   flags;
 	u32        i, rc, err_cnt = 0;
-	DECLARE_WAIT_QUEUE_HEAD(wq);
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 	enum bfi_tskim_status task_status;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
_

Patches currently in -mm which might be from yong.zhang0@gmail.com are

linux-next.patch
v4l-dvb-gspca-sn9c20x-correct-onstack-wait_queue_head-declaration.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
staging-rt2860-correct-onstack-wait_queue_head-declaration.patch

