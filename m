From: akpm@linux-foundation.org
Subject: + printk-declare-printk_ratelimit_state-in-ratelimith.patch added to -mm tree
Date: Tue, 21 Sep 2010 16:11:27 -0700
Message-ID: <201009212311.o8LNBRpT008393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087Ab0IUXLj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 19:11:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, mingo@elte.hu


The patch titled
     printk: declare printk_ratelimit_state in ratelimit.h
has been added to the -mm tree.  Its filename is
     printk-declare-printk_ratelimit_state-in-ratelimith.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: declare printk_ratelimit_state in ratelimit.h
From: Namhyung Kim <namhyung@gmail.com>

Adding declaration of printk_ratelimit_state in ratelimit.h removes
potential build breakage and following sparse warning:

 kernel/printk.c:1426:1: warning: symbol 'printk_ratelimit_state' was not declared. Should it be static?

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ratelimit.h |    4 ++++
 kernel/sysctl.c           |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/ratelimit.h~printk-declare-printk_ratelimit_state-in-ratelimith include/linux/ratelimit.h
--- a/include/linux/ratelimit.h~printk-declare-printk_ratelimit_state-in-ratelimith
+++ a/include/linux/ratelimit.h
@@ -36,6 +36,10 @@ static inline void ratelimit_state_init(
 	rs->begin = 0;
 }
 
+#ifdef CONFIG_PRINTK
+extern struct ratelimit_state printk_ratelimit_state;
+#endif
+
 extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
 #define __ratelimit(state) ___ratelimit(state, __func__)
 
diff -puN kernel/sysctl.c~printk-declare-printk_ratelimit_state-in-ratelimith kernel/sysctl.c
--- a/kernel/sysctl.c~printk-declare-printk_ratelimit_state-in-ratelimith
+++ a/kernel/sysctl.c
@@ -161,8 +161,6 @@ extern int no_unaligned_warning;
 extern int unaligned_dump_stack;
 #endif
 
-extern struct ratelimit_state printk_ratelimit_state;
