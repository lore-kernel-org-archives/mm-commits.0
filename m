From: akpm@linux-foundation.org
Subject: + kprobes-remove-redundant-config-check.patch added to -mm tree
Date: Tue, 10 Jun 2008 14:12:42 -0700
Message-ID: <200806102112.m5ALCgfY029590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754154AbYFJVOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 17:14:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sagar.abhishek@gmail.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, mhiramat@redhat.com


The patch titled
     kprobes: remove redundant config check
has been added to the -mm tree.  Its filename is
     kprobes-remove-redundant-config-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1334,13 +1334,8 @@ EXPORT_SYMBOL_GPL(register_jprobe);
 EXPORT_SYMBOL_GPL(unregister_jprobe);
 EXPORT_SYMBOL_GPL(register_jprobes);
 EXPORT_SYMBOL_GPL(unregister_jprobes);
-#ifdef CONFIG_KPROBES
 EXPORT_SYMBOL_GPL(jprobe_return);
-#endif
