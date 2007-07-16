From: akpm@linux-foundation.org
Subject: - allow-softlockup-to-be-runtime-disabled.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:51 -0700
Message-ID: <200707162056.l6GKup1d002126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47868 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762594AbXGPVOo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:14:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Allow softlockup to be runtime disabled
has been removed from the -mm tree.  Its filename was
     allow-softlockup-to-be-runtime-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Allow softlockup to be runtime disabled
From: Dave Jones <davej@redhat.com>

It's useful sometimes to disable the softlockup checker at boottime. 
Especially if it triggers during a distro install.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 ++
 init/main.c                         |   12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~allow-softlockup-to-be-runtime-disabled Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~allow-softlockup-to-be-runtime-disabled
+++ a/Documentation/kernel-parameters.txt
@@ -1181,6 +1181,8 @@ and is between 256 and 4096 characters. 
 
 	nosmp		[SMP] Tells an SMP kernel to act as a UP kernel.
 
+	nosoftlockup	[KNL] Disable the soft-lockup detector.
+
 	nosync		[HW,M68K] Disables sync negotiation for all devices.
 
 	notsc		[BUGS=IA-32] Disable Time Stamp Counter
diff -puN init/main.c~allow-softlockup-to-be-runtime-disabled init/main.c
--- a/init/main.c~allow-softlockup-to-be-runtime-disabled
+++ a/init/main.c
@@ -728,6 +728,15 @@ static void __init do_basic_setup(void)
 	do_initcalls();
 }
 
+static int __initdata nosoftlockup;
+
+static int __init nosoftlockup_setup(char *str)
+{
+	nosoftlockup = 1;
+	return 1;
+}
+__setup("nosoftlockup", nosoftlockup_setup);
+
 static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
@@ -737,7 +746,8 @@ static void __init do_pre_smp_initcalls(
 	migration_init();
 #endif
 	spawn_ksoftirqd();
-	spawn_softlockup_task();
+	if (!nosoftlockup)
+		spawn_softlockup_task();
 }
 
 static void run_init_process(char *init_filename)
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
fix-empty-macros-in-acpi.patch
git-alsa.patch
i386-remove-support-for-the-rise-cpu.patch
slow-down-printk-during-boot.patch
