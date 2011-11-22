From: akpm@linux-foundation.org
Subject: + user-namespace-make-signalc-respect-user-namespaces-v5-fix.patch added to -mm tree
Date: Mon, 21 Nov 2011 16:46:11 -0800
Message-ID: <201111220046.pAM0kCkr025512@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:35738 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab1KVAqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 19:46:18 -0500
Received: by ghrr14 with SMTP id r14so214028ghr.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 16:46:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serge.hallyn@canonical.com, ebiederm@xmission.com


The patch titled
     Subject: __send_signal: pass q->info, not info, to userns_fixup_signal_uid (v2)
has been added to the -mm tree.  Its filename is
     user-namespace-make-signalc-respect-user-namespaces-v5-fix.patch

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
From: Serge Hallyn <serge.hallyn@canonical.com>
Subject: __send_signal: pass q->info, not info, to userns_fixup_signal_uid (v2)

Eric Biederman pointed out that passing info is a bug and could lead to a
NULL pointer deref to boot.

A collection of signal, securebits, filecaps, cap_bounds, and a few other
ltp tests passed with this kernel.

Changelog:
    Nov 18: previous patch missed a leading '&'

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
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
+		userns_fixup_signal_uid(&q->info, t);
 
 	} else if (!is_si_special(info)) {
 		if (sig >= SIGRTMIN && info->si_code != SI_USER) {
_
Subject: Subject: __send_signal: pass q->info, not info, to userns_fixup_signal_uid (v2)

Patches currently in -mm which might be from serge.hallyn@canonical.com are

user-namespace-make-signalc-respect-user-namespaces-v5.patch
user-namespace-make-signalc-respect-user-namespaces-v5-fix.patch

