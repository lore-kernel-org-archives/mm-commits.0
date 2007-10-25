From: akpm@linux-foundation.org
Subject: + hptiop-fix-type-mismatch-warning.patch added to -mm tree
Date: Wed, 24 Oct 2007 20:16:56 -0700
Message-ID: <200710250316.l9P3Gu6m029091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50782 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756403AbXJYDRt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 23:17:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, James.Bottomley@steeleye.com, jgarzik@redhat.com, linux@highpoint-tech.com


The patch titled
     hptiop: fix type mismatch warning
has been added to the -mm tree.  Its filename is
     hptiop-fix-type-mismatch-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hptiop: fix type mismatch warning
From: Jeff Garzik <jeff@garzik.org>

drivers/scsi/hptiop.c: In function 'hptiop_host_request_callback':
drivers/scsi/hptiop.c:378: warning: comparison of distinct pointer types lacks a cast
drivers/scsi/hptiop.c:378: warning: comparison of distinct pointer types lacks a cast

Use min_t(size_t, ...) to fix.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: HighPoint Linux Team <linux@highpoint-tech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hptiop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hptiop.c~hptiop-fix-type-mismatch-warning drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~hptiop-fix-type-mismatch-warning
+++ a/drivers/scsi/hptiop.c
@@ -376,7 +376,7 @@ static void hptiop_host_request_callback
 		memset(&scp->sense_buffer,
 				0, sizeof(scp->sense_buffer));
 		memcpy(&scp->sense_buffer, &req->sg_list,
-				min(sizeof(scp->sense_buffer),
+				min_t(size_t, sizeof(scp->sense_buffer),
 					le32_to_cpu(req->dataxfer_length)));
 		break;
 
_

Patches currently in -mm which might be from jeff@garzik.org are

lguest-build-fix.patch
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
hptiop-fix-type-mismatch-warning.patch
git-wireless.patch
mac80211-fix-warning-created-by-bit.patch
x86-fix-config_smp-warning-in-processorc.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
isdn-sc-fix-longstanding-warning.patch
