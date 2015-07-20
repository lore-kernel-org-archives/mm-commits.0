From: akpm@linux-foundation.org
Subject: + signal-fix-information-leak-in-copy_siginfo_to_user.patch added to -mm tree
Date: Mon, 20 Jul 2015 15:10:49 -0700
Message-ID: <55ad71e9.Cdn6O2pbLB904Hi0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbbGTWKv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jul 2015 18:10:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amanieu@gmail.com, mingo@kernel.org, oleg@redhat.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: fix information leak in copy_siginfo_to_user
has been added to the -mm tree.  Its filename is
     signal-fix-information-leak-in-copy_siginfo_to_user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signal-fix-information-leak-in-copy_siginfo_to_user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signal-fix-information-leak-in-copy_siginfo_to_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Amanieu d'Antras <amanieu@gmail.com>
Subject: signal: fix information leak in copy_siginfo_to_user

This function may copy the si_addr_lsb, si_lower and si_upper fields to
user mode when they haven't been initialized, which can leak kernel stack
data to user mode.

Just checking the value of si_code is insufficient because the same
si_code value is shared between multiple signals.  This is solved by
checking the value of si_signo in addition to si_code.

Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/signal32.c |    3 ++-
 kernel/signal.c              |    9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/arm64/kernel/signal32.c~signal-fix-information-leak-in-copy_siginfo_to_user arch/arm64/kernel/signal32.c
--- a/arch/arm64/kernel/signal32.c~signal-fix-information-leak-in-copy_siginfo_to_user
+++ a/arch/arm64/kernel/signal32.c
@@ -168,7 +168,8 @@ int copy_siginfo_to_user32(compat_siginf
 		 * Other callers might not initialize the si_lsb field,
 		 * so check explicitely for the right codes here.
 		 */
-		if (from->si_code == BUS_MCEERR_AR || from->si_code == BUS_MCEERR_AO)
+		if (from->si_signo == SIGBUS &&
+		    (from->si_code == BUS_MCEERR_AR || from->si_code == BUS_MCEERR_AO))
 			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
 #endif
 		break;
diff -puN kernel/signal.c~signal-fix-information-leak-in-copy_siginfo_to_user kernel/signal.c
--- a/kernel/signal.c~signal-fix-information-leak-in-copy_siginfo_to_user
+++ a/kernel/signal.c
@@ -2748,12 +2748,15 @@ int copy_siginfo_to_user(siginfo_t __use
 		 * Other callers might not initialize the si_lsb field,
 		 * so check explicitly for the right codes here.
 		 */
-		if (from->si_code == BUS_MCEERR_AR || from->si_code == BUS_MCEERR_AO)
+		if (from->si_signo == SIGBUS &&
+		    (from->si_code == BUS_MCEERR_AR || from->si_code == BUS_MCEERR_AO))
 			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
 #endif
 #ifdef SEGV_BNDERR
-		err |= __put_user(from->si_lower, &to->si_lower);
-		err |= __put_user(from->si_upper, &to->si_upper);
+		if (from->si_signo == SIGSEGV && from->si_code == SEGV_BNDERR) {
+			err |= __put_user(from->si_lower, &to->si_lower);
+			err |= __put_user(from->si_upper, &to->si_upper);
+		}
 #endif
 		break;
 	case __SI_CHLD:
_

Patches currently in -mm which might be from amanieu@gmail.com are

signal-fix-information-leak-in-copy_siginfo_from_user32.patch
signal-fix-information-leak-in-copy_siginfo_to_user.patch

