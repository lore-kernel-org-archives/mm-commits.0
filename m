From: akpm@linux-foundation.org
Subject: - sh-replace-remaining-__function__-occurences.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:22:12 -0800
Message-ID: <200803062222.m26MMCTr020791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934123AbYCFWeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:34:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     sh: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     sh-replace-remaining-__function__-occurences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sh: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/boards/renesas/x3proto/ilsel.c |    2 +-
 arch/sh/boards/superh/microdev/io.c    |    2 +-
 arch/sh/kernel/cpu/sh4/sq.c            |    4 ++--
 arch/sh/kernel/cpu/sh5/unwind.c        |    2 +-
 arch/sh/kernel/timers/timer-cmt.c      |    2 +-
 arch/sh/kernel/timers/timer-mtu2.c     |    2 +-
 arch/sh/kernel/topology.c              |    2 +-
 arch/sh/kernel/traps_64.c              |    2 +-
 arch/sh/lib64/c-checksum.c             |    2 +-
 arch/sh/mm/init.c                      |    2 +-
 arch/sh/mm/ioremap_32.c                |    2 +-
 arch/sh/mm/ioremap_64.c                |    4 ++--
 arch/sh/mm/tlbflush_64.c               |    6 +++---
 13 files changed, 17 insertions(+), 17 deletions(-)

diff -puN arch/sh/boards/renesas/x3proto/ilsel.c~sh-replace-remaining-__function__-occurences arch/sh/boards/renesas/x3proto/ilsel.c
--- a/arch/sh/boards/renesas/x3proto/ilsel.c~sh-replace-remaining-__function__-occurences
+++ a/arch/sh/boards/renesas/x3proto/ilsel.c
@@ -68,7 +68,7 @@ static void __ilsel_enable(ilsel_source_
 	shift = mk_ilsel_shift(bit);
 
 	pr_debug("%s: bit#%d: addr - 0x%08lx (shift %d, set %d)\n",
-		 __FUNCTION__, bit, addr, shift, set);
+		 __func__, bit, addr, shift, set);
 
 	tmp = ctrl_inw(addr);
 	tmp &= ~(0xf << shift);
diff -puN arch/sh/boards/superh/microdev/io.c~sh-replace-remaining-__function__-occurences arch/sh/boards/superh/microdev/io.c
--- a/arch/sh/boards/superh/microdev/io.c~sh-replace-remaining-__function__-occurences
+++ a/arch/sh/boards/superh/microdev/io.c
@@ -127,7 +127,7 @@ static unsigned long microdev_isa_port2a
 			 *	safe default.
 			 */
 		printk("Warning: unexpected port in %s( offset = 0x%lx )\n",
-		       __FUNCTION__, offset);
+		       __func__, offset);
 		result = PVR;
 	}
 
diff -puN arch/sh/kernel/cpu/sh4/sq.c~sh-replace-remaining-__function__-occurences arch/sh/kernel/cpu/sh4/sq.c
--- a/arch/sh/kernel/cpu/sh4/sq.c~sh-replace-remaining-__function__-occurences
+++ a/arch/sh/kernel/cpu/sh4/sq.c
@@ -216,7 +216,7 @@ void sq_unmap(unsigned long vaddr)
 
 	if (unlikely(!map)) {
 		printk("%s: bad store queue address 0x%08lx\n",
-		       __FUNCTION__, vaddr);
+		       __func__, vaddr);
 		return;
 	}
 
@@ -233,7 +233,7 @@ void sq_unmap(unsigned long vaddr)
 		vma = remove_vm_area((void *)(map->sq_addr & PAGE_MASK));
 		if (!vma) {
 			printk(KERN_ERR "%s: bad address 0x%08lx\n",
-			       __FUNCTION__, map->sq_addr);
+			       __func__, map->sq_addr);
 			return;
 		}
 	}
