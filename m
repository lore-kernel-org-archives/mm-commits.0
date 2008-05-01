From: akpm@linux-foundation.org
Subject: - signals-document-cld_continued-notification-mechanics.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:59 -0700
Message-ID: <200805010926.m419QxUp030352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756060AbYEAJ1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: document CLD_CONTINUED notification mechanics
has been removed from the -mm tree.  Its filename was
     signals-document-cld_continued-notification-mechanics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: document CLD_CONTINUED notification mechanics
From: Oleg Nesterov <oleg@tv-sign.ru>

A couple of small comments about how CLD_CONTINUED notification works.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN kernel/signal.c~signals-document-cld_continued-notification-mechanics kernel/signal.c
--- a/kernel/signal.c~signals-document-cld_continued-notification-mechanics
+++ a/kernel/signal.c
@@ -633,6 +633,11 @@ static int prepare_signal(int sig, struc
 			why |= SIGNAL_CLD_STOPPED;
 
 		if (why) {
+			/*
+			 * The first thread which returns from finish_stop()
+			 * will take ->siglock, notice SIGNAL_CLD_MASK, and
+			 * notify its parent. See get_signal_to_deliver().
+			 */
 			signal->flags = why | SIGNAL_STOP_CONTINUED;
 			signal->group_stop_count = 0;
 			signal->group_exit_code = 0;
@@ -1694,7 +1699,11 @@ relock:
 	try_to_freeze();
 
 	spin_lock_irq(&sighand->siglock);
