From: akpm@linux-foundation.org
Subject: - timer-fix-section-mismatch.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:47:27 -0800
Message-ID: <200801290147.m0T1lRno027282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbYA2Bs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:48:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timer: fix section mismatch
has been removed from the -mm tree.  Its filename was
     timer-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timer: fix section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

The caller is __cpuinit.
Also, this code block and its caller are inside #ifdef CONFIG_HOTPLUG_CPU
blocks, so this code should reflect that config symbol's usage.

WARNING: vmlinux.o(.text+0x4252f): Section mismatch: reference to .init.text: (between 'timer_cpu_notify' and 'msleep')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/timer.c~timer-fix-section-mismatch kernel/timer.c
--- a/kernel/timer.c~timer-fix-section-mismatch
+++ a/kernel/timer.c
@@ -1289,7 +1289,7 @@ static void migrate_timer_list(tvec_base
 	}
 }
 
-static void __devinit migrate_timers(int cpu)
+static void __cpuinit migrate_timers(int cpu)
 {
 	tvec_base_t *old_base;
 	tvec_base_t *new_base;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
profile-likely-unlikely-macros.patch
