From: akpm@linux-foundation.org
Subject: [merged] module-do-not-inline-do_init_module.patch removed from
 -mm tree
Date: Wed, 18 Feb 2015 11:43:57 -0800
Message-ID: <54e4eb7d.Oe/IAlGbujiR6gQk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbbBRTn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, rusty@rustcorp.com.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/module.c: do not inline do_init_module()
has been removed from the -mm tree.  Its filename was
     module-do-not-inline-do_init_module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: kernel/module.c: do not inline do_init_module()

This provides a reliable breakpoint target, required for automatic symbol
loading via the gdb helper command 'lx-symbols'.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN kernel/module.c~module-do-not-inline-do_init_module kernel/module.c
--- a/kernel/module.c~module-do-not-inline-do_init_module
+++ a/kernel/module.c
@@ -3025,8 +3025,13 @@ static void do_free_init(struct rcu_head
 	kfree(m);
 }
 
-/* This is where the real work happens */
-static int do_init_module(struct module *mod)
+/*
+ * This is where the real work happens.
+ *
+ * Keep it uninlined to provide a reliable breakpoint target, e.g. for the gdb
+ * helper command 'lx-symbols'.
+ */
+static noinline int do_init_module(struct module *mod)
 {
 	int ret = 0;
 	struct mod_initfree *freeinit;
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

