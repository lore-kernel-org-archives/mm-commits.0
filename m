From: akpm@linux-foundation.org
Subject: [patch 07/18] samples/jprobe: convert the printk to
 pr_info/pr_err
Date: Wed, 03 Aug 2016 13:46:06 -0700
Message-ID: <57a2580e.Bx+JVt+fPQlQkSAJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300AbcHCUqh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:46:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, shijie.huang@arm.com, ananth@linux.vnet.ibm.com, anil.s.keshavamurthy@intel.com, mhiramat@kernel.org, pmladek@suse.com, steve.capper@arm.com

From: Huang Shijie <shijie.huang@arm.com>
Subject: samples/jprobe: convert the printk to pr_info/pr_err

We prefer to use the pr_* to print out the log now, this patch converts
the printk to pr_info.  In the error path, use the pr_err to replace the
printk.

Link: http://lkml.kernel.org/r/1464143083-3877-2-git-send-email-shijie.huang@arm.com
Signed-off-by: Huang Shijie <shijie.huang@arm.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Ananth N Mavinakayanahalli <ananth@linux.vnet.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kprobes/jprobe_example.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN samples/kprobes/jprobe_example.c~samples-jprobe-convert-the-printk-to-pr_info-pr_err samples/kprobes/jprobe_example.c
--- a/samples/kprobes/jprobe_example.c~samples-jprobe-convert-the-printk-to-pr_info-pr_err
+++ a/samples/kprobes/jprobe_example.c
@@ -48,10 +48,10 @@ static int __init jprobe_init(void)
 
 	ret = register_jprobe(&my_jprobe);
 	if (ret < 0) {
-		printk(KERN_INFO "register_jprobe failed, returned %d\n", ret);
+		pr_err("register_jprobe failed, returned %d\n", ret);
 		return -1;
 	}
-	printk(KERN_INFO "Planted jprobe at %p, handler addr %p\n",
+	pr_info("Planted jprobe at %p, handler addr %p\n",
 	       my_jprobe.kp.addr, my_jprobe.entry);
 	return 0;
 }
@@ -59,7 +59,7 @@ static int __init jprobe_init(void)
 static void __exit jprobe_exit(void)
 {
 	unregister_jprobe(&my_jprobe);
-	printk(KERN_INFO "jprobe at %p unregistered\n", my_jprobe.kp.addr);
+	pr_info("jprobe at %p unregistered\n", my_jprobe.kp.addr);
 }
 
 module_init(jprobe_init)
_
