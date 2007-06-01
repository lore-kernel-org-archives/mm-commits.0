From: akpm@linux-foundation.org
Subject: - vt8623fb-arkfb-null-pointer-dereference-fix.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:32 -0700
Message-ID: <200706011747.l51HlVk5015132@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761300AbXFARrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: santiago@crfreenet.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vt8623fb: arkfb: null pointer dereference fix
has been removed from the -mm tree.  Its filename was
     vt8623fb-arkfb-null-pointer-dereference-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
