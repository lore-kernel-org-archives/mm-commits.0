From: akpm@linux-foundation.org
Subject: + drivers-scsi-remove-unnecessary-null-test.patch added to -mm tree
Date: Mon, 02 Nov 2009 22:24:32 -0800
Message-ID: <200911030624.nA36OX7t030238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbZKCGYe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 01:24:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, James.Bottomley@HansenPartnership.com


The patch titled
     drivers/scsi: Remove unnecessary NULL test
has been added to the -mm tree.  Its filename is
     drivers-scsi-remove-unnecessary-null-test.patch

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
Subject: drivers/scsi: Remove unnecessary NULL test
From: Julia Lawall <julia@diku.dk>

At the point where cmnd is initialized, it is tested for NULL, so it
doesn't have to be tested again here.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/initio.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/scsi/initio.c~drivers-scsi-remove-unnecessary-null-test drivers/scsi/initio.c
--- a/drivers/scsi/initio.c~drivers-scsi-remove-unnecessary-null-test
+++ a/drivers/scsi/initio.c
@@ -2817,7 +2817,6 @@ static void i91uSCBPost(u8 * host_mem, u
 	}
 
 	cmnd->result = cblk->tastat | (cblk->hastat << 16);
-	WARN_ON(cmnd == NULL);
 	i91u_unmap_scb(host->pci_dev, cmnd);
 	cmnd->scsi_done(cmnd);	/* Notify system DONE           */
 	initio_release_scb(host, cblk);	/* Release SCB for current channel */
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-char-ipmi-use-kcs_idle_state.patch
drivers-message-move-dereference-after-null-test.patch
drivers-acpi-move-dereference-after-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-mmc-move-dereference-after-null-test.patch
drivers-cpuidle-move-dereference-after-null-test.patch
drivers-video-move-dereference-after-null-test.patch
drivers-ata-libata-move-dereference-after-null-test.patch
drivers-scsi-remove-unnecessary-null-test.patch
arch-arm-plat-omap-drop-an-unnecessary-null-test.patch
arch-arm-plat-s3c24xx-move-dereference-after-null-test.patch

