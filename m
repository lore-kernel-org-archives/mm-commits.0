From: akpm@linux-foundation.org
Subject: + virtual_eisa_root_init-should-be-__init.patch added to -mm tree
Date: Wed, 07 Mar 2007 17:08:51 -0800
Message-ID: <200703080108.l2818poD015175@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43058 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965029AbXCHBI5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 20:08:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davej@codemonkey.org.uk


The patch titled
     virtual_eisa_root_init() should be __init
has been added to the -mm tree.  Its filename is
     virtual_eisa_root_init-should-be-__init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: virtual_eisa_root_init() should be __init
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: vmlinux - Section mismatch: reference to
.init.text:eisa_root_register from .text between 'virtual_eisa_root_init' (at
offset 0xc026b80f) and 'cpufreq_debug_disable_ratelimit'

Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/eisa/virtual_root.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/eisa/virtual_root.c~virtual_eisa_root_init-should-be-__init drivers/eisa/virtual_root.c
--- a/drivers/eisa/virtual_root.c~virtual_eisa_root_init-should-be-__init
+++ a/drivers/eisa/virtual_root.c
@@ -47,7 +47,7 @@ static void virtual_eisa_release (struct
 	/* nothing really to do here */
 }
 
-static int virtual_eisa_root_init (void)
+static int __init virtual_eisa_root_init (void)
 {
 	int r;
 	
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
ivtv-warning-fix.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-md-accel-fixup.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
virtual_eisa_root_init-should-be-__init.patch
