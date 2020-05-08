From: akpm@linux-foundation.org
Subject: [folded-merged]
 eventpoll-fix-missing-wakeup-for-ovflist-in-ep_poll_callback-v2.patch
 removed from -mm tree
Date: Thu, 07 May 2020 18:28:11 -0700
Message-ID: <20200508012811.pyjAzARub%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgEHB2M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 21:28:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, khazhy@google.com, mm-commits@vger.kernel.org, r@hev.cc, rpenyaev@suse.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: eventpoll: fix missing wakeup for ovflist in ep_poll_callback
has been removed from the -mm tree.  Its filename was
     eventpoll-fix-missing-wakeup-for-ovflist-in-ep_poll_callback-v2.patch

This patch was dropped because it was folded into eventpoll-fix-missing-wakeup-for-ovflist-in-ep_poll_callback.patch

------------------------------------------------------
From: Khazhismel Kumykov <khazhy@google.com>
Subject: eventpoll: fix missing wakeup for ovflist in ep_poll_callback

use if/elif instead of goto + cleanup suggested by Roman

Link: http://lkml.kernel.org/r/20200424190039.192373-1-khazhy@google.com
Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Reviewed-by: Roman Penyaev <rpenyaev@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Heiher <r@hev.cc>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/fs/eventpoll.c~eventpoll-fix-missing-wakeup-for-ovflist-in-ep_poll_callback-v2
+++ a/fs/eventpoll.c
@@ -1171,6 +1171,10 @@ static inline bool chain_epi_lockless(st
 {
 	struct eventpoll *ep = epi->ep;
 
+	/* Fast preliminary check */
+	if (epi->next != EP_UNACTIVE_PTR)
+		return false;
+
 	/* Check that the same epi has not been just chained from another CPU */
 	if (cmpxchg(&epi->next, EP_UNACTIVE_PTR, NULL) != EP_UNACTIVE_PTR)
 		return false;
@@ -1237,19 +1241,14 @@ static int ep_poll_callback(wait_queue_e
 	 * chained in ep->ovflist and requeued later on.
 	 */
 	if (READ_ONCE(ep->ovflist) != EP_UNACTIVE_PTR) {
-		if (epi->next == EP_UNACTIVE_PTR &&
-		    chain_epi_lockless(epi))
+		if (chain_epi_lockless(epi))
+			ep_pm_stay_awake_rcu(epi);
+	} else if (!ep_is_linked(epi)) {
+		/* In the usual case, add event to ready list. */
+		if (list_add_tail_lockless(&epi->rdllink, &ep->rdllist))
 			ep_pm_stay_awake_rcu(epi);
-		goto out_wakeup_unlock;
-	}
