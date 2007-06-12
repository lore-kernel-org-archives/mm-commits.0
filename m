From: akpm@linux-foundation.org
Subject: + allow-softlockup-to-be-runtime-disabled.patch added to -mm tree
Date: Mon, 11 Jun 2007 21:20:42 -0700
Message-ID: <200706120420.l5C4KgDe004112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbXFLEVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 00:21:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, mingo@elte.hu


The patch titled
     Allow softlockup to be runtime disabled
has been added to the -mm tree.  Its filename is
     allow-softlockup-to-be-runtime-disabled.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1245,6 +1245,8 @@ and is between 256 and 4096 characters. 
 
 	nosmp		[SMP] Tells an SMP kernel to act as a UP kernel.
 
+	nosoftlockup	[KNL] Disable the soft-lockup detector.
+
 	nosync		[HW,M68K] Disables sync negotiation for all devices.
 
 	notsc		[BUGS=X86-32] Disable Time Stamp Counter
diff -puN init/main.c~allow-softlockup-to-be-runtime-disabled init/main.c
--- a/init/main.c~allow-softlockup-to-be-runtime-disabled
+++ a/init/main.c
@@ -709,6 +709,15 @@ static void __init do_basic_setup(void)
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
@@ -718,7 +727,8 @@ static void __init do_pre_smp_initcalls(
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

document-acked-by.patch
git-alsa.patch
git-agpgart.patch
git-cpufreq.patch
i386-remove-support-for-the-rise-cpu.patch
fix-up-codingstyle-in-isofs.patch
undeprecate-raw-driver.patch
fix-typo-in-prefetchh.patch
allow-softlockup-to-be-runtime-disabled.patch
