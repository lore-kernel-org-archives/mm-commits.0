From: akpm@linux-foundation.org
Subject: + isdn-capidrv-fix-casting-warning.patch added to -mm tree
Date: Thu, 25 Oct 2007 01:14:39 -0700
Message-ID: <200710250814.l9P8EdQJ014769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50985 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754380AbXJYITv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 04:19:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, jgarzik@redhat.com, kkeil@suse.de


The patch titled
     ISDN/capidrv: fix casting warning
has been added to the -mm tree.  Its filename is
     isdn-capidrv-fix-casting-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ISDN/capidrv: fix casting warning
From: Jeff Garzik <jeff@garzik.org>

drivers/isdn/capi/capidrv.c: In function 'if_sendbuf':
drivers/isdn/capi/capidrv.c:1865: warning: cast from pointer to integer
of different size

We are passing a kernel pointer, skb->data, but the interface itself is
limited to 32 bits.  A future changeset may want to mark this code 32-bit
only, if it turns out cmsg->Data value truncation on 64-bit platforms is
problematic in practice.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capidrv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/capi/capidrv.c~isdn-capidrv-fix-casting-warning drivers/isdn/capi/capidrv.c
--- a/drivers/isdn/capi/capidrv.c~isdn-capidrv-fix-casting-warning
+++ a/drivers/isdn/capi/capidrv.c
@@ -1862,7 +1862,7 @@ static int if_sendbuf(int id, int channe
 	datahandle = nccip->datahandle;
 	capi_fill_DATA_B3_REQ(&sendcmsg, global.ap.applid, card->msgid++,
 			      nccip->ncci,	/* adr */
-			      (u32) skb->data,	/* Data */
+			      (unsigned long) skb->data, /* Data */
 			      skb->len,		/* DataLength */
 			      datahandle,	/* DataHandle */
 			      0	/* Flags */
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
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
drivers-ide-pci-sc1200c-fix-suspend-resume-buglets-and-warnings.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
git-wireless.patch
mac80211-fix-warning-created-by-bit.patch
x86-fix-config_smp-warning-in-processorc.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
permit-silencing-of-__deprecated-warnings.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-checkpatch-fixes.patch
isdn-capidrv-fix-casting-warning.patch
isdn-sc-fix-longstanding-warning.patch
