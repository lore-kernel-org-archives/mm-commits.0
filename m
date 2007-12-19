From: akpm@linux-foundation.org
Subject: + drivers-video-pm3fbc-section-fix.patch added to -mm tree
Date: Tue, 18 Dec 2007 16:40:21 -0800
Message-ID: <200712190040.lBJ0eMT8030156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110AbXLSAlG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 19:41:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, adaplas@gmail.com, krzysztof.h1@wp.pl


The patch titled
     drivers/video/pm3fb.c section fix
has been added to the -mm tree.  Its filename is
     drivers-video-pm3fbc-section-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/video/pm3fb.c section fix
From: Adrian Bunk <bunk@kernel.org>

WARNING: vmlinux.o(.text+0x46e456): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e45c): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e49b): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e4a0): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e4bc): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e4c2): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e5c1): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e5c7): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/pm3fb.c~drivers-video-pm3fbc-section-fix drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~drivers-video-pm3fbc-section-fix
+++ a/drivers/video/pm3fb.c
@@ -1227,7 +1227,7 @@ static struct fb_ops pm3fb_ops = {
 
 /* mmio register are already mapped when this function is called */
 /* the pm3fb_fix.smem_start is also set */
-static unsigned long pm3fb_size_memory(struct pm3_par *par)
+static unsigned long __devinit pm3fb_size_memory(struct pm3_par *par)
 {
 	unsigned long	memsize = 0;
 	unsigned long	tempBypass, i, temp1, temp2;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
drivers-cpufreq-cpufreq_statsc-section-fix.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-net.patch
git-netdev-all.patch
git-battery.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
fs-nfs-directc-remove-dead-code.patch
drivers-pci-msic-move-arch-hooks-to-the-top.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
scsi-qla2xxx-qla_osc-section-fix.patch
wireless-ipw2200c-add-__devinitexit-annotations.patch
git-x86.patch
git-cryptodev.patch
git-xtensa.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
xen-fiddle_vdso-must-be-__init.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
drivers-video-pm3fbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
