From: akpm@linux-foundation.org
Subject: + round_up-macro-cleanup-in-fs-smbfs-requestc.patch added to -mm tree
Date: Fri, 06 Apr 2007 18:09:20 -0700
Message-ID: <200704070109.l3719K77024418@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41250 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933450AbXDGBJW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 21:09:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com


The patch titled
     ROUND_UP macro cleanup in fs/smbfs/request.c
has been added to the -mm tree.  Its filename is
     round_up-macro-cleanup-in-fs-smbfs-requestc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

unused-round_up-name_offset-macro-in-arch-powerpc.patch
round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
