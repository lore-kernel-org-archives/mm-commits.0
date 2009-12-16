From: akpm@linux-foundation.org
Subject: [merged] signals-check-group_stop_count-after-tracehook_get_signal.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:27 -0800
Message-ID: <200912162038.nBGKcReU013427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964950AbZLPUin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: check ->group_stop_count after tracehook_get_signal()
has been removed from the -mm tree.  Its filename was
     signals-check-group_stop_count-after-tracehook_get_signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: check ->group_stop_count after tracehook_get_signal()
From: Oleg Nesterov <oleg@redhat.com>

Move the call to do_signal_stop() down, after tracehook call.  This makes
->group_stop_count condition visible to tracers before do_signal_stop()
will participate in this group-stop.

Currently the patch has no effect, tracehook_get_signal() always returns 0.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/signal.c~signals-check-group_stop_count-after-tracehook_get_signal kernel/signal.c
--- a/kernel/signal.c~signals-check-group_stop_count-after-tracehook_get_signal
+++ a/kernel/signal.c
@@ -1840,11 +1840,6 @@ relock:
 
 	for (;;) {
 		struct k_sigaction *ka;
-
-		if (unlikely(signal->group_stop_count > 0) &&
-		    do_signal_stop(0))
-			goto relock;
