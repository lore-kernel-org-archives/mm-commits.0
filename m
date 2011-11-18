From: akpm@linux-foundation.org
Subject: [withdrawn] user-namespace-make-signalc-respect-user-namespaces-v5-fix.patch removed from -mm tree
Date: Fri, 18 Nov 2011 12:33:51 -0800
Message-ID: <201111182033.pAIKXpCs007881@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:44244 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab1KRUdz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2011 15:33:55 -0500
Received: by qyd20 with SMTP id 20so572450qyd.1
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2011 12:33:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge.hallyn@canonical.com, ebiederm@xmission.com, matthltc@us.ibm.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: __send_signal: pass q->info, not info, to userns_fixup_signal_uid
has been removed from the -mm tree.  Its filename was
     user-namespace-make-signalc-respect-user-namespaces-v5-fix.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: __send_signal: pass q->info, not info, to userns_fixup_signal_uid

Eric Biederman pointed out that passing info is a bug and could lead to a
NULL pointer deref to boot.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/signal.c~user-namespace-make-signalc-respect-user-namespaces-v5-fix kernel/signal.c
--- a/kernel/signal.c~user-namespace-make-signalc-respect-user-namespaces-v5-fix
+++ a/kernel/signal.c
@@ -1118,7 +1118,7 @@ static int __send_signal(int sig, struct
 			break;
 		}
 
-		userns_fixup_signal_uid(info, t);
+		userns_fixup_signal_uid(q->info, t);
 
 	} else if (!is_si_special(info)) {
 		if (sig >= SIGRTMIN && info->si_code != SI_USER) {
_

Patches currently in -mm which might be from serge.hallyn@canonical.com are

user-namespace-make-signalc-respect-user-namespaces-v5.patch

