From: akpm@linux-foundation.org
Subject: + um-remove-dead-code.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:55:26 -0700
Message-ID: <201107222255.p6MMtQix020055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421Ab1GVWzd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:55:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at


The patch titled
     um: remove dead code
has been added to the -mm tree.  Its filename is
     um-remove-dead-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: remove dead code
From: Richard Weinberger <richard@nod.at>

GCC 4.6's -Wunused-but-set-variable found some dead code.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_kern.c |    3 +--
 arch/um/drivers/line.c      |    3 +--
 arch/um/kernel/reboot.c     |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff -puN arch/um/drivers/chan_kern.c~um-remove-dead-code arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~um-remove-dead-code
+++ a/arch/um/drivers/chan_kern.c
@@ -543,11 +543,10 @@ int parse_chan_pair(char *str, struct li
 		    const struct chan_opts *opts, char **error_out)
 {
 	struct list_head *chans = &line->chan_list;
-	struct chan *new, *chan;
+	struct chan *new;
 	char *in, *out;
 
 	if (!list_empty(chans)) {
-		chan = list_entry(chans->next, struct chan, list);
 		free_chan(chans, 0);
 		INIT_LIST_HEAD(chans);
 	}
diff -puN arch/um/drivers/line.c~um-remove-dead-code arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~um-remove-dead-code
+++ a/arch/um/drivers/line.c
@@ -176,10 +176,9 @@ void line_flush_buffer(struct tty_struct
 {
 	struct line *line = tty->driver_data;
 	unsigned long flags;
-	int err;
 
 	spin_lock_irqsave(&line->lock, flags);
-	err = flush_buffer(line);
+	flush_buffer(line);
 	spin_unlock_irqrestore(&line->lock, flags);
 }
 
diff -puN arch/um/kernel/reboot.c~um-remove-dead-code arch/um/kernel/reboot.c
--- a/arch/um/kernel/reboot.c~um-remove-dead-code
+++ a/arch/um/kernel/reboot.c
@@ -20,9 +20,8 @@ static void kill_off_processes(void)
 		os_kill_ptraced_process(userspace_pid[0], 1);
 	else {
 		struct task_struct *p;
-		int pid, me;
+		int pid;
 
-		me = os_getpid();
 		for_each_process(p) {
 			if (p->mm == NULL)
 				continue;
_

Patches currently in -mm which might be from richard@nod.at are

linux-next.patch
um-clean-up-vm-flagsh.patch
um-exec-remove-redundant-set_fsuser_ds.patch
um-clean-up-delay-functions-v2.patch
um-fix-_fortify_source=2-support-for-kernel-modules.patch
um-add-netpoll-support.patch
um-reinstate-kernel-version-in-generated-config.patch
uml-drivers-net_userc-memory-leak-fix.patch
uml-cow_userc-warning-corrections.patch
uml-helperc-warning-corrections.patch
uml-drivers-slip_userc-memory-leak-fix.patch
uml-free-resources.patch
um-disable-scan_elf_aux-on-x86_64.patch
um-set-__have_arch_gate_area-for-i386.patch
um-set-__have_arch_gate_area-for-x86_64.patch
um-implement-a-x86_64-vdso.patch
um-ajdust-size-of-pid_buf.patch
um-remove-dead-code.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch
exec-do-not-call-request_module-twice-from-search_binary_handler.patch
exec-do-not-retry-load_binary-method-if-config_modules=n.patch
gcov-disable-constructors-for-uml.patch

