From: akpm@linux-foundation.org
Subject: - remove-nfs4_acl_add_ace.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:45 -0700
Message-ID: <200705092152.l49LqjKF003026@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759462AbXEIVxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:53:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, bfields@citi.umich.edu, neilb@cse.unsw.edu.au, mm-commits@vger.kernel.org


The patch titled
     remove nfs4_acl_add_ace()
has been removed from the -mm tree.  Its filename was
     remove-nfs4_acl_add_ace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove nfs4_acl_add_ace()
From: Adrian Bunk <bunk@stusta.de>

nfs4_acl_add_ace() can now be removed.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Neil Brown <neilb@cse.unsw.edu.au>
Acked-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4acl.c        |   17 -----------------
 include/linux/nfs4_acl.h |    1 -
 2 files changed, 18 deletions(-)

diff -puN fs/nfsd/nfs4acl.c~remove-nfs4_acl_add_ace fs/nfsd/nfs4acl.c
--- a/fs/nfsd/nfs4acl.c~remove-nfs4_acl_add_ace
+++ a/fs/nfsd/nfs4acl.c
@@ -137,7 +137,6 @@ struct ace_container {
 static short ace2type(struct nfs4_ace *);
 static void _posix_to_nfsv4_one(struct posix_acl *, struct nfs4_acl *,
 				unsigned int);
-void nfs4_acl_add_ace(struct nfs4_acl *, u32, u32, u32, int, uid_t);
 
 struct nfs4_acl *
 nfs4_acl_posix_to_nfsv4(struct posix_acl *pacl, struct posix_acl *dpacl,
@@ -785,21 +784,6 @@ nfs4_acl_new(int n)
 	return acl;
 }
 
-void
-nfs4_acl_add_ace(struct nfs4_acl *acl, u32 type, u32 flag, u32 access_mask,
-		int whotype, uid_t who)
-{
-	struct nfs4_ace *ace = acl->aces + acl->naces;
-
-	ace->type = type;
-	ace->flag = flag;
-	ace->access_mask = access_mask;
-	ace->whotype = whotype;
-	ace->who = who;
-
-	acl->naces++;
-}
-
 static struct {
 	char *string;
 	int   stringlen;
@@ -851,6 +835,5 @@ nfs4_acl_write_who(int who, char *p)
 }
 
 EXPORT_SYMBOL(nfs4_acl_new);
-EXPORT_SYMBOL(nfs4_acl_add_ace);
 EXPORT_SYMBOL(nfs4_acl_get_whotype);
 EXPORT_SYMBOL(nfs4_acl_write_who);
diff -puN include/linux/nfs4_acl.h~remove-nfs4_acl_add_ace include/linux/nfs4_acl.h
--- a/include/linux/nfs4_acl.h~remove-nfs4_acl_add_ace
+++ a/include/linux/nfs4_acl.h
@@ -44,7 +44,6 @@
 #define NFS4_ACL_MAX 170
 
 struct nfs4_acl *nfs4_acl_new(int);
-void nfs4_acl_add_ace(struct nfs4_acl *, u32, u32, u32, int, uid_t);
 int nfs4_acl_get_whotype(char *, u32);
 int nfs4_acl_write_who(int who, char *p);
 int nfs4_acl_permission(struct nfs4_acl *acl, uid_t owner, gid_t group,
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-dvb.patch
git-ieee1394.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
ibmtr_cs-fix-hang-on-eject.patch
git-battery.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
drivers-scsi-ipsc-remove-kernel-24-code.patch
drivers-scsi-nsp32c-remove-kernel-24-code.patch
git-unionfs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
unexport-pci_proc_attach_device.patch
ext2-reservations.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
