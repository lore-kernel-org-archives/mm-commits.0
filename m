From: akpm@linux-foundation.org
Subject: + parisc-replace-__get_cpu_var-uses-for-address-calculation.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:27:20 -0800
Message-ID: <53165348.+iogSEFMKZxpD0Zh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709AbaCDW1V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, jejb@parisc-linux.org, deller@gmx.de, cl@linux.com

Subject: + parisc-replace-__get_cpu_var-uses-for-address-calculation.patch added to -mm tree
To: cl@linux.com,deller@gmx.de,jejb@parisc-linux.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:20 -0800


The patch titled
     Subject: parisc: replace __get_cpu_var uses for address calculation
has been added to the -mm tree.  Its filename is
     parisc-replace-__get_cpu_var-uses-for-address-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parisc-replace-__get_cpu_var-uses-for-address-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parisc-replace-__get_cpu_var-uses-for-address-calculation.patch

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
Subject: parisc: replace __get_cpu_var uses for address calculation

Convert to the use of this_cpu_ptr().

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/lib/memcpy.c |    2 +-
 arch/parisc/mm/fault.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/parisc/lib/memcpy.c~parisc-replace-__get_cpu_var-uses-for-address-calculation arch/parisc/lib/memcpy.c
--- a/arch/parisc/lib/memcpy.c~parisc-replace-__get_cpu_var-uses-for-address-calculation
+++ a/arch/parisc/lib/memcpy.c
@@ -470,7 +470,7 @@ static unsigned long pa_memcpy(void *dst
 		return 0;
 
 	/* if a load or store fault occured we can get the faulty addr */
-	d = &__get_cpu_var(exception_data);
+	d = this_cpu_ptr(&exception_data);
 	fault_addr = d->fault_addr;
 
 	/* error in load or store? */
diff -puN arch/parisc/mm/fault.c~parisc-replace-__get_cpu_var-uses-for-address-calculation arch/parisc/mm/fault.c
--- a/arch/parisc/mm/fault.c~parisc-replace-__get_cpu_var-uses-for-address-calculation
+++ a/arch/parisc/mm/fault.c
@@ -151,7 +151,7 @@ int fixup_exception(struct pt_regs *regs
 	fix = search_exception_tables(regs->iaoq[0]);
 	if (fix) {
 		struct exception_data *d;
-		d = &__get_cpu_var(exception_data);
+		d = this_cpu_ptr(&exception_data);
 		d->fault_ip = regs->iaoq[0];
 		d->fault_space = regs->isr;
 		d->fault_addr = regs->ior;
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

