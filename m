From: akpm@linux-foundation.org
Subject: + nfsd-fix-wrong-mnt_writer-count-in-rename-fix.patch added to -mm tree
Date: Tue, 13 Nov 2007 21:21:23 -0800
Message-ID: <200711140521.lAE5LNKq022888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36352 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbXKNFVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 00:21:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com, haveblue@us.ibm.com


The patch titled
     Build fails - in nsfd/vfs.c
has been added to the -mm tree.  Its filename is
     nfsd-fix-wrong-mnt_writer-count-in-rename-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Build fails - in nsfd/vfs.c
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

The Kernel build fails, with error

  CC      fs/nfsd/vfs.o
fs/nfsd/vfs.c: In function `nfsd_rename':
fs/nfsd/vfs.c:1695: error: request for member `mnt' in something not a structure or union
make[2]: *** [fs/nfsd/vfs.o] Error 1
make[1]: *** [fs/nfsd] Error 2
make: *** [fs] Error 2

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfsd/vfs.c~nfsd-fix-wrong-mnt_writer-count-in-rename-fix fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~nfsd-fix-wrong-mnt_writer-count-in-rename-fix
+++ a/fs/nfsd/vfs.c
@@ -1688,7 +1688,7 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 		if (!host_err)
 			host_err = nfsd_sync_dir(fdentry);
 	}
-	mnt_drop_write(ffhp->fh_export->ex_path.mnt);
+	mnt_drop_write(ffhp->fh_export->ex_mnt);
 
  out_dput_new:
 	dput(ndentry);
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

chipsfb-uses-depends-on-pci.patch
export-acpi_check_resource_conflict.patch
fix-gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse.patch
config_highpte-vs-sub-page-page-tables-fix.patch
nfsd-fix-wrong-mnt_writer-count-in-rename-fix.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch
