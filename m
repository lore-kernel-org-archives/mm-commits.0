From: akpm@linux-foundation.org
Subject: + sched-fix-inc_rt_tasks-to-not-declare-variable-rq-if-its-not-needed.patch added to -mm tree
Date: Sat, 12 Jul 2008 22:34:29 -0700
Message-ID: <200807130534.m6D5YTpd006121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173AbYGMFfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 01:35:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, ghaskins@novell.com, mingo@elte.hu


The patch titled
     sched: fix inc_rt_tasks() to not declare variable 'rq' if it's not needed
has been added to the -mm tree.  Its filename is
     sched-fix-inc_rt_tasks-to-not-declare-variable-rq-if-its-not-needed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: fix inc_rt_tasks() to not declare variable 'rq' if it's not needed
From: David Howells <dhowells@redhat.com>

Fix inc_rt_tasks() to not declare variable 'rq' if it's not needed.  It is
declared if CONFIG_SMP or CONFIG_RT_GROUP_SCHED, but only used if
CONFIG_SMP.

This is a consequence of patch 1f11eb6a8bc92536d9e93ead48fa3ffbd1478571
plus patch 1100ac91b6af02d8639d518fad5b434b1bf44ed6.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked by: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched_rt.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sched_rt.c~sched-fix-inc_rt_tasks-to-not-declare-variable-rq-if-its-not-needed kernel/sched_rt.c
--- a/kernel/sched_rt.c~sched-fix-inc_rt_tasks-to-not-declare-variable-rq-if-its-not-needed
+++ a/kernel/sched_rt.c
@@ -505,7 +505,9 @@ void inc_rt_tasks(struct sched_rt_entity
 	rt_rq->rt_nr_running++;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	if (rt_se_prio(rt_se) < rt_rq->highest_prio) {
+#ifdef CONFIG_SMP
 		struct rq *rq = rq_of_rt_rq(rt_rq);
+#endif
 
 		rt_rq->highest_prio = rt_se_prio(rt_se);
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-fix-irqs_disabled-to-return-an-int-not-an-unsigned-long.patch
linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch
drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch
mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
sched-fix-inc_rt_tasks-to-not-declare-variable-rq-if-its-not-needed.patch
git-unionfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
x86-pci-fix-pci_subsys_init-to-have-a-return-value.patch
pm-fix-try_to_freeze_taskss-use-of-do_div.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch
tsacct-fix-bacct_add_tsks-use-of-do_div.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

