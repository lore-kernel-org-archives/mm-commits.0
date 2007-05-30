From: akpm@linux-foundation.org
Subject: + viotape-use-designated-initializers-for-fops-member.patch added to -mm tree
Date: Tue, 29 May 2007 19:54:43 -0700
Message-ID: <200705300254.l4U2sgqP017911@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbXE3Cyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 22:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, sfr@canb.auug.org.au


The patch titled
     VIOTAPE: use designated initializers for fops member structures
has been added to the -mm tree.  Its filename is
     viotape-use-designated-initializers-for-fops-member.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: VIOTAPE: use designated initializers for fops member structures
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace the old-style member initializers with the newer designated
initializers.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/viotape.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/char/viotape.c~viotape-use-designated-initializers-for-fops-member drivers/char/viotape.c
--- a/drivers/char/viotape.c~viotape-use-designated-initializers-for-fops-member
+++ a/drivers/char/viotape.c
@@ -873,12 +873,12 @@ free_op:
 }
 
 const struct file_operations viotap_fops = {
-	owner: THIS_MODULE,
-	read: viotap_read,
-	write: viotap_write,
-	ioctl: viotap_ioctl,
-	open: viotap_open,
-	release: viotap_release,
+	.owner =	THIS_MODULE,
+	.read =		viotap_read,
+	.write =	viotap_write,
+	.ioctl =	viotap_ioctl,
+	.open =		viotap_open,
+	.release =	viotap_release,
 };
 
 /* Handle interrupt events for tape */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-arm-master.patch
ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-dead-references-to-module_parm-macro.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
