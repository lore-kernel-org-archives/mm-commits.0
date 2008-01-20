From: akpm@linux-foundation.org
Subject: + timer-fix-section-mismatch.patch added to -mm tree
Date: Sat, 19 Jan 2008 17:00:38 -0800
Message-ID: <200801200100.m0K10I0m028842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55298 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754655AbYATBBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 Jan 2008 20:01:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de


The patch titled
     timer: fix section mismatch
has been added to the -mm tree.  Its filename is
     timer-fix-section-mismatch.patch

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

rcu-fix-section-mismatch.patch
hrtimer-fix-section-mismatch.patch
timer-fix-section-mismatch.patch
git-alsa.patch
git-dvb.patch
git-kbuild.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
git-unionfs.patch
hostap-section-mismatch-warning.patch
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
profile-likely-unlikely-macros.patch
