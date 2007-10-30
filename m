From: akpm@linux-foundation.org
Subject: - freezer-do-not-allow-freezing-processes-to-clear-tif_sigpending.patch removed from -mm tree
Date: Tue, 30 Oct 2007 11:06:13 -0700
Message-ID: <200710301806.l9UI6Dlg020501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174AbXJ3SH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@suspend2.net, oleg@tv-sign.ru, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Freezer: do not allow freezing processes to clear TIF_SIGPENDING
has been removed from the -mm tree.  Its filename was
     freezer-do-not-allow-freezing-processes-to-clear-tif_sigpending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Freezer: do not allow freezing processes to clear TIF_SIGPENDING
From: Rafael J. Wysocki <rjw@sisk.pl>

Do not allow processes to clear their TIF_SIGPENDING if TIF_FREEZE is set,
so that they will not race with the freezer (like mysqld does, for example).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Nigel Cunningham <nigel@suspend2.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/signal.c~freezer-do-not-allow-freezing-processes-to-clear-tif_sigpending kernel/signal.c
--- a/kernel/signal.c~freezer-do-not-allow-freezing-processes-to-clear-tif_sigpending
+++ a/kernel/signal.c
@@ -124,7 +124,7 @@ void recalc_sigpending_and_wake(struct t
 
 void recalc_sigpending(void)
 {
-	if (!recalc_sigpending_tsk(current))
+	if (!recalc_sigpending_tsk(current) && !freezing(current))
 		clear_thread_flag(TIF_SIGPENDING);
 
 }
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
shrink_slab-handle-bad-shrinkers.patch
