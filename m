From: akpm@linux-foundation.org
Subject: + ieee1394-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 19:50:03 -0800
Message-ID: <200803060350.m263o3vR007321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756631AbYCFDux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 22:50:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, stefanr@s5r6.in-berlin.de


The patch titled
     ieee1394: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     ieee1394-replace-remaining-__function__-occurrences.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ieee1394: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ieee1394/highlevel.c     |    6 +++---
 drivers/ieee1394/ieee1394_core.c |    2 +-
 drivers/ieee1394/ohci1394.c      |    2 +-
 drivers/ieee1394/pcilynx.c       |   12 ++++++------
 drivers/ieee1394/sbp2.c          |    4 ++--
 5 files changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/ieee1394/highlevel.c~ieee1394-replace-remaining-__function__-occurrences drivers/ieee1394/highlevel.c
--- a/drivers/ieee1394/highlevel.c~ieee1394-replace-remaining-__function__-occurrences
+++ a/drivers/ieee1394/highlevel.c
@@ -339,7 +339,7 @@ u64 hpsb_allocate_and_register_addrspace
 	if ((alignment & 3) || (alignment > 0x800000000000ULL) ||
 	    (hweight64(alignment) != 1)) {
 		HPSB_ERR("%s called with invalid alignment: 0x%048llx",
-			 __FUNCTION__, (unsigned long long)alignment);
+			 __func__, (unsigned long long)alignment);
 		return retval;
 	}
 
@@ -354,7 +354,7 @@ u64 hpsb_allocate_and_register_addrspace
 	if (((start|end) & ~align_mask) || (start >= end) ||
 	    (end > CSR1212_ALL_SPACE_END)) {
 		HPSB_ERR("%s called with invalid addresses "
-			 "(start = %012Lx  end = %012Lx)", __FUNCTION__,
+			 "(start = %012Lx  end = %012Lx)", __func__,
 			 (unsigned long long)start,(unsigned long long)end);
 		return retval;
 	}
