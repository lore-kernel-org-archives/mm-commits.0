From: akpm@linux-foundation.org
Subject: - round_up-macro-cleanup-in-fs-smbfs-requestc.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:10 -0700
Message-ID: <200705090249.l492nAgr009194@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966107AbXEICtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ROUND_UP macro cleanup in fs/smbfs/request.c
has been removed from the -mm tree.  Its filename was
     round_up-macro-cleanup-in-fs-smbfs-requestc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ROUND_UP macro cleanup in fs/smbfs/request.c
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

ROUND_UP macro cleanup use ALIGN

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/smbfs/request.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/smbfs/request.c~round_up-macro-cleanup-in-fs-smbfs-requestc fs/smbfs/request.c
--- a/fs/smbfs/request.c~round_up-macro-cleanup-in-fs-smbfs-requestc
+++ a/fs/smbfs/request.c
@@ -6,6 +6,7 @@
  *  Please add a note about your changes to smbfs in the ChangeLog file.
  */
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
@@ -22,8 +23,6 @@
 /* #define SMB_SLAB_DEBUG	(SLAB_RED_ZONE | SLAB_POISON) */
 #define SMB_SLAB_DEBUG	0
 
-#define ROUND_UP(x) (((x)+3) & ~3)
-
 /* cache for request structures */
 static struct kmem_cache *req_cachep;
 
@@ -200,8 +199,8 @@ static int smb_setup_trans2request(struc
 
 	const int smb_parameters = 15;
 	const int header = SMB_HEADER_LEN + 2 * smb_parameters + 2;
-	const int oparam = ROUND_UP(header + 3);
-	const int odata  = ROUND_UP(oparam + req->rq_lparm);
+	const int oparam = ALIGN(header + 3, sizeof(u32));
+	const int odata  = ALIGN(oparam + req->rq_lparm, sizeof(u32));
 	const int bcc = (req->rq_data ? odata + req->rq_ldata :
 					oparam + req->rq_lparm) - header;
 
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

origin.patch
git-alsa.patch
git-ia64.patch
spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
nfs-use-__set_current_state.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
