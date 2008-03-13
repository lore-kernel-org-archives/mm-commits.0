From: akpm@linux-foundation.org
Subject: - acpi-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Thu, 13 Mar 2008 11:59:24 -0700
Message-ID: <200803131859.m2DIxOfK027952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676AbYCMTDF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     acpi-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/bus.c               |    2 +-
 drivers/acpi/scan.c              |    2 +-
 drivers/acpi/sleep/main.c        |    2 +-
 drivers/acpi/utilities/utdebug.c |    2 +-
 drivers/acpi/video.c             |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/acpi/bus.c~acpi-replace-remaining-__function__-occurrences drivers/acpi/bus.c
--- a/drivers/acpi/bus.c~acpi-replace-remaining-__function__-occurrences
+++ a/drivers/acpi/bus.c
@@ -776,7 +776,7 @@ static int __init acpi_init(void)
 
 	acpi_kobj = kobject_create_and_add("acpi", firmware_kobj);
 	if (!acpi_kobj) {
-		printk(KERN_WARNING "%s: kset create error\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: kset create error\n", __func__);
 		acpi_kobj = NULL;
 	}
 
diff -puN drivers/acpi/scan.c~acpi-replace-remaining-__function__-occurrences drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~acpi-replace-remaining-__function__-occurrences
+++ a/drivers/acpi/scan.c
@@ -967,7 +967,7 @@ static void acpi_device_set_id(struct ac
 	case ACPI_BUS_TYPE_DEVICE:
 		status = acpi_get_object_info(handle, &buffer);
 		if (ACPI_FAILURE(status)) {
-			printk(KERN_ERR PREFIX "%s: Error reading device info\n", __FUNCTION__);
+			printk(KERN_ERR PREFIX "%s: Error reading device info\n", __func__);
 			return;
 		}
 
diff -puN drivers/acpi/sleep/main.c~acpi-replace-remaining-__function__-occurrences drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-replace-remaining-__function__-occurrences
+++ a/drivers/acpi/sleep/main.c
@@ -504,7 +504,7 @@ static void acpi_power_off_prepare(void)
 static void acpi_power_off(void)
 {
 	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
-	printk("%s called\n", __FUNCTION__);
+	printk("%s called\n", __func__);
 	local_irq_disable();
 	acpi_enable_wakeup_device(ACPI_STATE_S5);
 	acpi_enter_sleep_state(ACPI_STATE_S5);
diff -puN drivers/acpi/utilities/utdebug.c~acpi-replace-remaining-__function__-occurrences drivers/acpi/utilities/utdebug.c
--- a/drivers/acpi/utilities/utdebug.c~acpi-replace-remaining-__function__-occurrences
+++ a/drivers/acpi/utilities/utdebug.c
@@ -109,7 +109,7 @@ void acpi_ut_track_stack_ptr(void)
  * RETURN:      Updated pointer to the function name
  *
  * DESCRIPTION: Remove the "Acpi" prefix from the function name, if present.
- *              This allows compiler macros such as __FUNCTION__ to be used
+ *              This allows compiler macros such as __func__ to be used
  *              with no change to the debug output.
  *
  ******************************************************************************/
diff -puN drivers/acpi/video.c~acpi-replace-remaining-__function__-occurrences drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-replace-remaining-__function__-occurrences
+++ a/drivers/acpi/video.c
@@ -1201,7 +1201,7 @@ static int acpi_video_bus_ROM_seq_show(s
 	if (!video)
 		goto end;
 
-	printk(KERN_INFO PREFIX "Please implement %s\n", __FUNCTION__);
+	printk(KERN_INFO PREFIX "Please implement %s\n", __func__);
 	seq_printf(seq, "<TODO>\n");
 
       end:
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
git-acpi.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
git-cifs.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
git-async-tx.patch
git-mips.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
power-replace-remaining-__function__-occurrences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ioc3c-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
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
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

