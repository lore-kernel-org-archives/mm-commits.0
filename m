From: akpm@linux-foundation.org
Subject: [merged] kprobes-add-a-new-module-parameter.patch removed from
 -mm tree
Date: Mon, 23 May 2016 12:51:57 -0700
Message-ID: <57435f5d.VIQXwCgEo33u2Ch8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbcEWTv6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:51:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, pmladek@suse.com, steve.capper@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: samples/kprobes: add a new module parameter
has been removed from the -mm tree.  Its filename was
     kprobes-add-a-new-module-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Shijie <shijie.huang@arm.com>
Subject: samples/kprobes: add a new module parameter

Add a new module parameter which can be used as the symbol name.  Without
this patch, we can only test the "_do_fork" function with this kernel
module.  With this patch, the module becomes more flexible; we can test
any functions with this module with

	# insmod kprobe_example.ko symbol="xxx"

Link: http://lkml.kernel.org/r/1463535417-29637-1-git-send-email-shijie.huang@arm.com
Signed-off-by: Huang Shijie <shijie.huang@arm.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steve Capper <steve.capper@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kprobes/kprobe_example.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN samples/kprobes/kprobe_example.c~kprobes-add-a-new-module-parameter samples/kprobes/kprobe_example.c
--- a/samples/kprobes/kprobe_example.c~kprobes-add-a-new-module-parameter
+++ a/samples/kprobes/kprobe_example.c
@@ -14,9 +14,13 @@
 #include <linux/module.h>
 #include <linux/kprobes.h>
 
+#define MAX_SYMBOL_LEN	64
+static char symbol[MAX_SYMBOL_LEN] = "_do_fork";
+module_param_string(symbol, symbol, sizeof(symbol), 0644);
+
 /* For each probe you need to allocate a kprobe structure */
 static struct kprobe kp = {
-	.symbol_name	= "_do_fork",
+	.symbol_name	= symbol,
 };
 
 /* kprobe pre_handler: called just before the probed instruction is executed */
_

Patches currently in -mm which might be from shijie.huang@arm.com are

kprobes-print-out-the-symbol-name-for-the-hooks.patch

