From: akpm@linux-foundation.org
Subject: + do_poll-return-eintr-when-signalled.patch added to -mm tree
Date: Thu, 19 Jul 2007 18:04:34 -0700
Message-ID: <200707200104.l6K14YS2032290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755425AbXGTBEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 21:04:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ak@suse.de, davidel@xmailserver.org, vlobanov@speakeasy.net


The patch titled
     do_poll: return -EINTR when signalled
has been added to the -mm tree.  Its filename is
     do_poll-return-eintr-when-signalled.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: do_poll: return -EINTR when signalled
From: Oleg Nesterov <oleg@tv-sign.ru>

do_poll() checks signal_pending() but returns 0 when interrupted.  This means
the caller has to check signal_pending() again.

Change it to return -EINTR when signal_pending() and count == 0.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andi Kleen <ak@suse.de>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Vadim Lobanov <vlobanov@speakeasy.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/select.c~do_poll-return-eintr-when-signalled fs/select.c
--- a/fs/select.c~do_poll-return-eintr-when-signalled
+++ a/fs/select.c
@@ -588,7 +588,7 @@ static int do_poll(unsigned int nfds,  s
 	/* Optimise the no-wait case */
 	if (!(*timeout))
 		pt = NULL;
- 
+
 	for (;;) {
 		struct poll_list *walk;
 		long __timeout;
@@ -618,10 +618,12 @@ static int do_poll(unsigned int nfds,  s
 		 * a poll_table to them on the next loop iteration.
 		 */
 		pt = NULL;
-		if (count || !*timeout || signal_pending(current))
-			break;
-		count = wait->error;
-		if (count)
+		if (!count) {
+			count = wait->error;
+			if (signal_pending(current))
+				count = -EINTR;
+		}
+		if (count || !*timeout)
 			break;
 
 		if (*timeout < 0) {
@@ -691,8 +693,6 @@ int do_sys_poll(struct pollfd __user *uf
 
 	poll_initwait(&table);
 	fdcount = do_poll(nfds, head, &table, timeout);
-	if (!fdcount && signal_pending(current))
-		fdcount = -EINTR;
 	poll_freewait(&table);
 
 	for (walk = head; walk; walk = walk->next) {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
sys_time-use-barrier-instead-of-smp_rmb.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_poll-return-eintr-when-signalled.patch
