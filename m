From: akpm@linux-foundation.org
Subject: + sysctl-min-max-bounds-are-optional.patch added to -mm tree
Date: Thu, 07 Oct 2010 15:28:17 -0700
Message-ID: <201010072228.o97MSHdB028149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694Ab0JGW2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Oct 2010 18:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, davem@davemloft.net, ebiederm@xmission.com, jirislaby@gmail.com


The patch titled
     sysctl: min/max bounds are optional
has been added to the -mm tree.  Its filename is
     sysctl-min-max-bounds-are-optional.patch

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
Subject: sysctl: min/max bounds are optional
From: Eric Dumazet <eric.dumazet@gmail.com>

sysctl check complains when proc_doulongvec_minmax or
proc_doulongvec_ms_jiffies_minmax are used by a vector of longs (with more
than one element), with no min or max value specified.

This is unexpected, given we had a bug on this min/max handling :)

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN kernel/sysctl_check.c~sysctl-min-max-bounds-are-optional kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-min-max-bounds-are-optional
+++ a/kernel/sysctl_check.c
@@ -143,15 +143,6 @@ int sysctl_check_table(struct nsproxy *n
 				if (!table->maxlen)
 					set_fail(&fail, table, "No maxlen");
 			}
-			if ((table->proc_handler == proc_doulongvec_minmax) ||
-			    (table->proc_handler == proc_doulongvec_ms_jiffies_minmax)) {
-				if (table->maxlen > sizeof (unsigned long)) {
-					if (!table->extra1)
-						set_fail(&fail, table, "No min");
-					if (!table->extra2)
-						set_fail(&fail, table, "No max");
-				}
-			}
 #ifdef CONFIG_PROC_SYSCTL
 			if (table->procname && !table->proc_handler)
 				set_fail(&fail, table, "No proc_handler");
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

sysctl-fix-min-max-handling-in-__do_proc_doulongvec_minmax-v2.patch
sysctl-min-max-bounds-are-optional.patch
linux-next.patch
net-avoid-limits-overflow.patch
fs-allow-for-more-than-231-files.patch
percpu_counter-use-this_cpu_ptr-instead-of-per_cpu_ptr.patch
signals-annotate-lock_task_sighand.patch

