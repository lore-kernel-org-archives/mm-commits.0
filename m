From: akpm@linux-foundation.org
Subject: + irqchips-replace-__this_cpu_ptr-uses.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:27:36 -0800
Message-ID: <53165358.a8qSVmCgeZAxKn6D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762AbaCDW1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rmk+kernel@arm.linux.org.uk, nicolas.pitre@linaro.org, cl@linux.com

Subject: + irqchips-replace-__this_cpu_ptr-uses.patch added to -mm tree
To: cl@linux.com,nicolas.pitre@linaro.org,rmk+kernel@arm.linux.org.uk,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:36 -0800


The patch titled
     Subject: irqchips: replace __this_cpu_ptr uses
has been added to the -mm tree.  Its filename is
     irqchips-replace-__this_cpu_ptr-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/irqchips-replace-__this_cpu_ptr-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/irqchips-replace-__this_cpu_ptr-uses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: irqchips: replace __this_cpu_ptr uses

These are generally replaced with raw_cpu_ptr.  However, in
gic_get_percpu_base() we immediately dereference the pointer.  This is
equivalent to a raw_cpu_read.  So use that operation there.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/irqchip/irq-gic.c |   10 +++++-----
 kernel/irq/chip.c         |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/irqchip/irq-gic.c~irqchips-replace-__this_cpu_ptr-uses drivers/irqchip/irq-gic.c
--- a/drivers/irqchip/irq-gic.c~irqchips-replace-__this_cpu_ptr-uses
+++ a/drivers/irqchip/irq-gic.c
@@ -102,7 +102,7 @@ static struct gic_chip_data gic_data[MAX
 #ifdef CONFIG_GIC_NON_BANKED
 static void __iomem *gic_get_percpu_base(union gic_base *base)
 {
-	return *__this_cpu_ptr(base->percpu_base);
+	return raw_cpu_read(base->percpu_base);
 }
 
 static void __iomem *gic_get_common_base(union gic_base *base)
@@ -552,11 +552,11 @@ static void gic_cpu_save(unsigned int gi
 	if (!dist_base || !cpu_base)
 		return;
 
-	ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_enable);
+	ptr = raw_cpu_ptr(gic_data[gic_nr].saved_ppi_enable);
 	for (i = 0; i < DIV_ROUND_UP(32, 32); i++)
 		ptr[i] = readl_relaxed(dist_base + GIC_DIST_ENABLE_SET + i * 4);
 
-	ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_conf);
+	ptr = raw_cpu_ptr(gic_data[gic_nr].saved_ppi_conf);
 	for (i = 0; i < DIV_ROUND_UP(32, 16); i++)
 		ptr[i] = readl_relaxed(dist_base + GIC_DIST_CONFIG + i * 4);
 
@@ -578,11 +578,11 @@ static void gic_cpu_restore(unsigned int
 	if (!dist_base || !cpu_base)
 		return;
 
-	ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_enable);
+	ptr = raw_cpu_ptr(gic_data[gic_nr].saved_ppi_enable);
 	for (i = 0; i < DIV_ROUND_UP(32, 32); i++)
 		writel_relaxed(ptr[i], dist_base + GIC_DIST_ENABLE_SET + i * 4);
 
-	ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_conf);
+	ptr = raw_cpu_ptr(gic_data[gic_nr].saved_ppi_conf);
 	for (i = 0; i < DIV_ROUND_UP(32, 16); i++)
 		writel_relaxed(ptr[i], dist_base + GIC_DIST_CONFIG + i * 4);
 
diff -puN kernel/irq/chip.c~irqchips-replace-__this_cpu_ptr-uses kernel/irq/chip.c
--- a/kernel/irq/chip.c~irqchips-replace-__this_cpu_ptr-uses
+++ a/kernel/irq/chip.c
@@ -638,7 +638,7 @@ void handle_percpu_devid_irq(unsigned in
 {
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct irqaction *action = desc->action;
-	void *dev_id = __this_cpu_ptr(action->percpu_dev_id);
+	void *dev_id = raw_cpu_ptr(action->percpu_dev_id);
 	irqreturn_t res;
 
 	kstat_incr_irqs_this_cpu(irq, desc);
_

Patches currently in -mm which might be from cl@linux.com are

mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
percpu-add-raw_cpu_ops.patch
mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch
mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
tracing-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
percpu-replace-__get_cpu_var-with-this_cpu_ptr.patch
kernel-misc-replace-__get_cpu_var-uses.patch
drivers-char-random-replace-__get_cpu_var-uses.patch
drivers-cpuidle-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-oprofile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-leds-replace-__get_cpu_var-use-through-this_cpu_ptr.patch
drivers-clocksource-replace-__get_cpu_var-used-for-address-calculation.patch
parisc-replace-__get_cpu_var-uses-for-address-calculation.patch
metag-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch
tilegx-another-case-of-get_cpu_var.patch
time-replace-__get_cpu_var-uses.patch
scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch
tick-sched-fix-two-new-uses-of-__get_cpu_ptr.patch
block-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch
watchdog-replace-__raw_get_cpu_var-uses.patch
net-replace-get_cpu_var-through-this_cpu_ptr.patch
md-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
irqchips-replace-__this_cpu_ptr-uses.patch
x86-replace-__get_cpu_var-uses.patch
x86-change-__get_cpu_var-calls-introduced-in-314.patch
uv-replace-__get_cpu_var.patch
arm-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch
mips-replace-__get_cpu_var-uses.patch
s390-rename-__this_cpu_ptr-to-raw_cpu_ptr.patch
s390-replace-__get_cpu_var-uses.patch
s390-handle-new-__get_cpu_var-calls-added-in-314.patch
ia64-replace-__get_cpu_var-uses.patch
powerpc-replace-__get_cpu_var-uses.patch
powerpc-handle-new-__get_cpu_var-calls-in-314.patch
sparc-replace-__get_cpu_var-uses.patch
tile-replace-__get_cpu_var-uses.patch
blackfin-replace-__get_cpu_var-uses.patch
avr32-replace-__get_cpu_var-with-__this_cpu_write.patch
alpha-replace-__get_cpu_var.patch
sh-replace-__get_cpu_var-uses.patch

