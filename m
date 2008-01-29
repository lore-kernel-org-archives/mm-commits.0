From: akpm@linux-foundation.org
Subject: - hrtimer-fix-section-mismatch.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:47:24 -0800
Message-ID: <200801290147.m0T1lOuT027279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51880 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754617AbYA2BtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:49:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hrtimer: fix section mismatch
has been removed from the -mm tree.  Its filename was
     hrtimer-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
