From: akpm@linux-foundation.org
Subject: + signalfd-fix-information-leak-in-signalfd_copyinfo.patch added
 to -mm tree
Date: Tue, 21 Jul 2015 14:57:56 -0700
Message-ID: <55aec064.FvenhZEg3BbYB+C9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbbGUV55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 17:57:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amanieu@gmail.com, mingo@kernel.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: signalfd: fix information leak in signalfd_copyinfo
has been added to the -mm tree.  Its filename is
     signalfd-fix-information-leak-in-signalfd_copyinfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signalfd-fix-information-leak-in-signalfd_copyinfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signalfd-fix-information-leak-in-signalfd_copyinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Amanieu d'Antras" <amanieu@gmail.com>
Subject: signalfd: fix information leak in signalfd_copyinfo

This function may copy the si_addr_lsb field to user mode when it hasn't
been initialized, which can leak kernel stack data to user mode.

Just checking the value of si_code is insufficient because the same
si_code value is shared between multiple signals.  This is solved by
checking the value of si_signo in addition to si_code.

Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/signalfd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/signalfd.c~signalfd-fix-information-leak-in-signalfd_copyinfo fs/signalfd.c
--- a/fs/signalfd.c~signalfd-fix-information-leak-in-signalfd_copyinfo
+++ a/fs/signalfd.c
@@ -121,8 +121,9 @@ static int signalfd_copyinfo(struct sign
 		 * Other callers might not initialize the si_lsb field,
 		 * so check explicitly for the right codes here.
 		 */
-		if (kinfo->si_code == BUS_MCEERR_AR ||
-		    kinfo->si_code == BUS_MCEERR_AO)
+		if (kinfo->si_signo == SIGBUS &&
+		    (kinfo->si_code == BUS_MCEERR_AR ||
+		     kinfo->si_code == BUS_MCEERR_AO))
 			err |= __put_user((short) kinfo->si_addr_lsb,
 					  &uinfo->ssi_addr_lsb);
 #endif
_

Patches currently in -mm which might be from amanieu@gmail.com are

signal-fix-information-leak-in-copy_siginfo_from_user32.patch
signal-fix-information-leak-in-copy_siginfo_to_user.patch
signalfd-fix-information-leak-in-signalfd_copyinfo.patch

