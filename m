From: akpm@linux-foundation.org
Subject: + parisc-replace-remaining-__function__-occurences.patch added to -mm tree
Date: Mon, 03 Mar 2008 13:30:37 -0800
Message-ID: <200803032130.m23LUb5m007533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbYCCVel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 16:34:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, grundler@parisc-linux.org, kyle@mcmartin.ca, willy@debian.org


The patch titled
     parisc: replace remaining __FUNCTION__ occurences
has been added to the -mm tree.  Its filename is
     parisc-replace-remaining-__function__-occurences.patch

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
Subject: parisc: replace remaining __FUNCTION__ occurences
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
@@ -256,7 +256,7 @@ KERN_CRIT "                     ||     |
 
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
mips-replace-remaining-__function__-occurences.patch
parisc-replace-remaining-__function__-occurences.patch

