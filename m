From: akpm@linux-foundation.org
Subject: + fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch added to -mm tree
Date: Tue, 31 Jul 2007 12:29:11 -0700
Message-ID: <200707311929.l6VJTBbQ018305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752957AbXGaT3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 15:29:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl


The patch titled
     fs/cifs/connect.c: kmalloc + memset conversion to kzalloc
has been added to the -mm tree.  Its filename is
     fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/cifs/connect.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This patch does kmalloc + memset conversion to kzalloc and removes some
redundant argument checks.

 fs/cifs/connect.c | 109282 -> 109078 (-204 bytes)
 fs/cifs/connect.o | 211804 -> 211576 (-228 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/connect.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff -puN fs/cifs/connect.c~fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc fs/cifs/connect.c
--- a/fs/cifs/connect.c~fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc
+++ a/fs/cifs/connect.c
@@ -676,10 +676,8 @@ multi_t2_fnd:
 		server->ssocket = NULL;
 	}
 	/* buffer usuallly freed in free_mid - need to free it here on exit */
-	if (bigbuf != NULL)
-		cifs_buf_release(bigbuf);
-	if (smallbuf != NULL)
-		cifs_small_buf_release(smallbuf);
+	cifs_buf_release(bigbuf);
+	cifs_small_buf_release(smallbuf);
 
 	read_lock(&GlobalSMBSeslock);
 	if (list_empty(&server->pending_mid_q)) {
@@ -1909,8 +1907,8 @@ cifs_mount(struct super_block *sb, struc
 			return rc;
 		}
 
-		srvTcp = kmalloc(sizeof (struct TCP_Server_Info), GFP_KERNEL);
-		if (srvTcp == NULL) {
+		srvTcp = kzalloc(sizeof(struct TCP_Server_Info), GFP_KERNEL);
+		if (!srvTcp) {
 			rc = -ENOMEM;
 			sock_release(csocket);
 			kfree(volume_info.UNC);
@@ -1919,7 +1917,6 @@ cifs_mount(struct super_block *sb, struc
 			FreeXid(xid);
 			return rc;
 		} else {
-			memset(srvTcp, 0, sizeof (struct TCP_Server_Info));
 			memcpy(&srvTcp->addr.sockAddr, &sin_server,
 				sizeof (struct sockaddr_in));
 			atomic_set(&srvTcp->inFlight, 0);
@@ -2154,8 +2151,8 @@ cifs_mount(struct super_block *sb, struc
 			}
 		}
 		 /* If find_unc succeeded then rc == 0 so we can not end */
-		if (tcon)  /* up accidently freeing someone elses tcon struct */
-			tconInfoFree(tcon);
+		/* up accidently freeing someone elses tcon struct */
+		tconInfoFree(tcon);
 		if (existingCifsSes == NULL) {
 			if (pSesInfo) {
 				if ((pSesInfo->server) &&
@@ -2526,8 +2523,7 @@ CIFSSessSetup(unsigned int xid, struct c
 sesssetup_nomem:	/* do not return an error on nomem for the info strings,
 			   since that could make reconnection harder, and
 			   reconnection might be needed to free memory */
-	if (smb_buffer)
-		cifs_buf_release(smb_buffer);
+	cifs_buf_release(smb_buffer);
 
 	return rc;
 }
@@ -2865,8 +2861,7 @@ CIFSNTLMSSPNegotiateSessSetup(unsigned i
 		rc = -EIO;
 	}
 
-	if (smb_buffer)
-		cifs_buf_release(smb_buffer);
+	cifs_buf_release(smb_buffer);
 
 	return rc;
 }
@@ -3279,8 +3274,7 @@ CIFSNTLMSSPAuthSessSetup(unsigned int xi
 		rc = -EIO;
 	}
 
-	if (smb_buffer)
-		cifs_buf_release(smb_buffer);
+	cifs_buf_release(smb_buffer);
 
 	return rc;
 }
@@ -3433,8 +3427,7 @@ CIFSTCon(unsigned int xid, struct cifsSe
 		ses->ipc_tid = smb_buffer_response->Tid;
 	}
 
-	if (smb_buffer)
-		cifs_buf_release(smb_buffer);
+	cifs_buf_release(smb_buffer);
 	return rc;
 }
 
@@ -3485,8 +3478,7 @@ cifs_umount(struct super_block *sb, stru
 	kfree(tmp);
 	if (ses)
 		schedule_timeout_interruptible(msecs_to_jiffies(500));
-	if (ses)
-		sesInfoFree(ses);
+	sesInfoFree(ses);
 
 	FreeXid(xid);
 	return rc;	/* BB check if we should always return zero here */
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

fs-9p-convc-error-path-fix.patch
mtd-add-module-license-to-mtdbdi.patch
mtd-remove-redundant-dead-code-from-physmap_ofc.patch
usb-remove-redundant-memset-from-amd5536udc.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
kmalloc-memset-conversion-co-kzalloc.patch
drivers-sbus-char-bbc_envctrlc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-sbus-char-bbc_i2cc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-bvme6000_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-block-ccissc-kmalloc-memset-conversion-to-kzalloc.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-block-cpqarrayc-better-error-handling-and-kmalloc-memset-conversion-to-kalloc.patch
drivers-pci-hotplug-cpqphp_ctrlc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-hw-handlerc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-path-selectorc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-targetc-kmalloc-memset-conversion-to-kzalloc.patch
net-decnet-dn_routec-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-usb-misc-ftdi-elanc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
drivers-net-wan-hdlc_frc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-ide-arm-icsidec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-ide-scsic-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
arch-x86_64-kernel-io_apicc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
net-ipv4-ip_optionsc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-atm-iphasec-mostly-kmalloc-memset-conversion-to-kzalloc.patch
drivers-net-irda-irda-usbc-mostly-kmalloc-memset-conversion-to-kalloc.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-megaraidc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mtd-inftlmountc-kmalloc-memset-conversion-to-kcalloc.patch
