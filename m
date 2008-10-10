From: akpm@linux-foundation.org
Subject: + gdth-fix-section-mismatch-warnings.patch added to -mm tree
Date: Fri, 10 Oct 2008 13:07:07 -0700
Message-ID: <200810102007.m9AK77sU029476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760458AbYJJUIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 16:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, achim_leubner@adaptec.com


The patch titled
     gdth: fix section mismatch warnings
has been added to the -mm tree.  Its filename is
     gdth-fix-section-mismatch-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gdth: fix section mismatch warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Could fix a bug in a hotplug scenario.

WARNING: drivers/scsi/gdth.o(.text+0x3e6d): Section mismatch in reference from the function gdth_pci_probe_one() to the function .init.text:gdth_search_drives()
The function gdth_pci_probe_one() references
the function __init gdth_search_drives().
This is often because gdth_pci_probe_one lacks a __init
annotation or the annotation of gdth_search_drives is wrong.

WARNING: drivers/scsi/gdth.o(.text+0x3f78): Section mismatch in reference from the function gdth_pci_probe_one() to the function .init.text:gdth_enable_int()
The function gdth_pci_probe_one() references
the function __init gdth_enable_int().
This is often because gdth_pci_probe_one lacks a __init
annotation or the annotation of gdth_enable_int is wrong.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Achim Leubner <achim_leubner@adaptec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/gdth.c~gdth-fix-section-mismatch-warnings drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~gdth-fix-section-mismatch-warnings
+++ a/drivers/scsi/gdth.c
@@ -1238,7 +1238,7 @@ static int gdth_init_pci(struct pci_dev 
 
 /* controller protocol functions */
 
-static void __init gdth_enable_int(gdth_ha_str *ha)
+static void gdth_enable_int(gdth_ha_str *ha)
 {
     ulong flags;
     gdt2_dpram_str __iomem *dp2_ptr;
@@ -1554,7 +1554,7 @@ static int gdth_internal_cmd(gdth_ha_str
 
 /* search for devices */
 
-static int __init gdth_search_drives(gdth_ha_str *ha)
+static int gdth_search_drives(gdth_ha_str *ha)
 {
     ushort cdev_cnt, i;
     int ok;
@@ -4932,7 +4932,7 @@ static int __init gdth_eisa_probe_one(us
 #endif /* CONFIG_EISA */
 
 #ifdef CONFIG_PCI
-static int gdth_pci_probe_one(gdth_pci_str *pcistr,
+int gdth_pci_probe_one(gdth_pci_str *pcistr,
 			     gdth_ha_str **ha_out)
 {
 	struct Scsi_Host *shp;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-tip.patch
git-hid.patch
git-net.patch
git-sound.patch
git-block.patch
git-drm.patch
git-security-testing.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
toshiba_acpi-depends-on-input.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
eeepc-laptop-use-standard-interfaces-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
documentation-explain-memory-barriers.patch
docbook-update-procfs-credits.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support-fix.patch
profile-likely-unlikely-macros.patch

