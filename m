From: akpm@linux-foundation.org
Subject: [folded-merged] migrate-shutdown-reboot-to-boot-cpu-v11.patch
 removed from -mm tree
Date: Wed, 12 Jun 2013 13:57:02 -0700
Message-ID: <51b8e09e.IkgKjLBf0f38NBZr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab3FLU5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jun 2013 16:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holt@sgi.com

Subject: [folded-merged] migrate-shutdown-reboot-to-boot-cpu-v11.patch removed from -mm tree
To: holt@sgi.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 12 Jun 2013 13:57:02 -0700


The patch titled
     Subject: migrate-shutdown-reboot-to-boot-cpu-v11
has been removed from the -mm tree.  Its filename was
     migrate-shutdown-reboot-to-boot-cpu-v11.patch

This patch was dropped because it was folded into migrate-shutdown-reboot-to-boot-cpu.patch

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: migrate-shutdown-reboot-to-boot-cpu-v11

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/sys.c~migrate-shutdown-reboot-to-boot-cpu-v11 kernel/sys.c
--- a/kernel/sys.c~migrate-shutdown-reboot-to-boot-cpu-v11
+++ a/kernel/sys.c
@@ -370,19 +370,19 @@ EXPORT_SYMBOL(unregister_reboot_notifier
 static void migrate_to_reboot_cpu(void)
 {
 	/* The boot cpu is always logical cpu 0 */
-	int reboot_cpu = 0;
+	int cpu = 0;
 
 	cpu_hotplug_disable();
 
 	/* Make certain the cpu I'm about to reboot on is online */
-	if (!cpu_online(reboot_cpu))
-		reboot_cpu = cpumask_first(cpu_online_mask);
+	if (!cpu_online(cpu))
+		cpu = cpumask_first(cpu_online_mask);
 
 	/* Prevent races with other tasks migrating this task */
 	current->flags |= PF_NO_SETAFFINITY;
 
 	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu));
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 }
 
 /**
_

Patches currently in -mm which might be from holt@sgi.com are

cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch
migrate-shutdown-reboot-to-boot-cpu.patch
drivers-misc-sgi-gru-grufilec-fix-info-leak-in-gru_get_config_info.patch
dump_stack-serialize-the-output-from-dump_stack.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch
drivers-misc-sgi-gru-grufaultc-fix-a-sanity-test-in-gru_set_context_option.patch
reboot-remove-stable-friendly-pf_thread_bound-define.patch
reboot-move-shutdown-reboot-related-functions-to-kernel-rebootc.patch
reboot-checkpatchpl-the-new-kernel-rebootc-file.patch
reboot-x86-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs.patch
reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel.patch

