From: akpm@linux-foundation.org
Subject: [to-be-updated] uv-replace-__get_cpu_var.patch removed from -mm
 tree
Date: Wed, 05 Mar 2014 11:28:03 -0800
Message-ID: <53177ac3.ct/IBF8Ml8GPePHA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaCET2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2014 14:28:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, travis@sgi.com, tj@kernel.org, sivanich@sgi.com, hedi@sgi.com, cl@linux.com

Subject: [to-be-updated] uv-replace-__get_cpu_var.patch removed from -mm tree
To: cl@linux.com,hedi@sgi.com,sivanich@sgi.com,tj@kernel.org,travis@sgi.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 05 Mar 2014 11:28:03 -0800


The patch titled
     Subject: uv: replace __get_cpu_var
has been removed from the -mm tree.  Its filename was
     uv-replace-__get_cpu_var.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: uv: replace __get_cpu_var

Use __this_cpu_read instead.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Hedi Berriche <hedi@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uv/uv_hub.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/include/asm/uv/uv_hub.h~uv-replace-__get_cpu_var arch/x86/include/asm/uv/uv_hub.h
--- a/arch/x86/include/asm/uv/uv_hub.h~uv-replace-__get_cpu_var
+++ a/arch/x86/include/asm/uv/uv_hub.h
@@ -618,7 +618,7 @@ struct uv_cpu_nmi_s {
 };
 
 DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
-#define uv_cpu_nmi			(__get_cpu_var(__uv_cpu_nmi))
+#define uv_cpu_nmi			__this_cpu_read(_uv_cpu_nmi)
 #define uv_hub_nmi			(uv_cpu_nmi.hub)
 #define uv_cpu_nmi_per(cpu)		(per_cpu(__uv_cpu_nmi, cpu))
 #define uv_hub_nmi_per(cpu)		(uv_cpu_nmi_per(cpu).hub)
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

