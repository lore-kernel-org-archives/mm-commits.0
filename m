From: akpm@linux-foundation.org
Subject: - scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:06:57 -0700
Message-ID: <200706010706.l5176u1H004747@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbXFAHHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:07:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, James.Bottomley@steeleye.com, achim_leubner@adaptec.com, mm-commits@vger.kernel.org


The patch titled
     SCSI: Fix obvious typo "spin_lock_irqrestore()" in gdth.c
has been removed from the -mm tree.  Its filename was
     scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SCSI: Fix obvious typo "spin_lock_irqrestore()" in gdth.c
From: "Robert P. J. Day" <rpjday@mindspring.com>

Fix misspelled "spin_lock_irqrestore" to read "spin_unlock_irqrestore"
instead.

Presumably, GDTH_RTC doesn't get used a lot.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: <achim_leubner@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/gdth.c~scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc
+++ a/drivers/scsi/gdth.c
@@ -1955,7 +1955,7 @@ static int __init gdth_search_drives(int
         for (j = 0; j < 12; ++j) 
             rtc[j] = CMOS_READ(j);
     } while (rtc[0] != CMOS_READ(0));
-    spin_lock_irqrestore(&rtc_lock, flags);
+    spin_unlock_irqrestore(&rtc_lock, flags);
     TRACE2(("gdth_search_drives(): RTC: %x/%x/%x\n",*(ulong32 *)&rtc[0],
             *(ulong32 *)&rtc[4], *(ulong32 *)&rtc[8]));
     /* 3. send to controller firmware */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
