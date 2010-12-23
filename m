From: akpm@linux-foundation.org
Subject: + kptr_restrict-for-hiding-kernel-pointers-v7.patch added to -mm tree
Date: Thu, 23 Dec 2010 15:21:22 -0800
Message-ID: <201012232321.oBNNLM1L017173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656Ab0LWXVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 18:21:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, a.p.zijlstra@chello.nl, davem@davemloft.net, eparis@parisplace.org, eric.dumazet@gmail.com, eugeneteo@kernel.org, jmorris@namei.org, kees.cook@canonical.com, mingo@elte.hu, tgraf@infradead.org


The patch titled
     kptr_restrict-for-hiding-kernel-pointers-v7
has been added to the -mm tree.  Its filename is
     kptr_restrict-for-hiding-kernel-pointers-v7.patch

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
Subject: kptr_restrict-for-hiding-kernel-pointers-v7
From: Dan Rosenberg <drosenberg@vsecurity.com>

v7 moves the extern to printk.h and cleans up the conditional statements
based on the suggestions of Joe Perches.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: James Morris <jmorris@namei.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Graf <tgraf@infradead.org>
Cc: Eugene Teo <eugeneteo@kernel.org>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric Paris <eparis@parisplace.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 --
 include/linux/printk.h |    1 +
 lib/vsprintf.c         |   11 ++++-------
 3 files changed, 5 insertions(+), 9 deletions(-)

diff -puN include/linux/kernel.h~kptr_restrict-for-hiding-kernel-pointers-v7 include/linux/kernel.h
--- a/include/linux/kernel.h~kptr_restrict-for-hiding-kernel-pointers-v7
+++ a/include/linux/kernel.h
@@ -216,8 +216,6 @@ extern int sscanf(const char *, const ch
 extern int vsscanf(const char *, const char *, va_list)
 	__attribute__ ((format (scanf, 2, 0)));
 
-extern int kptr_restrict;	/* for sysctl */
-
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
diff -puN include/linux/printk.h~kptr_restrict-for-hiding-kernel-pointers-v7 include/linux/printk.h
--- a/include/linux/printk.h~kptr_restrict-for-hiding-kernel-pointers-v7
+++ a/include/linux/printk.h
@@ -83,6 +83,7 @@ extern bool printk_timed_ratelimit(unsig
 
 extern int printk_delay_msec;
 extern int dmesg_restrict;
+extern int kptr_restrict;
 
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
diff -puN lib/vsprintf.c~kptr_restrict-for-hiding-kernel-pointers-v7 lib/vsprintf.c
--- a/lib/vsprintf.c~kptr_restrict-for-hiding-kernel-pointers-v7
+++ a/lib/vsprintf.c
@@ -1049,13 +1049,10 @@ char *pointer(const char *fmt, char *buf
 			return string(buf, end, "pK-error", spec);
 		}
 
-		else if (!kptr_restrict)
-			break;		/* %pK does not obscure pointers */
