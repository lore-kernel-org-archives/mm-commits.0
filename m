From: akpm@linux-foundation.org
Subject: + arch-i386-xen-mmuc-must-include-linux-schedh.patch added to -mm tree
Date: Fri, 06 Jul 2007 10:45:49 -0700
Message-ID: <200707061745.l66HjnQp010532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755997AbXGFRqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 13:46:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, jeremy@goop.org


The patch titled
     arch/i386/xen/mmu.c must #include <linux/sched.h>
has been added to the -mm tree.  Its filename is
     arch-i386-xen-mmuc-must-include-linux-schedh.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: arch/i386/xen/mmu.c must #include <linux/sched.h>
=46rom: Adrian Bunk <bunk@stusta.de>

This patch fixes the following compile error:

<--  snip  -->

=2E..
  CC      arch/i386/xen/mmu.o
In file included from
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/i386/xen/mmu.c:46=
:
include2/asm/mmu_context.h: In function =E2=80=98switch_mm=E2=80=99:
include2/asm/mmu_context.h:45: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:50: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:53: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:58: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:58: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:59: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:66: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:70: error: dereferencing pointer to incomple=
te type
include2/asm/mmu_context.h:71: error: dereferencing pointer to incomple=
te type
=2E..
make[2]: *** [arch/i386/xen/mmu.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/mmu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/i386/xen/mmu.c~arch-i386-xen-mmuc-must-include-linux-sch=
edh arch/i386/xen/mmu.c
--- a/arch/i386/xen/mmu.c~arch-i386-xen-mmuc-must-include-linux-schedh
+++ a/arch/i386/xen/mmu.c
@@ -39,6 +39,7 @@
  * Jeremy Fitzhardinge <jeremy@xensource.com>, XenSource Inc, 2007
  */
 #include <linux/highmem.h>
+#include <linux/sched.h>
=20
 #include <asm/bug.h>
 #include <asm/pgtable.h>
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-ratin=
g-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
git-input.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-=
dma.patch
git-md-accel.patch
git-mmc.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
bonding-bond_mainc-make-2-functions-static.patch
net-make-struct-dccp_li_cachep-static.patch
git-battery.patch
git-selinux.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
remove-the-dead-cyberstormiii_scsi-option.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
fix-x86_64-mm-xen-xen-event-channels.patch
arch-i386-xen-mmuc-must-include-linux-schedh.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
xen-fix-x86-config-dependencies.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
xen-cant-support-numa-yet.patch
mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
handle-kernelcore=3D-generic-fix.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
mm-slubc-make-code-static.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
init-wait-for-asynchronously-scanned-block-devices-fix.patch
kernel-utf-8-handling-fix.patch
remove-sonypi_camera_command.patch
fs-namespacec-should-include-internalh.patch
proper-prototype-for-proc_nr_files.patch
fs-reiserfs-cleanups.patch
remove-mm-backing-devccongestion_wait_interruptible.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
remove-options-depending-on-oss_obsolete.patch
fbdev-move-arch-specific-bits-to-their-respective-fix-include-asm-m68k-=
fbh.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
intel-iommu-intel-iommu-driver-fix-duplicate-config_dmar-makefile-line.=
patch
mm-variable-length-argument-support-fix-2.patch
kernel-sched_fairc-make-code-static.patch
fs-proc-basec-make-a-struct-static.patch
mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped=
_list.patch
kernel-relayc-make-functions-static.patch
immediate-value-add-kconfig-menus.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
