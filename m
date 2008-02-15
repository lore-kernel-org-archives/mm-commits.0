From: akpm@linux-foundation.org
Subject: - powerpc-free_property-mustnt-be-__init.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:17:21 -0500
Message-ID: <200802150720.m1F7KhGY025847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46868 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763376AbYBOH3g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:29:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     powerpc: free_property() mustn't be __init
has been removed from the -mm tree.  Its filename was
     powerpc-free_property-mustnt-be-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: free_property() mustn't be __init
From: Adrian Bunk <bunk@kernel.org>

WARNING: vmlinux.o(.text+0x55648): Section mismatch in reference from the function .free_node() to the function .init.text:.free_property()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/iseries/vio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/platforms/iseries/vio.c~powerpc-free_property-mustnt-be-__init arch/powerpc/platforms/iseries/vio.c
--- a/arch/powerpc/platforms/iseries/vio.c~powerpc-free_property-mustnt-be-__init
+++ a/arch/powerpc/platforms/iseries/vio.c
@@ -75,7 +75,7 @@ static struct property *new_property(con
 	return np;
 }
 
-static void __init free_property(struct property *np)
+static void free_property(struct property *np)
 {
 	kfree(np);
 }
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-gfs2-nmw.patch
git-kbuild.patch
git-net.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
sparc-fix-build.patch
reiser4.patch
