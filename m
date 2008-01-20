From: akpm@linux-foundation.org
Subject: + hrtimer-fix-section-mismatch.patch added to -mm tree
Date: Sat, 19 Jan 2008 17:00:36 -0800
Message-ID: <200801200100.m0K10GBX028839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754273AbYATBB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 Jan 2008 20:01:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de


The patch titled
     hrtimer: fix section mismatch
has been added to the -mm tree.  Its filename is
     hrtimer-fix-section-mismatch.patch

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
Subject: hrtimer: fix section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch in hrtimer.c:

WARNING: vmlinux.o(.text+0x50c61): Section mismatch: reference to .init.text: (between 'hrtimer_cpu_notify' and 'down_read_trylock')

Noticed by Johannes Berg and confirmed by Sam Ravnborg.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/hrtimer.c~hrtimer-fix-section-mismatch kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimer-fix-section-mismatch
+++ a/kernel/hrtimer.c
@@ -1378,7 +1378,7 @@ sys_nanosleep(struct timespec __user *rq
 /*
  * Functions related to boot-time initialization:
  */
-static void __devinit init_hrtimers_cpu(int cpu)
+static void __cpuinit init_hrtimers_cpu(int cpu)
 {
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
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
