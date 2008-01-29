From: akpm@linux-foundation.org
Subject: - rcu-fix-section-mismatch.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:47:46 -0800
Message-ID: <200801290147.m0T1lkwB027303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbYA2Bso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:48:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     rcu: fix section mismatch
has been removed from the -mm tree.  Its filename was
     rcu-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu: fix section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

rcu_online_cpu() should be __cpuinit instead of __devinit.

WARNING: vmlinux.o(.text+0x4b6d5): Section mismatch: reference to .init.text: (between 'rcu_cpu_notify' and 'wakeme_after_rcu')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
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
