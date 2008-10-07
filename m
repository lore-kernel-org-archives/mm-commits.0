From: akpm@linux-foundation.org
Subject: - drivers-media-common-tuners-drop-code-after-return-or-goto.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:39:40 -0700
Message-ID: <200810072339.m97Ndeog009575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757375AbYJGXjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mchehab@infradead.org, richard.genoud@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/media/common/tuners: drop code after return or goto
has been removed from the -mm tree.  Its filename was
     drivers-media-common-tuners-drop-code-after-return-or-goto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/common/tuners: drop code after return or goto
From: Julia Lawall <julia@diku.dk>

The break after the return or goto serves no purpose.

Signed-off-by: Julia Lawall <julia@diku.dk>
Reviewed-by: Richard Genoud <richard.genoud@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/common/tuners/mxl5007t.c     |    1 -
 drivers/media/common/tuners/tda18271-fe.c  |    1 -
 drivers/media/common/tuners/tda9887.c      |    1 -
 drivers/media/common/tuners/tuner-simple.c |    1 -
 4 files changed, 4 deletions(-)

diff -puN drivers/media/common/tuners/mxl5007t.c~drivers-media-common-tuners-drop-code-after-return-or-goto drivers/media/common/tuners/mxl5007t.c
--- a/drivers/media/common/tuners/mxl5007t.c~drivers-media-common-tuners-drop-code-after-return-or-goto
+++ a/drivers/media/common/tuners/mxl5007t.c
@@ -979,7 +979,6 @@ struct dvb_frontend *mxl5007t_attach(str
 	switch (instance) {
 	case 0:
 		goto fail;
-		break;
 	case 1:
 		/* new tuner instance */
 		state->config = cfg;
diff -puN drivers/media/common/tuners/tda18271-fe.c~drivers-media-common-tuners-drop-code-after-return-or-goto drivers/media/common/tuners/tda18271-fe.c
--- a/drivers/media/common/tuners/tda18271-fe.c~drivers-media-common-tuners-drop-code-after-return-or-goto
+++ a/drivers/media/common/tuners/tda18271-fe.c
@@ -1155,7 +1155,6 @@ struct dvb_frontend *tda18271_attach(str
 	switch (instance) {
 	case 0:
 		goto fail;
-		break;
 	case 1:
 		/* new tuner instance */
 		priv->gate = (cfg) ? cfg->gate : TDA18271_GATE_AUTO;
diff -puN drivers/media/common/tuners/tda9887.c~drivers-media-common-tuners-drop-code-after-return-or-goto drivers/media/common/tuners/tda9887.c
--- a/drivers/media/common/tuners/tda9887.c~drivers-media-common-tuners-drop-code-after-return-or-goto
+++ a/drivers/media/common/tuners/tda9887.c
@@ -686,7 +686,6 @@ struct dvb_frontend *tda9887_attach(stru
 	case 0:
 		mutex_unlock(&tda9887_list_mutex);
 		return NULL;
-		break;
 	case 1:
 		fe->analog_demod_priv = priv;
 		priv->mode = T_STANDBY;
diff -puN drivers/media/common/tuners/tuner-simple.c~drivers-media-common-tuners-drop-code-after-return-or-goto drivers/media/common/tuners/tuner-simple.c
--- a/drivers/media/common/tuners/tuner-simple.c~drivers-media-common-tuners-drop-code-after-return-or-goto
+++ a/drivers/media/common/tuners/tuner-simple.c
@@ -1040,7 +1040,6 @@ struct dvb_frontend *simple_tuner_attach
 	case 0:
 		mutex_unlock(&tuner_simple_list_mutex);
 		return NULL;
-		break;
 	case 1:
 		fe->tuner_priv = priv;
 
_

Patches currently in -mm which might be from julia@diku.dk are

git-v4l-dvb.patch
git-infiniband.patch
git-ieee1394.patch
git-async_tx.patch
git-net.patch
git-mtd.patch
git-sound.patch
git-cpufreq.patch
git-gfs2.patch
git-ubifs.patch
git-block.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
fs-namespacec-drop-code-after-return.patch
drivers-misc-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch

