From: akpm@linux-foundation.org
Subject: + rtc-add-rtc-rs5c313-driver-is-busted.patch added to -mm tree
Date: Sun, 18 Mar 2007 02:37:40 -0700
Message-ID: <200703180939.l2I9dbHD020537@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32835 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbXCRJjt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:39:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, iwamatsu@nigauri.org


The patch titled
     rtc-add-rtc-rs5c313-driver-is-busted
has been added to the -mm tree.  Its filename is
     rtc-add-rtc-rs5c313-driver-is-busted.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc-add-rtc-rs5c313-driver-is-busted
From: Andrew Morton <akpm@linux-foundation.org>

drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_read_reg':
drivers/rtc/rtc-rs5c313.c:186: warning: implicit declaration of function 'rs5c313_write_data'
drivers/rtc/rtc-rs5c313.c:187: warning: implicit declaration of function 'rs5c313_read_data'
drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_rtc_read_time':
drivers/rtc/rtc-rs5c313.c:208: error: 'RS5C313_CEENABLE' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c:208: error: (Each undeclared identifier is reported only once
drivers/rtc/rtc-rs5c313.c:208: error: for each function it appears in.)
drivers/rtc/rtc-rs5c313.c:217: error: 'RS5C313_CEDISABLE' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_rtc_set_time':
drivers/rtc/rtc-rs5c313.c:265: error: 'RS5C313_CEENABLE' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c:273: error: 'RS5C313_MISCOP' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c:274: error: 'RS5C313_CEDISABLE' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_check_xstp_bit':
drivers/rtc/rtc-rs5c313.c:315: error: 'RS5C313_CEENABLE' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c:324: error: 'RS5C313_MISCOP' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c:336: error: 'RS5C313_CEDISABLE' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_rtc_init':
drivers/rtc/rtc-rs5c313.c:390: warning: implicit declaration of function 'rs5c313_init_port'

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~rtc-add-rtc-rs5c313-driver-is-busted drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-rtc-rs5c313-driver-is-busted
+++ a/drivers/rtc/Kconfig
@@ -366,7 +366,7 @@ config RTC_DRV_BFIN
 
 config RTC_DRV_RS5C313
 	tristate "Ricoh RS5C313"
-	depends on RTC_CLASS
+	depends on RTC_CLASS && BROKEN
 	help
 	  If you say yes here you get support for the Ricoh RS5C313 RTC chips.
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
machzwd-warning-fix.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa.patch
git-drm.patch
git-drm-warning-fix.patch
git-dvb.patch
git-hid-fix.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lists-add-list-splice-tail.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