diff -puN arch/sh/kernel/cpu/sh5/unwind.c~sh-replace-remaining-__function__-occurences arch/sh/kernel/cpu/sh5/unwind.c
--- a/arch/sh/kernel/cpu/sh5/unwind.c~sh-replace-remaining-__function__-occurences
+++ a/arch/sh/kernel/cpu/sh5/unwind.c
@@ -149,7 +149,7 @@ static int lookup_prev_stack_frame(unsig
 			if (dest >= 63) {
 				printk(KERN_NOTICE "%s: Invalid dest reg %d "
 				       "specified in movi handler. Failed "
-				       "opcode was 0x%lx: ", __FUNCTION__,
+				       "opcode was 0x%lx: ", __func__,
 				       dest, op);
 
 				continue;
diff -puN arch/sh/kernel/timers/timer-cmt.c~sh-replace-remaining-__function__-occurences arch/sh/kernel/timers/timer-cmt.c
--- a/arch/sh/kernel/timers/timer-cmt.c~sh-replace-remaining-__function__-occurences
+++ a/arch/sh/kernel/timers/timer-cmt.c
@@ -77,7 +77,7 @@ static unsigned long cmt_timer_get_offse
 				count -= LATCH;
 			} else {
 				printk("%s (): hardware timer problem?\n",
-				       __FUNCTION__);
+				       __func__);
 			}
 		}
 	} else
diff -puN arch/sh/kernel/timers/timer-mtu2.c~sh-replace-remaining-__function__-occurences arch/sh/kernel/timers/timer-mtu2.c
--- a/arch/sh/kernel/timers/timer-mtu2.c~sh-replace-remaining-__function__-occurences
+++ a/arch/sh/kernel/timers/timer-mtu2.c
@@ -76,7 +76,7 @@ static unsigned long mtu2_timer_get_offs
 				count -= LATCH;
 			} else {
 				printk("%s (): hardware timer problem?\n",
-				       __FUNCTION__);
+				       __func__);
 			}
 		}
 	} else
diff -puN arch/sh/kernel/topology.c~sh-replace-remaining-__function__-occurences arch/sh/kernel/topology.c
--- a/arch/sh/kernel/topology.c~sh-replace-remaining-__function__-occurences
+++ a/arch/sh/kernel/topology.c
@@ -29,7 +29,7 @@ static int __init topology_init(void)
 		ret = register_cpu(&per_cpu(cpu_devices, i), i);
 		if (unlikely(ret))
 			printk(KERN_WARNING "%s: register_cpu %d failed (%d)\n",
-			       __FUNCTION__, i, ret);
+			       __func__, i, ret);
 	}
 
 #if defined(CONFIG_NUMA) && !defined(CONFIG_SMP)
diff -puN arch/sh/kernel/traps_64.c~sh-replace-remaining-__function__-occurences arch/sh/kernel/traps_64.c
--- a/arch/sh/kernel/traps_64.c~sh-replace-remaining-__function__-occurences
+++ a/arch/sh/kernel/traps_64.c
@@ -238,7 +238,7 @@ DO_ERROR(12, SIGILL,  "reserved instruct
 /* Called with interrupts disabled */
 asmlinkage void do_exception_error(unsigned long ex, struct pt_regs *regs)
 {
-	show_excp_regs(__FUNCTION__, -1, -1, regs);
+	show_excp_regs(__func__, -1, -1, regs);
 	die_if_kernel("exception", regs, ex);
 }
 
diff -puN arch/sh/lib64/c-checksum.c~sh-replace-remaining-__function__-occurences arch/sh/lib64/c-checksum.c
--- a/arch/sh/lib64/c-checksum.c~sh-replace-remaining-__function__-occurences
+++ a/arch/sh/lib64/c-checksum.c
@@ -207,7 +207,7 @@ __wsum csum_tcpudp_nofold(__be32 saddr, 
 	result = (result & 0xffffffff) + (result >> 32);
 
 	pr_debug("%s saddr %x daddr %x len %x proto %x sum %x result %08Lx\n",
-		__FUNCTION__, saddr, daddr, len, proto, sum, result);
+		__func__, saddr, daddr, len, proto, sum, result);
 
 	return (__wsum)result;
 }
diff -puN arch/sh/mm/init.c~sh-replace-remaining-__function__-occurences arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~sh-replace-remaining-__function__-occurences
+++ a/arch/sh/mm/init.c
@@ -328,7 +328,7 @@ int arch_add_memory(int nid, u64 start, 
 	/* We only have ZONE_NORMAL, so this is easy.. */
 	ret = __add_pages(pgdat->node_zones + ZONE_NORMAL, start_pfn, nr_pages);
 	if (unlikely(ret))
-		printk("%s: Failed, __add_pages() == %d\n", __FUNCTION__, ret);
+		printk("%s: Failed, __add_pages() == %d\n", __func__, ret);
 
 	return ret;
 }
