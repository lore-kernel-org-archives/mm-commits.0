From: akpm@linux-foundation.org
Subject: + drivers-cpuidle-make-code-static.patch added to -mm tree
Date: Mon, 05 Mar 2007 19:47:17 -0800
Message-ID: <200703060347.l263lHKo011007@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49350 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933908AbXCFDui (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 22:50:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, abelay@novell.com, lenb@kernel.org, shaohua.li@intel.com, venkatesh.pallipadi@intel.com


The patch titled
     drivers/cpuidle/: make code static
has been added to the -mm tree.  Its filename is
     drivers-cpuidle-make-code-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/cpuidle/: make code static
From: Adrian Bunk <bunk@stusta.de>

This patch makes the following needlessly global code static:
- driver.c: __cpuidle_find_driver()
- governor.c: __cpuidle_find_governor()
- ladder.c: struct ladder_governor

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Len Brown <lenb@kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Adam Belay <abelay@novell.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.h          |    2 --
 drivers/cpuidle/driver.c           |    2 +-
 drivers/cpuidle/governor.c         |    2 +-
 drivers/cpuidle/governors/ladder.c |    2 +-
 4 files changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/cpuidle/cpuidle.h~drivers-cpuidle-make-code-static drivers/cpuidle/cpuidle.h
--- a/drivers/cpuidle/cpuidle.h~drivers-cpuidle-make-code-static
+++ a/drivers/cpuidle/cpuidle.h
@@ -23,13 +23,11 @@ extern void cpuidle_rescan_device(struct
 /* drivers */
 extern int cpuidle_attach_driver(struct cpuidle_device *dev);
 extern void cpuidle_detach_driver(struct cpuidle_device *dev);
-extern struct cpuidle_driver * __cpuidle_find_driver(const char *str);
 extern int cpuidle_switch_driver(struct cpuidle_driver *drv);
 
 /* governors */
 extern int cpuidle_attach_governor(struct cpuidle_device *dev);
 extern void cpuidle_detach_governor(struct cpuidle_device *dev);
-extern struct cpuidle_governor * __cpuidle_find_governor(const char *str);
 extern int cpuidle_switch_governor(struct cpuidle_governor *gov);
 
 /* sysfs */
diff -puN drivers/cpuidle/driver.c~drivers-cpuidle-make-code-static drivers/cpuidle/driver.c
--- a/drivers/cpuidle/driver.c~drivers-cpuidle-make-code-static
+++ a/drivers/cpuidle/driver.c
@@ -73,7 +73,7 @@ void cpuidle_detach_driver(struct cpuidl
  *
  * Must be called with cpuidle_lock aquired.
  */
-struct cpuidle_driver * __cpuidle_find_driver(const char *str)
+static struct cpuidle_driver * __cpuidle_find_driver(const char *str)
 {
 	struct cpuidle_driver *drv;
 
diff -puN drivers/cpuidle/governor.c~drivers-cpuidle-make-code-static drivers/cpuidle/governor.c
--- a/drivers/cpuidle/governor.c~drivers-cpuidle-make-code-static
+++ a/drivers/cpuidle/governor.c
@@ -72,7 +72,7 @@ void cpuidle_detach_governor(struct cpui
  *
  * Must be called with cpuidle_lock aquired.
  */
-struct cpuidle_governor * __cpuidle_find_governor(const char *str)
+static struct cpuidle_governor * __cpuidle_find_governor(const char *str)
 {
 	struct cpuidle_governor *gov;
 
diff -puN drivers/cpuidle/governors/ladder.c~drivers-cpuidle-make-code-static drivers/cpuidle/governors/ladder.c
--- a/drivers/cpuidle/governors/ladder.c~drivers-cpuidle-make-code-static
+++ a/drivers/cpuidle/governors/ladder.c
@@ -199,7 +199,7 @@ static void ladder_exit_device(struct cp
 	kfree(dev->governor_data);
 }
 
-struct cpuidle_governor ladder_governor = {
+static struct cpuidle_governor ladder_governor = {
 	.name =		"ladder",
 	.init =		ladder_init_device,
 	.exit =		ladder_exit_device,
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
remove-arch-i386-kernel-tscccustom_sched_clock.patch
drivers-cpuidle-make-code-static.patch
git-drm.patch
make-drivers-char-drm-drm_vmcdrm_io_prot-static.patch
git-dvb.patch
saa7134-fix-modules=n-compilation.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
drivers-net-vioc-possible-cleanups.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
lguest-kconfig-and-headers-fix.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
