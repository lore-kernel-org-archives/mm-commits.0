From: akpm@linux-foundation.org
Subject: + kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:34:31 -0800
Message-ID: <200802230735.m1N7ZK4Y018354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764662AbYBWIF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:05:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, benh@kernel.crashing.org, davem@davemloft.net, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, mhiramat@redhat.com, mingo@elte.hu, paulus@samba.org, prasanna@in.ibm.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     kprobes: remove preempt_enable/disable from kprobe_handle_fault()
has been added to the -mm tree.  Its filename is
     kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch

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
Subject: kprobes: remove preempt_enable/disable from kprobe_handle_fault()
From: Harvey Harrison <harvey.harrison@gmail.com>

Remove the preempt_disable/enable pair around kprobe_running which was
originally added to avoid the assertion from smp_processor_id which would be
hit an assertion if preemption was enabled.

Kprobes can not be running if we are preemptible, so test explicitly for
preemption and bail out before hitting kprobe_running().

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff -puN include/linux/kprobes.h~kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault
+++ a/include/linux/kprobes.h
@@ -216,19 +216,16 @@ static inline struct kprobe *kprobe_runn
 	return (__get_cpu_var(current_kprobe));
 }
 
+/*
+ * If it is a kprobe pagefault we can not be preemptible so return before
+ * calling kprobe_running() as it will assert on smp_processor_id if
+ * preemption is enabled.
+ */
 static inline int kprobe_handle_fault(struct pt_regs *regs, int trapnr)
 {
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, trapnr))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
+	if (!user_mode(regs) && !preemptible() && kprobe_running())
+		return kprobe_fault_handler(regs, trapnr);
+	return 0;
 }
 
 static inline void reset_current_kprobe(void)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
markers-fix-sparse-warnings-in-markersc.patch
acpi-sparse-fix-replace-macro-with-static-function.patch
bttv-struct-member-initialized-twice.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
lockd-fix-sparse-warning-in-svcsharec.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
