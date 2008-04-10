From: akpm@linux-foundation.org
Subject: + signalfd-fix-for-incorrect-si_queue-user-data-reporting.patch added to -mm tree
Date: Thu, 10 Apr 2008 12:08:49 -0700
Message-ID: <200804101908.m3AJ8n55012916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757449AbYDJTJR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 15:09:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, mtk.manpages@googlemail.com, stable@kernel.org


The patch titled
     signalfd: fix for incorrect SI_QUEUE user data reporting
has been added to the -mm tree.  Its filename is
     signalfd-fix-for-incorrect-si_queue-user-data-reporting.patch

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
Subject: signalfd: fix for incorrect SI_QUEUE user data reporting
From: Davide Libenzi <davidel@xmailserver.org>

Michael Kerrisk found out that signalfd was not reporting back user data
pushed using sigqueue:

http://groups.google.com/group/linux.kernel/msg/9397cab8551e3123

The following patch makes signalfd report back the ssi_ptr and ssi_int members
of the signalfd_siginfo structure.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/signalfd.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/signalfd.c~signalfd-fix-for-incorrect-si_queue-user-data-reporting fs/signalfd.c
--- a/fs/signalfd.c~signalfd-fix-for-incorrect-si_queue-user-data-reporting
+++ a/fs/signalfd.c
@@ -111,9 +111,14 @@ static int signalfd_copyinfo(struct sign
 		err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
 		err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
 		break;
-	default: /* this is just in case for now ... */
+	default:
+		/*
+		 * This case catches also the signals queued by sigqueue().
+		 */
 		err |= __put_user(kinfo->si_pid, &uinfo->ssi_pid);
 		err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
+		err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
+		err |= __put_user(kinfo->si_int, &uinfo->ssi_int);
 		break;
 	}
 
_

Patches currently in -mm which might be from davidel@xmailserver.org are

eventfd-kaio-integration-fix.patch
signalfd-fix-for-incorrect-si_queue-user-data-reporting.patch
epoll-avoid-kmemcheck-warning.patch
fs-timerfdc-should-include-linux-syscallsh.patch
signals-send_signal-be-paranoid-about-signalfd_notify.patch

