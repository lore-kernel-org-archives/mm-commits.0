From: akpm@linux-foundation.org
Subject: + softirq-convert-printks-to-pr_level.patch added to -mm tree
Date: Tue, 10 Dec 2013 15:54:26 -0800
Message-ID: <52a7a9b2.ymKJRGo2KjfDcDDz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3LJXy1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 18:54:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, fweisbec@gmail.com, joe@perches.com

Subject: + softirq-convert-printks-to-pr_level.patch added to -mm tree
To: joe@perches.com,fweisbec@gmail.com,mingo@elte.hu,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 15:54:26 -0800


The patch titled
     Subject: softirq: convert printks to pr_<level>
has been added to the -mm tree.  Its filename is
     softirq-convert-printks-to-pr_level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/softirq-convert-printks-to-pr_level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/softirq-convert-printks-to-pr_level.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: softirq: convert printks to pr_<level>

Use a more current logging style.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/softirq.c~softirq-convert-printks-to-pr_level kernel/softirq.c
--- a/kernel/softirq.c~softirq-convert-printks-to-pr_level
+++ a/kernel/softirq.c
@@ -8,6 +8,8 @@
  *	Rewritten. Old one was good in 2.2, but in 2.3 it was immoral. --ANK (990903)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/export.h>
 #include <linux/kernel_stat.h>
 #include <linux/interrupt.h>
@@ -258,7 +260,7 @@ restart:
 		h->action(h);
 		trace_softirq_exit(vec_nr);
 		if (unlikely(prev_count != preempt_count())) {
-			printk(KERN_ERR "huh, entered softirq %u %s %p with preempt_count %08x, exited with %08x?\n",
+			pr_err("huh, entered softirq %u %s %p with preempt_count %08x, exited with %08x?\n",
 			       vec_nr, softirq_to_name[vec_nr], h->action,
 			       prev_count, preempt_count());
 			preempt_count_set(prev_count);
@@ -562,7 +564,7 @@ EXPORT_SYMBOL(tasklet_init);
 void tasklet_kill(struct tasklet_struct *t)
 {
 	if (in_interrupt())
-		printk("Attempt to kill tasklet from interrupt\n");
+		pr_notice("Attempt to kill tasklet from interrupt\n");
 
 	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
 		do {
_

Patches currently in -mm which might be from joe@perches.com are

softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
lib-parserc-add-match_wildcard-function.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
vsprintf-add-%pad-extension-for-dma_addr_t-use.patch
get_maintainer-add-commit-author-information-to-rolestats.patch
test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch
checkpatch-more-comprehensive-split-strings-warning.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
linux-next.patch

