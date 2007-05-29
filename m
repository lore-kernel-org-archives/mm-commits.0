From: akpm@linux-foundation.org
Subject: + vt8623fb-arkfb-null-pointer-dereference-fix.patch added to -mm tree
Date: Tue, 29 May 2007 15:51:50 -0700
Message-ID: <200705292251.l4TMpof6013637@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbXE2WwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 18:52:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: santiago@crfreenet.org, adaplas@gmail.com


The patch titled
     vt8623fb: arkfb: null pointer dereference fix
has been added to the -mm tree.  Its filename is
     vt8623fb-arkfb-null-pointer-dereference-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vt8623fb: arkfb: null pointer dereference fix
From: Ondrej Zajicek <santiago@crfreenet.org>

This patch prevents null pointer dereference in arkfb and vt8623fb.

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arkfb.c    |    3 ++-
 drivers/video/vt8623fb.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/arkfb.c~vt8623fb-arkfb-null-pointer-dereference-fix drivers/video/arkfb.c
--- a/drivers/video/arkfb.c~vt8623fb-arkfb-null-pointer-dereference-fix
+++ a/drivers/video/arkfb.c
@@ -1055,9 +1055,10 @@ err_enable_device:
 static void __devexit ark_pci_remove(struct pci_dev *dev)
 {
 	struct fb_info *info = pci_get_drvdata(dev);
-	struct arkfb_info *par = info->par;
 
 	if (info) {
+		struct arkfb_info *par = info->par;
+
 #ifdef CONFIG_MTRR
 		if (par->mtrr_reg >= 0) {
 			mtrr_del(par->mtrr_reg, 0, 0);
diff -puN drivers/video/vt8623fb.c~vt8623fb-arkfb-null-pointer-dereference-fix drivers/video/vt8623fb.c
--- a/drivers/video/vt8623fb.c~vt8623fb-arkfb-null-pointer-dereference-fix
+++ a/drivers/video/vt8623fb.c
@@ -778,9 +778,10 @@ err_enable_device:
 static void __devexit vt8623_pci_remove(struct pci_dev *dev)
 {
 	struct fb_info *info = pci_get_drvdata(dev);
-	struct vt8623fb_info *par = info->par;
 
 	if (info) {
+		struct vt8623fb_info *par = info->par;
+
 #ifdef CONFIG_MTRR
 		if (par->mtrr_reg >= 0) {
 			mtrr_del(par->mtrr_reg, 0, 0);
_

Patches currently in -mm which might be from santiago@crfreenet.org are

vt8623fb-arkfb-null-pointer-dereference-fix.patch
