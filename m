From: akpm@linux-foundation.org
Subject: + remove-nfs4_acl_add_ace.patch added to -mm tree
Date: Sun, 25 Mar 2007 14:27:33 -0800
Message-ID: <200703252227.l2PMRXvc004188@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32921 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbXCYWa4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 18:30:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, neilb@cse.unsw.edu.au


The patch titled
     remove nfs4_acl_add_ace()
has been added to the -mm tree.  Its filename is
     remove-nfs4_acl_add_ace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove nfs4_acl_add_ace()
From: Adrian Bunk <bunk@stusta.de>

nfs4_acl_add_ace() can now be removed.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Neil Brown <neilb@cse.unsw.edu.au>
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
drivers-spi-fix-section-mismatches.patch
dynticks-fix-hrtimer-rounding-error-in.patch
clocksource-fix-thinko-in-watchdog-selection.patch
drivers-eisa-pci_eisacpci_eisa_init-should-be-init.patch
net-sunrpc-svcsockc-fix-a-check.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
make-struct-v9fs_cached_file_operations-static.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages-tidy.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
drivers-mfd-sm501c-fix-an-off-by-one.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
make-mptspi_target_destroy-static.patch
make-remove_inode_dquot_ref-static.patch
remove-nfs4_acl_add_ace.patch
