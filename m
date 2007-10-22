From: akpm@linux-foundation.org
Subject: + fix-versus-precedence-in-various-places-checkpatch-fixes.patch added to -mm tree
Date: Mon, 22 Oct 2007 15:23:44 -0700
Message-ID: <200710222223.l9MMNjtL018889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbXJVWZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 18:25:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adaplas@pol.net, adobriyan@gmail.com, davem@davemloft.net, jeff@garzik.org, jens.axboe@oracle.com, kkeil@suse.de, linville@tuxdriver.com, mark.fasheh@oracle.com, mchehab@infradead.org, petero2@telia.com, viro@zeniv.linux.org.uk


The patch titled
     fix-versus-precedence-in-various-places-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fix-versus-precedence-in-various-places-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix-versus-precedence-in-various-places-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#146: FILE: drivers/isdn/act2000/module.c:527:
+                if (!(card->flags & ACT2000_FLAGS_RUNNING))$

ERROR: use tabs not spaces
#155: FILE: drivers/isdn/act2000/module.c:542:
+                if (!(card->flags & ACT2000_FLAGS_RUNNING))$

ERROR: use tabs not spaces
#164: FILE: drivers/isdn/act2000/module.c:557:
+                if (!(card->flags & ACT2000_FLAGS_RUNNING))$

ERROR: need a space before the open parenthesis '('
#377: FILE: drivers/net/wireless/airo.c:6410:
+			if(!(dwrq->flags & IW_ENCODE_MODE)) {

WARNING: braces {} are not necessary for single statement blocks
#377: FILE: drivers/net/wireless/airo.c:6410:
+			if(!(dwrq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 			}

WARNING: braces {} are not necessary for single statement blocks
#389: FILE: drivers/net/wireless/atmel.c:1762:
+			if (!(dwrq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 			}

ERROR: need a space before the open parenthesis '('
#446: FILE: drivers/video/sis/sis_main.c:430:
+	if(!(buffer[0x14] & 0x80)) {

total: 5 errors, 2 warnings, 346 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Karsten Keil <kkeil@suse.de>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Peter Osterlund <petero2@telia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/act2000/module.c |    6 +++---
 drivers/net/wireless/airo.c   |    3 +--
 drivers/net/wireless/atmel.c  |    3 +--
 drivers/video/sis/sis_main.c  |    2 +-
 4 files changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/isdn/act2000/module.c~fix-versus-precedence-in-various-places-checkpatch-fixes drivers/isdn/act2000/module.c
--- a/drivers/isdn/act2000/module.c~fix-versus-precedence-in-various-places-checkpatch-fixes
+++ a/drivers/isdn/act2000/module.c
@@ -524,7 +524,7 @@ if_writecmd(const u_char __user *buf, in
         act2000_card *card = act2000_findcard(id);
 
         if (card) {
-                if (!(card->flags & ACT2000_FLAGS_RUNNING))
+		if (!(card->flags & ACT2000_FLAGS_RUNNING))
                         return -ENODEV;
                 return (len);
         }
@@ -539,7 +539,7 @@ if_readstatus(u_char __user * buf, int l
         act2000_card *card = act2000_findcard(id);
 	
         if (card) {
-                if (!(card->flags & ACT2000_FLAGS_RUNNING))
+		if (!(card->flags & ACT2000_FLAGS_RUNNING))
                         return -ENODEV;
                 return (act2000_readstatus(buf, len, card));
         }
@@ -554,7 +554,7 @@ if_sendbuf(int id, int channel, int ack,
         act2000_card *card = act2000_findcard(id);
 	
         if (card) {
-                if (!(card->flags & ACT2000_FLAGS_RUNNING))
+		if (!(card->flags & ACT2000_FLAGS_RUNNING))
                         return -ENODEV;
 		return (act2000_sendbuf(card, channel, ack, skb));
         }
diff -puN drivers/net/wireless/airo.c~fix-versus-precedence-in-various-places-checkpatch-fixes drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~fix-versus-precedence-in-various-places-checkpatch-fixes
+++ a/drivers/net/wireless/airo.c
@@ -6407,9 +6407,8 @@ static int airo_set_encode(struct net_de
 			set_wep_key(local, index, NULL, 0, perm, 1);
 		} else
 			/* Don't complain if only change the mode */
-			if(!(dwrq->flags & IW_ENCODE_MODE)) {
+			if (!(dwrq->flags & IW_ENCODE_MODE))
 				return -EINVAL;
-			}
 	}
 	/* Read the flags */
 	if(dwrq->flags & IW_ENCODE_DISABLED)
diff -puN drivers/net/wireless/atmel.c~fix-versus-precedence-in-various-places-checkpatch-fixes drivers/net/wireless/atmel.c
--- a/drivers/net/wireless/atmel.c~fix-versus-precedence-in-various-places-checkpatch-fixes
+++ a/drivers/net/wireless/atmel.c
@@ -1759,9 +1759,8 @@ static int atmel_set_encode(struct net_d
 			priv->default_key = index;
 		} else
 			/* Don't complain if only change the mode */
-			if (!(dwrq->flags & IW_ENCODE_MODE)) {
+			if (!(dwrq->flags & IW_ENCODE_MODE))
 				return -EINVAL;
-			}
 	}
 	/* Read the flags */
 	if (dwrq->flags & IW_ENCODE_DISABLED) {
diff -puN drivers/video/sis/sis_main.c~fix-versus-precedence-in-various-places-checkpatch-fixes drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~fix-versus-precedence-in-various-places-checkpatch-fixes
+++ a/drivers/video/sis/sis_main.c
@@ -427,7 +427,7 @@ sisfb_interpret_edid(struct sisfb_monito
 
 	monitor->feature = buffer[0x18];
 
-	if(!(buffer[0x14] & 0x80)) {
+	if (!(buffer[0x14] & 0x80)) {
 		if(!(buffer[0x14] & 0x08)) {
 			printk(KERN_INFO
 				"sisfb: WARNING: Monitor does not support separate syncs\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch
capabilities-clean-up-file-capability-reading.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
kexec-add-bss-to-resource-tree.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc.patch
git-unionfs.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
documentation-watchdog-src-watchdog-simplec-improve-this-code-checkpatch-fixes.patch
git-wireless.patch
git-wireless-fixup.patch
git-x86.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
