From: akpm@linux-foundation.org
Subject: + drivers-gpio-ml_ioh_gpioc-needs-slabh.patch added to -mm tree
Date: Tue, 24 May 2011 16:03:44 -0700
Message-ID: <201105242340.p4ONeReN023155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016Ab1EXXka (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 19:40:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, grant.likely@secretlab.ca


The patch titled
     drivers/gpio/ml_ioh_gpio.c needs slab.h
has been added to the -mm tree.  Its filename is
     drivers-gpio-ml_ioh_gpioc-needs-slabh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpio/ml_ioh_gpio.c needs slab.h
From: Andrew Morton <akpm@linux-foundation.org>

alpha allmodconfig:

drivers/gpio/ml_ioh_gpio.c: In function 'ioh_gpio_probe':
drivers/gpio/ml_ioh_gpio.c:205: error: implicit declaration of function 'kzalloc'
drivers/gpio/ml_ioh_gpio.c:205: warning: assignment makes pointer from integer without a cast

also fix this:

drivers/gpio/ml_ioh_gpio.c:145: warning: 'ioh_gpio_save_reg_conf' defined but not used
drivers/gpio/ml_ioh_gpio.c:154: warning: 'ioh_gpio_restore_reg_conf' defined but not used

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/ml_ioh_gpio.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/gpio/ml_ioh_gpio.c~drivers-gpio-ml_ioh_gpioc-needs-slabh drivers/gpio/ml_ioh_gpio.c
--- a/drivers/gpio/ml_ioh_gpio.c~drivers-gpio-ml_ioh_gpioc-needs-slabh
+++ a/drivers/gpio/ml_ioh_gpio.c
@@ -15,6 +15,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
  */
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/gpio.h>
 
@@ -138,6 +139,7 @@ static int ioh_gpio_direction_input(stru
 	return 0;
 }
 
+#ifdef CONFIG_PM
 /*
  * Save register configuration and disable interrupts.
  */
@@ -157,6 +159,7 @@ static void ioh_gpio_restore_reg_conf(st
 	/* to store contents of PM register */
 	iowrite32(chip->ioh_gpio_reg.pm_reg, &chip->reg->regs[chip->ch].pm);
 }
+#endif
 
 static void ioh_gpio_setup(struct ioh_gpio *chip, int num_port)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-mmu_gather-rework-fix.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
nommu-add-page-alignment-to-mmap-checkpatch-fixes.patch
alpha-hook-up-gpiolib-support-fix.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
bitmap-irq-add-smp_affinity_list-interface-to-proc-irq-fix.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-gpio-vx855_gpioc-needs-slabh.patch
drivers-gpio-ml_ioh_gpioc-needs-slabh.patch

