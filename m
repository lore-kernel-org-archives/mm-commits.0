From: akpm@linux-foundation.org
Subject: [folded] user-namespace-make-signalc-respect-user-namespaces-v5-fix.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:57:55 -0800
Message-ID: <20120110225755.8A38E1000FC@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:63640 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933371Ab2AJW54 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:57:56 -0500
Received: by ghrr15 with SMTP id r15so14601ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:57:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge.hallyn@canonical.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: __send_signal: pass q->info, not info, to userns_fixup_signal_uid (v2)
has been removed from the -mm tree.  Its filename was
     user-namespace-make-signalc-respect-user-namespaces-v5-fix.patch

This patch was dropped because it was folded into user-namespace-make-signalc-respect-user-namespaces-v5.patch

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

Patches currently in -mm which might be from serge.hallyn@canonical.com are

origin.patch
user-namespace-make-signalc-respect-user-namespaces-v5.patch

