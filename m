From: akpm@linux-foundation.org
Subject: + scsi-make-struct-scsi_hosttarget_type-static.patch added to -mm tree
Date: Wed, 25 Jun 2008 14:24:09 -0700
Message-ID: <200806252124.m5PLOd9e027574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573AbYFYVcV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 17:32:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, James.Bottomley@HansenPartnership.com


The patch titled
     scsi: make struct scsi_{host,target}_type static
has been added to the -mm tree.  Its filename is
     scsi-make-struct-scsi_hosttarget_type-static.patch

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
Subject: scsi: make struct scsi_{host,target}_type static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global struct scsi_{host,target}_type static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hosts.c     |    2 +-
 drivers/scsi/scsi_scan.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/hosts.c~scsi-make-struct-scsi_hosttarget_type-static drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c~scsi-make-struct-scsi_hosttarget_type-static
+++ a/drivers/scsi/hosts.c
@@ -290,7 +290,7 @@ static void scsi_host_dev_release(struct
 	kfree(shost);
 }
 
-struct device_type scsi_host_type = {
+static struct device_type scsi_host_type = {
 	.name =		"scsi_host",
 	.release =	scsi_host_dev_release,
 };
diff -puN drivers/scsi/scsi_scan.c~scsi-make-struct-scsi_hosttarget_type-static drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~scsi-make-struct-scsi_hosttarget_type-static
+++ a/drivers/scsi/scsi_scan.c
@@ -346,7 +346,7 @@ static void scsi_target_dev_release(stru
 	put_device(parent);
 }
 
-struct device_type scsi_target_type = {
+static struct device_type scsi_target_type = {
 	.name =		"scsi_target",
 	.release =	scsi_target_dev_release,
 };
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
firmware-fix-the-request_firmware-dummy.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
if-0-ses_match_host.patch
scsi-make-struct-scsi_hosttarget_type-static.patch
git-xtensa.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
mm-page_allocc-cleanups.patch
remove-include-asm-h8300-keyboardh.patch
remove-include-linux-pm_legacyh.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-spawn_ksoftirqd-prototype.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
include-linux-kernelh-userspace-header-cleanup.patch
remove-the-oss-trident-driver.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
serial-8250_gscc-add-module_license.patch
video-sis-remove-compat-code.patch
minix-remove-no_truncate-code.patch
jbd-unexport-journal_update_superblock.patch
coda-remove-coda_fs_old_api.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
remove-is_tty.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
reiser4.patch

