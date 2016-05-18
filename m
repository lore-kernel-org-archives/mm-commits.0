From: akpm@linux-foundation.org
Subject: + kprobes-add-a-new-module-parameter.patch added to -mm tree
Date: Wed, 18 May 2016 14:26:21 -0700
Message-ID: <573cddfd.XFvSnxBqVNAC7oPs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbcERV0W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2016 17:26:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, pmladek@suse.com, steve.capper@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: samples/kprobes: add a new module parameter
has been added to the -mm tree.  Its filename is
     kprobes-add-a-new-module-parameter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kprobes-add-a-new-module-parameter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kprobes-add-a-new-module-parameter.patch

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
Subject: samples/kprobes: add a new module parameter

Add a new module parameter which can be used as the symbol name.  With
this parameter, the module becomes more flexable.

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

kprobes-add-the-tls-argument-for-j_do_fork.patch
kprobes-add-a-new-module-parameter.patch
kprobes-print-out-the-symbol-name-for-the-hooks.patch

