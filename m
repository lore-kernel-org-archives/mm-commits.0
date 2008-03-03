From: akpm@linux-foundation.org
Subject: + m68k-replace-remaining-__function__-occurences.patch added to -mm tree
Date: Mon, 03 Mar 2008 13:27:28 -0800
Message-ID: <200803032127.m23LRST0007443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755573AbYCCV1m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 16:27:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     m68k: replace remaining __FUNCTION__ occurences
has been added to the -mm tree.  Its filename is
     m68k-replace-remaining-__function__-occurences.patch

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
Subject: m68k: replace remaining __FUNCTION__ occurences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/ints.c |   10 +++++-----
 arch/m68k/mac/oss.c     |    4 ++--
 arch/m68k/q40/q40ints.c |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/m68k/kernel/ints.c~m68k-replace-remaining-__function__-occurences arch/m68k/kernel/ints.c
--- a/arch/m68k/kernel/ints.c~m68k-replace-remaining-__function__-occurences
+++ a/arch/m68k/kernel/ints.c
@@ -186,7 +186,7 @@ int setup_irq(unsigned int irq, struct i
 
 	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
 		printk("%s: Incorrect IRQ %d from %s\n",
-		       __FUNCTION__, irq, node->devname);
+		       __func__, irq, node->devname);
 		return -ENXIO;
 	}
 
@@ -249,7 +249,7 @@ void free_irq(unsigned int irq, void *de
 	unsigned long flags;
 
 	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
-		printk("%s: Incorrect IRQ %d\n", __FUNCTION__, irq);
+		printk("%s: Incorrect IRQ %d\n", __func__, irq);
 		return;
 	}
 
@@ -267,7 +267,7 @@ void free_irq(unsigned int irq, void *de
 		node->handler = NULL;
 	} else
 		printk("%s: Removing probably wrong IRQ %d\n",
-		       __FUNCTION__, irq);
+		       __func__, irq);
 
 	if (!irq_list[irq]) {
 		if (contr->shutdown)
@@ -288,7 +288,7 @@ void enable_irq(unsigned int irq)
 
 	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
 		printk("%s: Incorrect IRQ %d\n",
-		       __FUNCTION__, irq);
+		       __func__, irq);
 		return;
 	}
 
@@ -312,7 +312,7 @@ void disable_irq(unsigned int irq)
 
 	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
 		printk("%s: Incorrect IRQ %d\n",
-		       __FUNCTION__, irq);
+		       __func__, irq);
 		return;
 	}
 
diff -puN arch/m68k/mac/oss.c~m68k-replace-remaining-__function__-occurences arch/m68k/mac/oss.c
--- a/arch/m68k/mac/oss.c~m68k-replace-remaining-__function__-occurences
+++ a/arch/m68k/mac/oss.c
@@ -190,7 +190,7 @@ void oss_irq_enable(int irq) {
 			break;
 #ifdef DEBUG_IRQUSE
 		default:
-			printk("%s unknown irq %d\n",__FUNCTION__, irq);
+			printk("%s unknown irq %d\n", __func__, irq);
 			break;
 #endif
 	}
@@ -230,7 +230,7 @@ void oss_irq_disable(int irq) {
 			break;
 #ifdef DEBUG_IRQUSE
 		default:
-			printk("%s unknown irq %d\n", __FUNCTION__, irq);
+			printk("%s unknown irq %d\n", __func__, irq);
 			break;
 #endif
 	}
diff -puN arch/m68k/q40/q40ints.c~m68k-replace-remaining-__function__-occurences arch/m68k/q40/q40ints.c
--- a/arch/m68k/q40/q40ints.c~m68k-replace-remaining-__function__-occurences
+++ a/arch/m68k/q40/q40ints.c
@@ -47,7 +47,7 @@ static int q40_irq_startup(unsigned int 
 	switch (irq) {
 	case 1: case 2: case 8: case 9:
 	case 11: case 12: case 13:
-		printk("%s: ISA IRQ %d not implemented by HW\n", __FUNCTION__, irq);
+		printk("%s: ISA IRQ %d not implemented by HW\n", __func__, irq);
 		return -ENXIO;
 	}
 	return 0;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
specialixc-fix-possible-double-unlock.patch
git-x86.patch
git-alsa.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
block-fix-shadowed-variable-warning-in-blk-mapc.patch
block-remove-extern-on-function-definition.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
m68k-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-introduce-kprobe_handle_fault-ia64-fix.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch

