From: akpm@linux-foundation.org
Subject: - nsp32_restart_autoscsi-remove-error-check.patch removed from -mm tree
Date: Mon, 26 Nov 2007 21:06:54 -0800
Message-ID: <200711270506.lAR56stU028200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbXK0FHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 00:07:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, yokota@netlab.is.tsukuba.ac.jp, mm-commits@vger.kernel.org


The patch titled
     nsp32_restart_autoscsi(): remove error check
has been removed from the -mm tree.  Its filename was
     nsp32_restart_autoscsi-remove-error-check.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: nsp32_restart_autoscsi(): remove error check
From: Adrian Bunk <bunk@stusta.de>

The Coverity checker noted that we'll anyway Oops later when we ran into
this condition - and the error check didn't prevent that.

Considering that the error condition shouldn't be possible, and we are
not able to handle it easily, this patch simply removes the pointless
error check.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: <yokota@netlab.is.tsukuba.ac.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/nsp32.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/scsi/nsp32.c~nsp32_restart_autoscsi-remove-error-check drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c~nsp32_restart_autoscsi-remove-error-check
+++ a/drivers/scsi/nsp32.c
@@ -1906,10 +1906,6 @@ static void nsp32_restart_autoscsi(struc
 
 	nsp32_dbg(NSP32_DEBUG_RESTART, "enter");
 
-	if (data->cur_target == NULL || data->cur_lunt == NULL) {
-		nsp32_msg(KERN_ERR, "Target or Lun is invalid");
-	}
-
 	/*
 	 * set SYNC_REG
 	 * Don't set BM_START_ADR before setting this register.
_

Patches currently in -mm which might be from bunk@stusta.de are

git-dvb.patch
git-kvm.patch
remove-fs-jffs2-ioctlc.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
maps4-add-proc-kpagecount-interface.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
