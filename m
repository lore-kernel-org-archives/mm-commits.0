From: akpm@linux-foundation.org
Subject: - kernel-replace-remaining-__function__-occurances.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:09 -0700
Message-ID: <200805010933.m419X9GC031115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758070AbYEAJdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kernel: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     kernel-replace-remaining-__function__-occurances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c       |    4 ++--
 kernel/workqueue.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/cpu.c~kernel-replace-remaining-__function__-occurances kernel/cpu.c
--- a/kernel/cpu.c~kernel-replace-remaining-__function__-occurances
+++ a/kernel/cpu.c
@@ -215,7 +215,7 @@ static int __ref _cpu_down(unsigned int 
 		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					  hcpu, nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
-				__FUNCTION__, cpu);
+				__func__, cpu);
 		err = -EINVAL;
 		goto out_release;
 	}
@@ -295,7 +295,7 @@ static int __cpuinit _cpu_up(unsigned in
 	if (ret == NOTIFY_BAD) {
 		nr_calls--;
 		printk("%s: attempt to bring up CPU %u failed\n",
-				__FUNCTION__, cpu);
+				__func__, cpu);
 		ret = -EINVAL;
 		goto out_notify;
 	}
diff -puN kernel/workqueue.c~kernel-replace-remaining-__function__-occurances kernel/workqueue.c
--- a/kernel/workqueue.c~kernel-replace-remaining-__function__-occurances
+++ a/kernel/workqueue.c
@@ -247,7 +247,7 @@ static void run_workqueue(struct cpu_wor
 	if (cwq->run_depth > 3) {
 		/* morton gets to eat his hat */
 		printk("%s: recursion depth exceeded: %d\n",
-			__FUNCTION__, cwq->run_depth);
+			__func__, cwq->run_depth);
 		dump_stack();
 	}
 	while (!list_empty(&cwq->worklist)) {
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-unbreak-misalignment-handling-changes.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
block-remove-remaining-__function__-occurances.patch

