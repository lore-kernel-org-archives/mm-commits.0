From: akpm@linux-foundation.org
Subject: - mfd-sm501c-if-0-unused-functions.patch removed from -mm tree
Date: Mon, 23 Jun 2008 21:05:30 -0700
Message-ID: <200806240405.m5O45Uuh031896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756709AbYFXEF7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 00:05:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ben@simtec.co.uk, vince@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     mfd/sm501.c: #if 0 unused functions
has been removed from the -mm tree.  Its filename was
     mfd-sm501c-if-0-unused-functions.patch

This patch was dropped because Ben's SM501 patch series wrecked it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd/sm501.c: #if 0 unused functions
From: Adrian Bunk <bunk@kernel.org>

This patch #if 0's the following unused functions:
- sm501_find_clock()
- sm501_gpio_get()
- sm501_gpio_set()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: Vincent Sanders <vince@simtec.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c   |    5 +++++
 include/linux/sm501.h |   21 ---------------------
 2 files changed, 5 insertions(+), 21 deletions(-)

diff -puN drivers/mfd/sm501.c~mfd-sm501c-if-0-unused-functions drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~mfd-sm501c-if-0-unused-functions
+++ a/drivers/mfd/sm501.c
@@ -276,6 +276,8 @@ unsigned long sm501_modify_reg(struct de
 
 EXPORT_SYMBOL_GPL(sm501_modify_reg);
 
+#if 0
+
 unsigned long sm501_gpio_get(struct device *dev,
 			     unsigned long gpio)
 {
@@ -327,6 +329,7 @@ void sm501_gpio_set(struct device *dev,
 
 EXPORT_SYMBOL_GPL(sm501_gpio_set);
 
+#endif  /*  0  */
 
 /* sm501_unit_power
  *
@@ -658,6 +661,7 @@ unsigned long sm501_set_clock(struct dev
 
 EXPORT_SYMBOL_GPL(sm501_set_clock);
 
+#if 0
 /* sm501_find_clock
  *
  * finds the closest available frequency for a given clock
@@ -700,6 +704,7 @@ unsigned long sm501_find_clock(struct de
 }
 
 EXPORT_SYMBOL_GPL(sm501_find_clock);
+#endif  /*  0  */
 
 static struct sm501_device *to_sm_device(struct platform_device *pdev)
 {
diff -puN include/linux/sm501.h~mfd-sm501c-if-0-unused-functions include/linux/sm501.h
--- a/include/linux/sm501.h~mfd-sm501c-if-0-unused-functions
+++ a/include/linux/sm501.h
@@ -24,9 +24,6 @@ extern int sm501_unit_power(struct devic
 extern unsigned long sm501_set_clock(struct device *dev,
 				     int clksrc, unsigned long freq);
 
-extern unsigned long sm501_find_clock(struct device *dev,
-				      int clksrc, unsigned long req_freq);
-
 /* sm501_misc_control
  *
  * Modify the SM501's MISC_CONTROL register
@@ -46,24 +43,6 @@ extern unsigned long sm501_modify_reg(st
 				      unsigned long set,
 				      unsigned long clear);
 
-/* sm501_gpio_set
- *
- * set the state of the given GPIO line
-*/
-
-extern void sm501_gpio_set(struct device *dev,
-			   unsigned long gpio,
-			   unsigned int to,
-			   unsigned int dir);
-
-/* sm501_gpio_get
- *
- * get the state of the given GPIO line
-*/
-
-extern unsigned long sm501_gpio_get(struct device *dev,
-				    unsigned long gpio);
-
 
 /* Platform data definitions */
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
if-0-ses_match_host.patch
git-xtensa.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
remove-include-asm-h8300-keyboardh.patch
remove-include-linux-pm_legacyh.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-spawn_ksoftirqd-prototype.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
include-linux-kernelh-userspace-header-cleanup.patch
remove-the-oss-trident-driver.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
serial-8250_gscc-add-module_license.patch
mfd-sm501c-if-0-unused-functions.patch
video-sis-remove-compat-code.patch
minix-remove-no_truncate-code.patch
coda-remove-coda_fs_old_api.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
remove-is_tty.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
reiser4.patch

