From: akpm@linux-foundation.org
Subject: + git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch added to -mm tree
Date: Wed, 07 Mar 2007 14:32:29 -0800
Message-ID: <200703072232.l27MWT56011285@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34907 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992476AbXCGWcj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 17:32:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, drzeus@drzeus.cx, eric.rannaud@gmail.com


The patch titled
     git-mmc versus uevent-use-add_uevent_var-instead-of-open-coding-it
has been added to the -mm tree.  Its filename is
     git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-mmc versus uevent-use-add_uevent_var-instead-of-open-coding-it
From: Andrew Morton <akpm@linux-foundation.org>

Chase the mmc code around the tree.

Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: Eric Rannaud <eric.rannaud@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sysfs.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff -puN drivers/mmc/core/sysfs.c~git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it drivers/mmc/core/sysfs.c
--- a/drivers/mmc/core/sysfs.c~git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it
+++ a/drivers/mmc/core/sysfs.c
@@ -86,31 +86,26 @@ mmc_bus_uevent(struct device *dev, char 
 {
 	struct mmc_card *card = dev_to_mmc_card(dev);
 	char ccc[13];
-	int i = 0;
+	int retval = 0, i = 0, length = 0;
 
-#define add_env(fmt,val)						\
-	({								\
-		int len, ret = -ENOMEM;					\
-		if (i < num_envp) {					\
-			envp[i++] = buf;				\
-			len = snprintf(buf, buf_size, fmt, val) + 1;	\
-			buf_size -= len;				\
-			buf += len;					\
-			if (buf_size >= 0)				\
-				ret = 0;				\
-		}							\
-		ret;							\
-	})
+#define add_env(fmt,val) do {					\
+	retval = add_uevent_var(envp, num_envp, &i,		\
+				buf, buf_size, &length,		\
+				fmt, val);			\
+	if (retval)						\
+		return retval;					\
+} while (0);
 
 	for (i = 0; i < 12; i++)
 		ccc[i] = card->csd.cmdclass & (1 << i) ? '1' : '0';
 	ccc[12] = '\0';
 
-	i = 0;
 	add_env("MMC_CCC=%s", ccc);
 	add_env("MMC_MANFID=%06x", card->cid.manfid);
 	add_env("MMC_NAME=%s", mmc_card_name(card));
 	add_env("MMC_OEMID=%04x", card->cid.oemid);
+#undef add_env
+	envp[i] = NULL;
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
sony-laptop-fix-uninitialised-variable.patch
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
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless-fixup.patch
b44-warning-fixes.patch
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
