From: akpm@linux-foundation.org
Subject: + ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch added to -mm tree
Date: Tue, 29 May 2007 17:34:02 -0700
Message-ID: <200705300034.l4U0Y2xT015462@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbXE3AeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 20:34:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     PPC: remove dead code for preventing pread() and pwrite() calls
has been added to the -mm tree.  Its filename is
     ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PPC: remove dead code for preventing pread() and pwrite() calls
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the deactivated code for checking for pread() and pwrite()
calls on the PPC-based BRIQ.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/briq_panel.c |   10 ----------
 1 files changed, 10 deletions(-)

diff -puN drivers/char/briq_panel.c~ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls drivers/char/briq_panel.c
--- a/drivers/char/briq_panel.c~ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls
+++ a/drivers/char/briq_panel.c
@@ -91,11 +91,6 @@ static ssize_t briq_panel_read(struct fi
 	unsigned short c;
 	unsigned char cp;
 
-#if 0	/*  Can't seek (pread) on this device  */
-	if (ppos != &file->f_pos)
-		return -ESPIPE;
-#endif
-
 	if (!vfd_is_open)
 		return -ENODEV;
 
@@ -139,11 +134,6 @@ static ssize_t briq_panel_write(struct f
 	size_t indx = len;
 	int i, esc = 0;
 
-#if 0	/*  Can't seek (pwrite) on this device  */
-	if (ppos != &file->f_pos)
-		return -ESPIPE;
-#endif
-
 	if (!vfd_is_open)
 		return -EBUSY;
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-arm-master.patch
ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-dead-references-to-module_parm-macro.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
