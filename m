From: akpm@linux-foundation.org
Subject: - remove-the-warn_on-in-arch-x86_64-kernel-acpi-sleepcinit_low_mapping.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:42:38 -0700
Message-ID: <200703290742.l2T7gcfd030315@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46423 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965981AbXC2Hrm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:47:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ak@suse.de, bunk@stusta.de, lenb@kernel.org, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Remove the WARN_ON() in arch/x86_64/kernel/acpi/sleep.c:init_low_mapping()
has been removed from the -mm tree.  Its filename was
     remove-the-warn_on-in-arch-x86_64-kernel-acpi-sleepcinit_low_mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove the WARN_ON() in arch/x86_64/kernel/acpi/sleep.c:init_low_mapping()
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Remove the WARN_ON() in arch/x86_64/kernel/acpi/sleep.c:init_low_mapping(),
which triggers every time during the suspend to disk in the platform mode, as
the potential problem it is related to doesn't seem to occur in practice.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/acpi/sleep.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/acpi/sleep.c~remove-the-warn_on-in-arch-x86_64-kernel-acpi-sleepcinit_low_mapping arch/x86_64/kernel/acpi/sleep.c
--- a/arch/x86_64/kernel/acpi/sleep.c~remove-the-warn_on-in-arch-x86_64-kernel-acpi-sleepcinit_low_mapping
+++ a/arch/x86_64/kernel/acpi/sleep.c
@@ -66,8 +66,10 @@ static void init_low_mapping(void)
 {
 	pgd_t *slot0 = pgd_offset(current->mm, 0UL);
 	low_ptr = *slot0;
+	/* FIXME: We're playing with the current task's page tables here, which
+	 * is potentially dangerous on SMP systems.
+	 */
 	set_pgd(slot0, *pgd_offset(current->mm, PAGE_OFFSET));
-	WARN_ON(num_online_cpus() != 1);
 	local_flush_tlb();
 }
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
fix-refrigerator-vs-thaw_process-race.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
shrink_slab-handle-bad-shrinkers.patch
