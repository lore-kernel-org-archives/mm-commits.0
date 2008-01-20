From: akpm@linux-foundation.org
Subject: + rcu-fix-section-mismatch.patch added to -mm tree
Date: Sat, 19 Jan 2008 17:00:34 -0800
Message-ID: <200801200100.m0K10Ex5028836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36424 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754792AbYATBBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 Jan 2008 20:01:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de


The patch titled
     rcu: fix section mismatch
has been added to the -mm tree.  Its filename is
     rcu-fix-section-mismatch.patch

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
Subject: rcu: fix section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

rcu_online_cpu() should be __cpuinit instead of __devinit.

WARNING: vmlinux.o(.text+0x4b6d5): Section mismatch: reference to .init.text: (between 'rcu_cpu_notify' and 'wakeme_after_rcu')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcupdate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/rcupdate.c~rcu-fix-section-mismatch kernel/rcupdate.c
--- a/kernel/rcupdate.c~rcu-fix-section-mismatch
+++ a/kernel/rcupdate.c
@@ -549,7 +549,7 @@ static void rcu_init_percpu_data(int cpu
 	rdp->blimit = blimit;
 }
 
-static void __devinit rcu_online_cpu(int cpu)
+static void __cpuinit rcu_online_cpu(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
 	struct rcu_data *bh_rdp = &per_cpu(rcu_bh_data, cpu);
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