diff -puN arch/sh/mm/ioremap_32.c~sh-replace-remaining-__function__-occurences arch/sh/mm/ioremap_32.c
--- a/arch/sh/mm/ioremap_32.c~sh-replace-remaining-__function__-occurences
+++ a/arch/sh/mm/ioremap_32.c
@@ -141,7 +141,7 @@ void __iounmap(void __iomem *addr)
 
 	p = remove_vm_area((void *)(vaddr & PAGE_MASK));
 	if (!p) {
-		printk(KERN_ERR "%s: bad address %p\n", __FUNCTION__, addr);
+		printk(KERN_ERR "%s: bad address %p\n", __func__, addr);
 		return;
 	}
 
diff -puN arch/sh/mm/ioremap_64.c~sh-replace-remaining-__function__-occurences arch/sh/mm/ioremap_64.c
--- a/arch/sh/mm/ioremap_64.c~sh-replace-remaining-__function__-occurences
+++ a/arch/sh/mm/ioremap_64.c
@@ -178,7 +178,7 @@ static unsigned long shmedia_alloc_io(un
         } else {
                 if (!printed_full) {
                         printk("%s: done with statics, switching to kmalloc\n",
-			       __FUNCTION__);
+			       __func__);
                         printed_full = 1;
                 }
                 tlen = strlen(name);
@@ -352,7 +352,7 @@ void onchip_unmap(unsigned long vaddr)
 	res = shmedia_find_resource(&shmedia_iomap, vaddr);
 	if (!res) {
 		printk(KERN_ERR "%s: Failed to free 0x%08lx\n",
-		       __FUNCTION__, vaddr);
+		       __func__, vaddr);
 		return;
 	}
 
diff -puN arch/sh/mm/tlbflush_64.c~sh-replace-remaining-__function__-occurences arch/sh/mm/tlbflush_64.c
--- a/arch/sh/mm/tlbflush_64.c~sh-replace-remaining-__function__-occurences
+++ a/arch/sh/mm/tlbflush_64.c
@@ -131,7 +131,7 @@ asmlinkage void do_page_fault(struct pt_
 #ifdef DEBUG_FAULT
 		print_task(tsk);
 		printk("%s:%d fault, address is 0x%08x PC %016Lx textaccess %d writeaccess %d\n",
-		       __FUNCTION__,__LINE__,
+		       __func__, __LINE__,
 		       address,regs->pc,textaccess,writeaccess);
 		show_regs(regs);
 #endif
@@ -145,7 +145,7 @@ asmlinkage void do_page_fault(struct pt_
 #ifdef DEBUG_FAULT
 		print_task(tsk);
 		printk("%s:%d fault, address is 0x%08x PC %016Lx textaccess %d writeaccess %d\n",
-		       __FUNCTION__,__LINE__,
+		       __func__, __LINE__,
 		       address,regs->pc,textaccess,writeaccess);
 		show_regs(regs);
 
@@ -157,7 +157,7 @@ asmlinkage void do_page_fault(struct pt_
 #ifdef DEBUG_FAULT
 		print_task(tsk);
 		printk("%s:%d fault, address is 0x%08x PC %016Lx textaccess %d writeaccess %d\n",
-		       __FUNCTION__,__LINE__,
+		       __func__, __LINE__,
 		       address,regs->pc,textaccess,writeaccess);
 		show_regs(regs);
 #endif
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
acpi-replace-remaining-__function__-occurrences.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
git-arm-master.patch
cifs-remove-global_extern-macro.patch
cifs-replace-remaining-__function__-occurrences.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
ieee1394-replace-remaining-__function__-occurrences.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
ata-replace-remaining-__function__-occurrences.patch
pata_amd-fix-sparse-warning.patch
git-mips.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
git-sh.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-stc-make-class-attributes-static.patch
scsi-osstc-make-class-attributes-static.patch
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
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
iop-admac-replace-remaining-__function__-occurrences.patch
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

