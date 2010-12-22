From: akpm@linux-foundation.org
Subject: + kptr_restrict-for-hiding-kernel-pointers-v6.patch added to -mm tree
Date: Wed, 22 Dec 2010 15:13:37 -0800
Message-ID: <201012222313.oBMNDbIZ024868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709Ab0LVXOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Dec 2010 18:14:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, a.p.zijlstra@chello.nl, davem@davemloft.net, eparis@parisplace.org, eric.dumazet@gmail.com, eugeneteo@kernel.org, jmorris@namei.org, kees.cook@canonical.com, mingo@elte.hu, tgraf@infradead.org


The patch titled
     kptr_restrict-for-hiding-kernel-pointers-v6
has been added to the -mm tree.  Its filename is
     kptr_restrict-for-hiding-kernel-pointers-v6.patch

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
Subject: kptr_restrict-for-hiding-kernel-pointers-v6
From: Dan Rosenberg <drosenberg@vsecurity.com>

v6 removes the WARN_ONCE in favor of returning "pK-error" to avoid
breaking in certain cases, thanks to Ingo Molnar.

v5 sets kptr_restrict to a default value of 1, and properly handles the
case where it's incorrectly used in IRQ context.

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

 Documentation/sysctl/kernel.txt |    4 ++--
 lib/vsprintf.c                  |   13 ++++++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~kptr_restrict-for-hiding-kernel-pointers-v6 Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~kptr_restrict-for-hiding-kernel-pointers-v6
+++ a/Documentation/sysctl/kernel.txt
@@ -266,8 +266,8 @@ kptr_restrict:
 
 This toggle indicates whether restrictions are placed on
 exposing kernel addresses via /proc and other interfaces.  When
-kptr_restrict is set to (0), the default, there are no
-restrictions.  When kptr_restrict is set to (1), kernel pointers
+kptr_restrict is set to (0), there are no restrictions.  When
+kptr_restrict is set to (1), the default, kernel pointers
 printed using the %pK format specifier will be replaced with 0's
 unless the user has CAP_SYSLOG.  When kptr_restrict is set to
 (2), kernel pointers printed using %pK will be replaced with 0's
diff -puN lib/vsprintf.c~kptr_restrict-for-hiding-kernel-pointers-v6 lib/vsprintf.c
--- a/lib/vsprintf.c~kptr_restrict-for-hiding-kernel-pointers-v6
+++ a/lib/vsprintf.c
@@ -936,7 +936,7 @@ char *uuid_string(char *buf, char *end, 
 	return string(buf, end, uuid, spec);
 }
 
-int kptr_restrict;
+int kptr_restrict = 1;
 
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
@@ -1043,13 +1043,16 @@ char *pointer(const char *fmt, char *buf
 		 * %pK cannot be used in IRQ context because its test
 		 * for CAP_SYSLOG would be meaningless.
 		 */
-		if (in_irq() || in_serving_softirq() || in_nmi())
-			WARN_ONCE(1, "%%pK used in interrupt context.\n");
+		if (in_irq() || in_serving_softirq() || in_nmi()) {
+			if (spec.field_width == -1)
+				spec.field_width = 2 * sizeof(void *);
+			return string(buf, end, "pK-error", spec);
+		}
 
-		if (!kptr_restrict)
+		else if (!kptr_restrict)
 			break;		/* %pK does not obscure pointers */
 
-		if ((kptr_restrict != 2) &&
+		else if ((kptr_restrict != 2) &&
 		    has_capability_noaudit(current, CAP_SYSLOG))
 			break;		/* privileged apps expose pointers,
 					   unless kptr_restrict is 2 */
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

linux-next.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch
kptr_restrict-for-hiding-kernel-pointers-v4.patch
kptr_restrict-for-hiding-kernel-pointers-v6.patch

