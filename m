From: akpm@linux-foundation.org
Subject: [patch 09/18] samples/kretprobe: fix the wrong type
Date: Wed, 03 Aug 2016 13:46:12 -0700
Message-ID: <57a25814.3xtNRmyulkQiisET%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbcHCUqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:46:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, shijie.huang@arm.com, ananth@linux.vnet.ibm.com, anil.s.keshavamurthy@intel.com, mhiramat@kernel.org, pmladek@suse.com, steve.capper@arm.com

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
