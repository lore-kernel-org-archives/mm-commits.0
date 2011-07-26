From: akpm@linux-foundation.org
Subject: [merged] um-remove-dead-code.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:55 -0700
Message-ID: <201107260753.p6Q7rwMC003299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958Ab1GZHyr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: remove dead code
has been removed from the -mm tree.  Its filename was
     um-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch
exec-do-not-call-request_module-twice-from-search_binary_handler.patch
exec-do-not-retry-load_binary-method-if-config_modules=n.patch
gcov-disable-constructors-for-uml.patch

