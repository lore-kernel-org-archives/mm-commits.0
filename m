From: akpm@linux-foundation.org
Subject: - remove-unused-variable-from-send_signal.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:45 -0700
Message-ID: <200805010925.m419PjD7030236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758173AbYEAJpT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:45:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: remove unused variable from send_signal()
has been removed from the -mm tree.  Its filename was
     remove-unused-variable-from-send_signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: remove unused variable from send_signal()
From: Pavel Emelyanov <xemul@openvz.org>

This function doesn't change the ret's value and thus always returns 0, with a
single exception of returning -EAGAIN explicitly.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/signal.c~remove-unused-variable-from-send_signal kernel/signal.c
--- a/kernel/signal.c~remove-unused-variable-from-send_signal
+++ a/kernel/signal.c
@@ -661,7 +661,6 @@ static int send_signal(int sig, struct s
 			struct sigpending *signals)
 {
 	struct sigqueue * q = NULL;
-	int ret = 0;
 
 	/*
 	 * Deliver the signal to listening signalfds. This must be called
@@ -719,7 +718,7 @@ static int send_signal(int sig, struct s
 
 out_set:
 	sigaddset(&signals->signal, sig);
-	return ret;
+	return 0;
 }
 
 #define LEGACY_QUEUE(sigptr, sig) \
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
disable-the-memory-controller-by-default-v3.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

