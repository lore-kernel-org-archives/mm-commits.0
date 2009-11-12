From: akpm@linux-foundation.org
Subject: + hpsa-factor-out-command-submission-sequence.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:53:36 -0800
Message-ID: <200911122253.nACMrbV9006201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754806AbZKLWyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:54:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com


The patch titled
     hpsa: Factor out command submission sequence
has been added to the -mm tree.  Its filename is
     hpsa-factor-out-command-submission-sequence.patch

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
Subject: hpsa: Factor out command submission sequence
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

hpsa: Factor out command submission sequence.  There
are a few places where the same sequence of statements
occurs to submit and wait for the completion of a command.
Factor these out into a separate function.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-factor-out-command-submission-sequence drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-factor-out-command-submission-sequence
+++ a/drivers/scsi/hpsa.c
@@ -2086,7 +2086,6 @@ static int hpsa_passthru_ioctl(struct ct
 	struct CommandList *c;
 	char *buff = NULL;
 	union u64bit temp64;
-	DECLARE_COMPLETION_ONSTACK(wait);
 
 	if (!argp)
 		return -EINVAL;
@@ -2144,9 +2143,7 @@ static int hpsa_passthru_ioctl(struct ct
 		c->SG[0].Len = iocommand.buf_size;
 		c->SG[0].Ext = 0; /* we are not chaining*/
 	}
-	c->waiting = &wait;
-	enqueue_cmd_and_start_io(h, c);
-	wait_for_completion(&wait);
+	hpsa_scsi_do_simple_cmd_core(h, c);
 
 	/* unlock the buffers from DMA */
 	temp64.val32.lower = c->SG[0].Addr.lower;
@@ -2186,7 +2183,6 @@ static int hpsa_big_passthru_ioctl(struc
 	BYTE sg_used = 0;
 	int status = 0;
 	int i;
-	DECLARE_COMPLETION_ONSTACK(wait);
 	__u32 left;
 	__u32 sz;
 	BYTE __user *data_ptr;
@@ -2280,9 +2276,7 @@ static int hpsa_big_passthru_ioctl(struc
 			c->SG[i].Ext = 0;
 		}
 	}
-	c->waiting = &wait;
-	enqueue_cmd_and_start_io(h, c);
-	wait_for_completion(&wait);
+	hpsa_scsi_do_simple_cmd_core(h, c);
 	/* unlock the buffers from DMA */
 	for (i = 0; i < sg_used; i++) {
 		temp64.val32.lower = c->SG[i].Addr.lower;
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data.patch
hpsa-allocate-the-correct-amount-of-extra-space-for-the-scsi-host.patch
hpsa-use-shost_priv-instead-of-accessing-host-hostdata-directly.patch
hpsa-factor-out-command-submission-sequence.patch
hpsa-factor-out-some-pci_unmap-code.patch
add-thread-to-allow-controllers-to-register-for-rescan-for-new-devices.patch
hpsa-allow-device-rescan-to-be-triggered-via-sysfs.patch
hpsa-make-hpsa_sdev_attrs-static.patch
hpsa-decode-unit-attention-condition-and-retry-commands.patch
hpsa-retry-driver-initiated-commands-on-unit-attention.patch
hpsa-flush-cache-with-interrupts-still-enabled.patch
hpsa-remove-sendcmd-in-no-case-are-we-required-to-poll-for-completions.patch
hpsa-make-fill_cmd-return-void.patch
hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch

