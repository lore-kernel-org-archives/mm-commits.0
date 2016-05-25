From: akpm@linux-foundation.org
Subject: + samples-kretprobe-fix-the-wrong-type.patch added to -mm tree
Date: Wed, 25 May 2016 15:38:08 -0700
Message-ID: <57462950.gu+dJjcGDyXjgS8J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbcEYWiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2016 18:38:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, ananth@linux.vnet.ibm.com, anil.s.keshavamurthy@intel.com, mhiramat@kernel.org, pmladek@suse.com, steve.capper@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: samples/kretprobe: fix the wrong type
has been added to the -mm tree.  Its filename is
     samples-kretprobe-fix-the-wrong-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/samples-kretprobe-fix-the-wrong-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/samples-kretprobe-fix-the-wrong-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Shijie <shijie.huang@arm.com>
Subject: samples/kretprobe: fix the wrong type

The regs_return_value() returns "unsigned long" or "long" value.  But the
retval is int type now, it may cause overflow, the log may becomes:
.................

    [ 2911.078869] do_brk returned -2003877888 and took 4620 ns to execute
    ................

This patch converts the retval to "unsigned long" type, and fixes the
overflow issue.

Link: http://lkml.kernel.org/r/1464143083-3877-4-git-send-email-shijie.huang@arm.com
Signed-off-by: Huang Shijie <shijie.huang@arm.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Ananth N Mavinakayanahalli <ananth@linux.vnet.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kprobes/kretprobe_example.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN samples/kprobes/kretprobe_example.c~samples-kretprobe-fix-the-wrong-type samples/kprobes/kretprobe_example.c
--- a/samples/kprobes/kretprobe_example.c~samples-kretprobe-fix-the-wrong-type
+++ a/samples/kprobes/kretprobe_example.c
@@ -55,14 +55,14 @@ static int entry_handler(struct kretprob
  */
 static int ret_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
-	int retval = regs_return_value(regs);
+	unsigned long retval = regs_return_value(regs);
 	struct my_data *data = (struct my_data *)ri->data;
 	s64 delta;
 	ktime_t now;
 
 	now = ktime_get();
 	delta = ktime_to_ns(ktime_sub(now, data->entry_stamp));
-	pr_info("%s returned %d and took %lld ns to execute\n",
+	pr_info("%s returned %lu and took %lld ns to execute\n",
 			func_name, retval, (long long)delta);
 	return 0;
 }
_

Patches currently in -mm which might be from shijie.huang@arm.com are

samples-kprobe-convert-the-printk-to-pr_info-pr_err.patch
samples-jprobe-convert-the-printk-to-pr_info-pr_err.patch
samples-kretprobe-convert-the-printk-to-pr_info-pr_err.patch
samples-kretprobe-fix-the-wrong-type.patch

