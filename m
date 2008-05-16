From: akpm@linux-foundation.org
Subject: - parisc-replace-remaining-__function__-occurences.patch removed from -mm tree
Date: Fri, 16 May 2008 15:54:05 -0700
Message-ID: <200805162254.m4GMs5D0003206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758215AbYEPWyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, grundler@parisc-linux.org, kyle@mcmartin.ca, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     parisc: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     parisc-replace-remaining-__function__-occurences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parisc: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/inventory.c |    2 +-
 arch/parisc/kernel/traps.c     |    2 +-
 arch/parisc/kernel/unaligned.c |    2 +-
 arch/parisc/lib/memcpy.c       |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/parisc/kernel/inventory.c~parisc-replace-remaining-__function__-occurences arch/parisc/kernel/inventory.c
--- a/arch/parisc/kernel/inventory.c~parisc-replace-remaining-__function__-occurences
+++ a/arch/parisc/kernel/inventory.c
@@ -499,7 +499,7 @@ add_system_map_addresses(struct parisc_d
 	dev->addr = kmalloc(num_addrs * sizeof(unsigned long), GFP_KERNEL);
 	if(!dev->addr) {
 		printk(KERN_ERR "%s %s(): memory allocation failure\n",
-		       __FILE__, __FUNCTION__);
+		       __FILE__, __func__);
 		return;
 	}
 
diff -puN arch/parisc/kernel/traps.c~parisc-replace-remaining-__function__-occurences arch/parisc/kernel/traps.c
--- a/arch/parisc/kernel/traps.c~parisc-replace-remaining-__function__-occurences
+++ a/arch/parisc/kernel/traps.c
@@ -275,7 +275,7 @@ KERN_CRIT "                     ||     |
 
 	/* Wot's wrong wif bein' racy? */
 	if (current->thread.flags & PARISC_KERNEL_DEATH) {
-		printk(KERN_CRIT "%s() recursion detected.\n", __FUNCTION__);
+		printk(KERN_CRIT "%s() recursion detected.\n", __func__);
 		local_irq_enable();
 		while (1);
 	}
diff -puN arch/parisc/kernel/unaligned.c~parisc-replace-remaining-__function__-occurences arch/parisc/kernel/unaligned.c
--- a/arch/parisc/kernel/unaligned.c~parisc-replace-remaining-__function__-occurences
+++ a/arch/parisc/kernel/unaligned.c
@@ -30,7 +30,7 @@
 /* #define DEBUG_UNALIGNED 1 */
 
 #ifdef DEBUG_UNALIGNED
-#define DPRINTF(fmt, args...) do { printk(KERN_DEBUG "%s:%d:%s ", __FILE__, __LINE__, __FUNCTION__ ); printk(KERN_DEBUG fmt, ##args ); } while (0)
+#define DPRINTF(fmt, args...) do { printk(KERN_DEBUG "%s:%d:%s ", __FILE__, __LINE__, __func__ ); printk(KERN_DEBUG fmt, ##args ); } while (0)
 #else
 #define DPRINTF(fmt, args...)
 #endif
diff -puN arch/parisc/lib/memcpy.c~parisc-replace-remaining-__function__-occurences arch/parisc/lib/memcpy.c
--- a/arch/parisc/lib/memcpy.c~parisc-replace-remaining-__function__-occurences
+++ a/arch/parisc/lib/memcpy.c
@@ -91,7 +91,7 @@ DECLARE_PER_CPU(struct exception_data, e
 #define THRESHOLD	16
 
 #ifdef DEBUG_MEMCPY
-#define DPRINTF(fmt, args...) do { printk(KERN_DEBUG "%s:%d:%s ", __FILE__, __LINE__, __FUNCTION__ ); printk(KERN_DEBUG fmt, ##args ); } while (0)
+#define DPRINTF(fmt, args...) do { printk(KERN_DEBUG "%s:%d:%s ", __FILE__, __LINE__, __func__ ); printk(KERN_DEBUG fmt, ##args ); } while (0)
 #else
 #define DPRINTF(fmt, args...)
 #endif
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
nfs-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
sh-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

