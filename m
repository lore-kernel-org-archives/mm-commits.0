From: akpm@linux-foundation.org
Subject: - isdn-hysdn_procconfc-build-fix.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:27 -0700
Message-ID: <200805021942.m42JgR48011193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932190AbYEBTms (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:42:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, den@openvz.org, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn: hysdn_procconf.c build fix
has been removed from the -mm tree.  Its filename was
     isdn-hysdn_procconfc-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: hysdn_procconf.c build fix
From: Ingo Molnar <mingo@elte.hu>

x86.git randconfig testing found the following build error in latest
-git:

  CC [M]  drivers/isdn/hysdn/hysdn_procconf.o
  CC [M]  drivers/isdn/hysdn/hysdn_init.o
  drivers/isdn/hysdn/hysdn_procconf.c: In function 'hysdn_procconf_init':
  drivers/isdn/hysdn/hysdn_procconf.c:408: error: too few arguments to function 'proc_create'

with the following config:

  http://redhat.com/~mingo/misc/config-Wed_Apr_30_15_12_48_CEST_2008.bad

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: "Denis V. Lunev" <den@openvz.org>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hysdn/hysdn_procconf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/isdn/hysdn/hysdn_procconf.c~isdn-hysdn_procconfc-build-fix drivers/isdn/hysdn/hysdn_procconf.c
--- a/drivers/isdn/hysdn/hysdn_procconf.c~isdn-hysdn_procconfc-build-fix
+++ a/drivers/isdn/hysdn/hysdn_procconf.c
@@ -405,7 +405,8 @@ hysdn_procconf_init(void)
 		sprintf(conf_name, "%s%d", PROC_CONF_BASENAME, card->myid);
 		if ((card->procconf = (void *) proc_create(conf_name,
 						S_IFREG | S_IRUGO | S_IWUSR,
-						hysdn_proc_entry)) != NULL) {
+						hysdn_proc_entry,
+						&conf_fops)) != NULL) {
 			hysdn_proclog_init(card);	/* init the log file entry */
 		}
 		card = card->next;	/* next entry */
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
acpi-acpi_numa_init-build-fix.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
git-x86-fixup.patch
x86_64-restore-mask_bits-in-msi-shutdown.patch
arch-x86-video-fbdevc-add-module_license.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
git-kvm.patch
git-sched.patch
mutex-debug-check-mutex-magic-before-owner.patch
show_schedstat-fix-memleak.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch
rcu-add-call_rcu_sched.patch
rcu-add-memory-barriers-and-comments-to-rcu_check_callbacks.patch
rcu-add-call_rcu_sched-and-friends-to-rcutorture.patch
rcu-1q08-rcu-doc-update-add-call_rcu_sched.patch
aes-x86_64-asm-implementation-optimization.patch
pci-export-resource_wc-in-pci-sysfs.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
accounting-account-for-user-time-when-updating-memory-integrals.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch

