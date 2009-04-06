From: akpm@linux-foundation.org
Subject: [merged] signals-si_user-masquerade-si_pid-when-crossing-pid-ns-boundary.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:32 -0700
Message-ID: <200904061935.n36JZW9H012061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701AbZDFU2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:28:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, daniel.lezcano@free.fr, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: SI_USER: Masquerade si_pid when crossing pid ns boundary
has been removed from the -mm tree.  Its filename was
     signals-si_user-masquerade-si_pid-when-crossing-pid-ns-boundary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: SI_USER: Masquerade si_pid when crossing pid ns boundary
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

When sending a signal to a descendant namespace, set ->si_pid to 0 since
the sender does not have a pid in the receiver's namespace.

Note:
	- If rt_sigqueueinfo() sets si_code to SI_USER when sending a
	  signal across a pid namespace boundary, the value in ->si_pid
	  will be cleared to 0.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/signal.c~signals-si_user-masquerade-si_pid-when-crossing-pid-ns-boundary kernel/signal.c
--- a/kernel/signal.c~signals-si_user-masquerade-si_pid-when-crossing-pid-ns-boundary
+++ a/kernel/signal.c
@@ -883,6 +883,8 @@ static int __send_signal(int sig, struct
 			break;
 		default:
 			copy_siginfo(&q->info, info);
+			if (from_ancestor_ns)
+				q->info.si_pid = 0;
 			break;
 		}
 	} else if (!is_si_special(info)) {
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

origin.patch
linux-next.patch

