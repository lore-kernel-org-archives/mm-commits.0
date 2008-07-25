From: akpm@linux-foundation.org
Subject: - kprobes-remove-redundant-config-check.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:53 -0700
Message-ID: <200807252255.m6PMtrtG003015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755519AbYGYXHW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sagar.abhishek@gmail.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, mhiramat@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: remove redundant config check
has been removed from the -mm tree.  Its filename was
     kprobes-remove-redundant-config-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: remove redundant config check
From: Abhishek Sagar <sagar.abhishek@gmail.com>

I noticed that there's a CONFIG_KPROBES check inside kernel/kprobes.c,
which is redundant.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN kernel/kprobes.c~kprobes-remove-redundant-config-check kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-remove-redundant-config-check
+++ a/kernel/kprobes.c
@@ -1337,13 +1337,8 @@ EXPORT_SYMBOL_GPL(register_jprobe);
 EXPORT_SYMBOL_GPL(unregister_jprobe);
 EXPORT_SYMBOL_GPL(register_jprobes);
 EXPORT_SYMBOL_GPL(unregister_jprobes);
-#ifdef CONFIG_KPROBES
 EXPORT_SYMBOL_GPL(jprobe_return);
-#endif
