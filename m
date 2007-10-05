From: akpm@linux-foundation.org
Subject: - fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:03 -0700
Message-ID: <200710051956.l95Ju3aV022302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759171AbXJET4K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:56:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     fs/cifs/connect.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 11 insertions(+), 19 deletions(-)

diff -puN fs/cifs/connect.c~fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc fs/cifs/connect.c
--- a/fs/cifs/connect.c~fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc
+++ a/fs/cifs/connect.c
@@ -673,10 +673,8 @@ multi_t2_fnd:
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
@@ -1910,8 +1908,8 @@ cifs_mount(struct super_block *sb, struc
 			return rc;
 		}
 
-		srvTcp = kmalloc(sizeof (struct TCP_Server_Info), GFP_KERNEL);
-		if (srvTcp == NULL) {
+		srvTcp = kzalloc(sizeof(struct TCP_Server_Info), GFP_KERNEL);
+		if (!srvTcp) {
 			rc = -ENOMEM;
 			sock_release(csocket);
 			kfree(volume_info.UNC);
@@ -1920,7 +1918,6 @@ cifs_mount(struct super_block *sb, struc
 			FreeXid(xid);
 			return rc;
 		} else {
-			memset(srvTcp, 0, sizeof (struct TCP_Server_Info));
 			memcpy(&srvTcp->addr.sockAddr, &sin_server,
 				sizeof (struct sockaddr_in));
 			atomic_set(&srvTcp->inFlight, 0);
@@ -2155,8 +2152,8 @@ cifs_mount(struct super_block *sb, struc
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
@@ -2529,8 +2526,7 @@ CIFSSessSetup(unsigned int xid, struct c
 sesssetup_nomem:	/* do not return an error on nomem for the info strings,
 			   since that could make reconnection harder, and
 			   reconnection might be needed to free memory */
-	if (smb_buffer)
-		cifs_buf_release(smb_buffer);
+	cifs_buf_release(smb_buffer);
 
 	return rc;
 }
@@ -2868,8 +2864,7 @@ CIFSNTLMSSPNegotiateSessSetup(unsigned i
 		rc = -EIO;
 	}
 
-	if (smb_buffer)
-		cifs_buf_release(smb_buffer);
+	cifs_buf_release(smb_buffer);
 
 	return rc;
 }
@@ -3277,8 +3272,7 @@ CIFSNTLMSSPAuthSessSetup(unsigned int xi
 		rc = -EIO;
 	}
 
-	if (smb_buffer)
-		cifs_buf_release(smb_buffer);
+	cifs_buf_release(smb_buffer);
 
 	return rc;
 }
@@ -3446,8 +3440,7 @@ CIFSTCon(unsigned int xid, struct cifsSe
 		ses->ipc_tid = smb_buffer_response->Tid;
 	}
 
-	if (smb_buffer)
-		cifs_buf_release(smb_buffer);
+	cifs_buf_release(smb_buffer);
 	return rc;
 }
 
@@ -3498,8 +3491,7 @@ cifs_umount(struct super_block *sb, stru
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

git-alsa.patch
sound-snd_register_device_for_dev-fix.patch
git-arm.patch
git-cifs.patch
git-powerpc.patch
git-dvb.patch
git-hid.patch
git-mmc.patch
git-mtd.patch
git-net.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
git-scsi-misc.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
