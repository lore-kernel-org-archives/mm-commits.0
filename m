From: akpm@linux-foundation.org
Subject: [merged] signalfd-fix-information-leak-in-signalfd_copyinfo.patch removed from -mm tree
Date: Fri, 07 Aug 2015 12:03:09 -0700
Message-ID: <55c500ed.2N2yfpj+PHkmn/xl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946135AbbHGTDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 15:03:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amanieu@gmail.com, mingo@kernel.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: signalfd: fix information leak in signalfd_copyinfo
has been removed from the -mm tree.  Its filename was
     signalfd-fix-information-leak-in-signalfd_copyinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

