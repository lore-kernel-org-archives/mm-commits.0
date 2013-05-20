From: akpm@linux-foundation.org
Subject: + migrate-shutdown-reboot-to-boot-cpu-v11.patch added to -mm tree
Date: Mon, 20 May 2013 13:16:43 -0700
Message-ID: <519a84ab.QeDAxsi7IcbdGucK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946Ab3ETUQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 16:16:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holt@sgi.com

Subject: + migrate-shutdown-reboot-to-boot-cpu-v11.patch added to -mm tree
To: holt@sgi.com
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 13:16:43 -0700


The patch titled
     Subject: migrate-shutdown-reboot-to-boot-cpu-v11
has been added to the -mm tree.  Its filename is
     migrate-shutdown-reboot-to-boot-cpu-v11.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11.patch
migrate-shutdown-reboot-to-boot-cpu.patch
migrate-shutdown-reboot-to-boot-cpu-v11.patch
dump_stack-serialize-the-output-from-dump_stack.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch

