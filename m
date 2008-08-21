From: akpm@linux-foundation.org
Subject: - drivers-firmware-iscsi_ibftc-make-3-functions-static.patch removed from -mm tree
Date: Thu, 21 Aug 2008 11:47:30 -0700
Message-ID: <200808211847.m7LIlUBU020197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754803AbYHUSrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 14:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     drivers/firmware/iscsi_ibft.c: make 3 functions static
has been removed from the -mm tree.  Its filename was
     drivers-firmware-iscsi_ibftc-make-3-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/firmware/iscsi_ibft.c: make 3 functions static
From: Adrian Bunk <bunk@kernel.org>

Make the following needlessly global functions static:

- ibft_attr_show_initiator()
- ibft_attr_show_nic()
- ibft_attr_show_target()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/iscsi_ibft.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/firmware/iscsi_ibft.c~drivers-firmware-iscsi_ibftc-make-3-functions-static drivers/firmware/iscsi_ibft.c
--- a/drivers/firmware/iscsi_ibft.c~drivers-firmware-iscsi_ibftc-make-3-functions-static
+++ a/drivers/firmware/iscsi_ibft.c
@@ -334,9 +334,9 @@ static void ibft_release(struct kobject 
 /*
  *  Routines for parsing the iBFT data to be human readable.
  */
-ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
-				  struct ibft_attribute *attr,
-				  char *buf)
+static ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
+					struct ibft_attribute *attr,
+					char *buf)
 {
 	struct ibft_initiator *initiator = entry->initiator;
 	void *ibft_loc = entry->header;
@@ -376,9 +376,9 @@ ssize_t ibft_attr_show_initiator(struct 
 	return str - buf;
 }
 
-ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
-			    struct ibft_attribute *attr,
-			    char *buf)
+static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
+				  struct ibft_attribute *attr,
+				  char *buf)
 {
 	struct ibft_nic *nic = entry->nic;
 	void *ibft_loc = entry->header;
@@ -440,9 +440,9 @@ ssize_t ibft_attr_show_nic(struct ibft_k
 	return str - buf;
 };
 
-ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
-			       struct ibft_attribute *attr,
-			       char *buf)
+static ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
+				     struct ibft_attribute *attr,
+				     char *buf)
 {
 	struct ibft_tgt *tgt = entry->tgt;
 	void *ibft_loc = entry->header;
_

Patches currently in -mm which might be from bunk@kernel.org are

ntfs-update-homepage.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
mpc8xxx_wdt-fix-modular-build.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
binfmt_somc-add-module_license.patch
make-probe_serial_gsc-static.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
make-ptrace_untrace-static.patch
fs-partitions-acornc-remove-dead-code.patch
parport-remove-cvs-keywords.patch
make-mm-rmapc-anon_vma_cachep-static.patch
ipc-semc-make-free_un-static.patch
make-fs-proc-proc_sysctlc-grab_header-static.patch
make-hp_wmi_notify-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
arm-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
sparc64-use-bcd2bin-bin2bcd.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

