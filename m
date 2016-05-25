From: akpm@linux-foundation.org
Subject: + samples-jprobe-convert-the-printk-to-pr_info-pr_err.patch added to -mm tree
Date: Wed, 25 May 2016 15:38:04 -0700
Message-ID: <5746294c.WtP9Pbdl86X22tPW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbcEYWiF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2016 18:38:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, ananth@linux.vnet.ibm.com, anil.s.keshavamurthy@intel.com, mhiramat@kernel.org, pmladek@suse.com, steve.capper@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: samples/jprobe: convert the printk to pr_info/pr_err
has been added to the -mm tree.  Its filename is
     samples-jprobe-convert-the-printk-to-pr_info-pr_err.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/samples-jprobe-convert-the-printk-to-pr_info-pr_err.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/samples-jprobe-convert-the-printk-to-pr_info-pr_err.patch

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

Patches currently in -mm which might be from shijie.huang@arm.com are

samples-kprobe-convert-the-printk-to-pr_info-pr_err.patch
samples-jprobe-convert-the-printk-to-pr_info-pr_err.patch
samples-kretprobe-convert-the-printk-to-pr_info-pr_err.patch
samples-kretprobe-fix-the-wrong-type.patch

