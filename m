From: akpm@linux-foundation.org
Subject: + drivers-media-common-tuners-drop-code-after-return-or-goto.patch added to -mm tree
Date: Fri, 12 Sep 2008 12:40:08 -0700
Message-ID: <200809121940.m8CJe9dO000568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753203AbYILTkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Sep 2008 15:40:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, mchehab@infradead.org, richard.genoud@gmail.com


The patch titled
     drivers/media/common/tuners: drop code after return or goto
has been added to the -mm tree.  Its filename is
     drivers-media-common-tuners-drop-code-after-return-or-goto.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
fs-gfs2-use-an-is_err-test-rather-than-a-null-test.patch
arch-ia64-sn-pci-tioca_providerc-introduce-missing-kfree.patch
drivers-atm-use-div_round_up.patch
drivers-net-wan-use-div_round_up.patch
drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
drivers-block-use-div_round_up.patch
drivers-usb-misc-use-an-is_err-test-rather-than-a-null-test.patch
net-9p-trans_fdc-introduce-missing-kfree.patch
drivers-misc-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch
drivers-infiniband-hw-drop-code-after-return.patch
drivers-media-common-tuners-drop-code-after-return-or-goto.patch
fs-namespacec-drop-code-after-return.patch
net-atm-lecc-drop-code-after-return.patch
drivers-dma-ioat_dmac-drop-code-after-return.patch

