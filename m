From: akpm@linux-foundation.org
Subject: + drivers-ata-libata-move-dereference-after-null-test.patch added to -mm tree
Date: Mon, 02 Nov 2009 22:24:27 -0800
Message-ID: <200911030624.nA36ORl6029864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbZKCGZC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 01:25:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, jeff@garzik.org, tj@kernel.org


The patch titled
     drivers/ata/libata: Move dereference after NULL test
has been added to the -mm tree.  Its filename is
     drivers-ata-libata-move-dereference-after-null-test.patch

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
Subject: drivers/ata/libata: Move dereference after NULL test
From: Julia Lawall <julia@diku.dk>

In each case, if the NULL test on qc is needed, then the derefernce
should be after the NULL test.

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
Cc: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/ata/libata-core.c~drivers-ata-libata-move-dereference-after-null-test drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~drivers-ata-libata-move-dereference-after-null-test
+++ a/drivers/ata/libata-core.c
@@ -4919,10 +4919,11 @@ struct ata_queued_cmd *ata_qc_new_init(s
  */
 void ata_qc_free(struct ata_queued_cmd *qc)
 {
-	struct ata_port *ap = qc->ap;
+	struct ata_port *ap;
 	unsigned int tag;
 
 	WARN_ON_ONCE(qc == NULL); /* ata_qc_from_tag _might_ return NULL */
+	ap = qc->ap;
 
 	qc->flags = 0;
 	tag = qc->tag;
@@ -4934,11 +4935,13 @@ void ata_qc_free(struct ata_queued_cmd *
 
 void __ata_qc_complete(struct ata_queued_cmd *qc)
 {
-	struct ata_port *ap = qc->ap;
-	struct ata_link *link = qc->dev->link;
+	struct ata_port *ap;
+	struct ata_link *link;
 
 	WARN_ON_ONCE(qc == NULL); /* ata_qc_from_tag _might_ return NULL */
 	WARN_ON_ONCE(!(qc->flags & ATA_QCFLAG_ACTIVE));
+	ap = qc->ap;
+	link = qc->dev->link;
 
 	if (likely(qc->flags & ATA_QCFLAG_DMAMAP))
 		ata_sg_clean(qc);
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