@@ -422,7 +422,7 @@ int hpsb_register_addrspace(struct hpsb_
 
 	if (((start|end) & 3) || (start >= end) ||
 	    (end > CSR1212_ALL_SPACE_END)) {
-		HPSB_ERR("%s called with invalid addresses", __FUNCTION__);
+		HPSB_ERR("%s called with invalid addresses", __func__);
 		return 0;
 	}
 
diff -puN drivers/ieee1394/ieee1394_core.c~ieee1394-replace-remaining-__function__-occurrences drivers/ieee1394/ieee1394_core.c
--- a/drivers/ieee1394/ieee1394_core.c~ieee1394-replace-remaining-__function__-occurrences
+++ a/drivers/ieee1394/ieee1394_core.c
@@ -242,7 +242,7 @@ int hpsb_bus_reset(struct hpsb_host *hos
 {
 	if (host->in_bus_reset) {
 		HPSB_NOTICE("%s called while bus reset already in progress",
-			    __FUNCTION__);
+			    __func__);
 		return 1;
 	}
 
diff -puN drivers/ieee1394/ohci1394.c~ieee1394-replace-remaining-__function__-occurrences drivers/ieee1394/ohci1394.c
--- a/drivers/ieee1394/ohci1394.c~ieee1394-replace-remaining-__function__-occurrences
+++ a/drivers/ieee1394/ohci1394.c
@@ -708,7 +708,7 @@ static void insert_packet(struct ti_ohci
                                 /* FIXME: do something about it */
                                 PRINT(KERN_ERR,
                                       "%s: packet data addr: %p size %Zd bytes "
-                                      "cross page boundary", __FUNCTION__,
+				      "cross page boundary", __func__,
                                       packet->data, packet->data_size);
                         }
 #endif
diff -puN drivers/ieee1394/pcilynx.c~ieee1394-replace-remaining-__function__-occurrences drivers/ieee1394/pcilynx.c
--- a/drivers/ieee1394/pcilynx.c~ieee1394-replace-remaining-__function__-occurrences
+++ a/drivers/ieee1394/pcilynx.c
@@ -226,7 +226,7 @@ static int get_phy_reg(struct ti_lynx *l
         if (addr > 15) {
                 PRINT(KERN_ERR, lynx->id,
                       "%s: PHY register address %d out of range",
-		      __FUNCTION__, addr);
+		      __func__, addr);
                 return -1;
         }
 
@@ -238,7 +238,7 @@ static int get_phy_reg(struct ti_lynx *l
 
                 if (i > 10000) {
                         PRINT(KERN_ERR, lynx->id, "%s: runaway loop, aborting",
-			      __FUNCTION__);
+			      __func__);
                         retval = -1;
                         break;
                 }
@@ -261,13 +261,13 @@ static int set_phy_reg(struct ti_lynx *l
 
         if (addr > 15) {
                 PRINT(KERN_ERR, lynx->id,
-                      "%s: PHY register address %d out of range", __FUNCTION__, addr);
+		      "%s: PHY register address %d out of range", __func__, addr);
                 return -1;
         }
 
         if (val > 0xff) {
                 PRINT(KERN_ERR, lynx->id,
-                      "%s: PHY register value %d out of range", __FUNCTION__, val);
+		      "%s: PHY register value %d out of range", __func__, val);
                 return -1;
         }
 
@@ -287,7 +287,7 @@ static int sel_phy_reg_page(struct ti_ly
 
         if (page > 7) {
                 PRINT(KERN_ERR, lynx->id,
-                      "%s: PHY page %d out of range", __FUNCTION__, page);
+		      "%s: PHY page %d out of range", __func__, page);
                 return -1;
         }
 
@@ -309,7 +309,7 @@ static int sel_phy_reg_port(struct ti_ly
 
         if (port > 15) {
                 PRINT(KERN_ERR, lynx->id,
-                      "%s: PHY port %d out of range", __FUNCTION__, port);
+		      "%s: PHY port %d out of range", __func__, port);
                 return -1;
         }
 
diff -puN drivers/ieee1394/sbp2.c~ieee1394-replace-remaining-__function__-occurrences drivers/ieee1394/sbp2.c
--- a/drivers/ieee1394/sbp2.c~ieee1394-replace-remaining-__function__-occurrences
+++ a/drivers/ieee1394/sbp2.c
@@ -610,7 +610,7 @@ static struct sbp2_command_info *sbp2uti
 		cmd->Current_SCpnt = Current_SCpnt;
 		list_add_tail(&cmd->list, &lu->cmd_orb_inuse);
 	} else
-		SBP2_ERR("%s: no orbs available", __FUNCTION__);
+		SBP2_ERR("%s: no orbs available", __func__);
 	spin_unlock_irqrestore(&lu->cmd_orb_lock, flags);
 	return cmd;
 }
@@ -1289,7 +1289,7 @@ static int sbp2_set_busy_timeout(struct 
 
 	data = cpu_to_be32(SBP2_BUSY_TIMEOUT_VALUE);
 	if (hpsb_node_write(lu->ne, SBP2_BUSY_TIMEOUT_ADDRESS, &data, 4))
-		SBP2_ERR("%s error", __FUNCTION__);
+		SBP2_ERR("%s error", __func__);
 	return 0;
 }
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
cifs-replace-remaining-__function__-occurrences.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
drivers-base-replace-remaining-__function__-occurrences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
jfs-replace-__inline-with-inline.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
mips-replace-__inline-with-inline.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
net-replace-__inline-with-inline.patch
irda-replace-__inline-with-inline.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
sh-replace-remaining-__function__-occurences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-stc-make-class-attributes-static.patch
scsi-osstc-make-class-attributes-static.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
isdn-replace-__inline-with-inline.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch
acpi-replace-remaining-__function__-occurrences.patch
ata-replace-remaining-__function__-occurrences.patch
block-replace-remaining-__function__-occurrences.patch
iop-admac-replace-remaining-__function__-occurrences.patch
ieee1394-replace-remaining-__function__-occurrences.patch
firmware-replace-remaining-__function__-occurrences.patch
mtd-replace-remaining-__function__-occurrences.patch
md-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
ioc3c-replace-remaining-__function__-occurrences.patch
watchdog-replace-remaining-__function__-occurrences.patch
spi-replace-remaining-__function__-occurrences.patch
power-replace-remaining-__function__-occurrences.patch
drivers-replace-remaining-__function__-occurrences.patch

