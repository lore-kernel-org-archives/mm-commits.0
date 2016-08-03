From: akpm@linux-foundation.org
Subject: [patch 08/18] samples/kretprobe: convert the printk to
 pr_info/pr_err
Date: Wed, 03 Aug 2016 13:46:09 -0700
Message-ID: <57a25811.QCWyfgGiG3kHMdnU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303AbcHCUqh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:46:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, shijie.huang@arm.com, ananth@linux.vnet.ibm.com, anil.s.keshavamurthy@intel.com, mhiramat@kernel.org, pmladek@suse.com, steve.capper@arm.com

From: Huang Shijie <shijie.huang@arm.com>
Subject: samples/kretprobe: convert the printk to pr_info/pr_err

We prefer to use the pr_* to print out the log now, this patch converts
the printk to pr_info.  In the error path, use the pr_err to replace the
printk.

Link: http://lkml.kernel.org/r/1464143083-3877-3-git-send-email-shijie.huang@arm.com
Signed-off-by: Huang Shijie <shijie.huang@arm.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Ananth N Mavinakayanahalli <ananth@linux.vnet.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kprobes/kretprobe_example.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN samples/kprobes/kretprobe_example.c~samples-kretprobe-convert-the-printk-to-pr_info-pr_err samples/kprobes/kretprobe_example.c
--- a/samples/kprobes/kretprobe_example.c~samples-kretprobe-convert-the-printk-to-pr_info-pr_err
+++ a/samples/kprobes/kretprobe_example.c
@@ -62,7 +62,7 @@ static int ret_handler(struct kretprobe_
 
 	now = ktime_get();
 	delta = ktime_to_ns(ktime_sub(now, data->entry_stamp));
-	printk(KERN_INFO "%s returned %d and took %lld ns to execute\n",
+	pr_info("%s returned %d and took %lld ns to execute\n",
 			func_name, retval, (long long)delta);
 	return 0;
 }
@@ -82,11 +82,10 @@ static int __init kretprobe_init(void)
 	my_kretprobe.kp.symbol_name = func_name;
 	ret = register_kretprobe(&my_kretprobe);
 	if (ret < 0) {
-		printk(KERN_INFO "register_kretprobe failed, returned %d\n",
-				ret);
+		pr_err("register_kretprobe failed, returned %d\n", ret);
 		return -1;
 	}
-	printk(KERN_INFO "Planted return probe at %s: %p\n",
+	pr_info("Planted return probe at %s: %p\n",
 			my_kretprobe.kp.symbol_name, my_kretprobe.kp.addr);
 	return 0;
 }
@@ -94,11 +93,10 @@ static int __init kretprobe_init(void)
 static void __exit kretprobe_exit(void)
 {
 	unregister_kretprobe(&my_kretprobe);
-	printk(KERN_INFO "kretprobe at %p unregistered\n",
-			my_kretprobe.kp.addr);
+	pr_info("kretprobe at %p unregistered\n", my_kretprobe.kp.addr);
 
 	/* nmissed > 0 suggests that maxactive was set too low. */
-	printk(KERN_INFO "Missed probing %d instances of %s\n",
+	pr_info("Missed probing %d instances of %s\n",
 		my_kretprobe.nmissed, my_kretprobe.kp.symbol_name);
 }
 
_
