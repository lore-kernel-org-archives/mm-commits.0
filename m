From: akpm@linux-foundation.org
Subject: - epoll-avoid-kmemcheck-warning.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:38:41 -0700
Message-ID: <200804300538.m3U5cf7L028771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752959AbYD3Fin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:38:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     epoll: avoid kmemcheck warning
has been removed from the -mm tree.  Its filename was
     epoll-avoid-kmemcheck-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: avoid kmemcheck warning
From: Davide Libenzi <davidel@xmailserver.org>

Epoll calls rb_set_parent(n, n) to initialize the rb-tree node, but
rb_set_parent() accesses node's pointer in its code.  This creates a
warning in kmemcheck (reported by Vegard Nossum) about an uninitialized
memory access.  The warning is harmless since the following rb-tree node
insert is going to overwrite the node data.  In any case I think it's
better to not have that happening at all, and fix it by simplifying the
code to get rid of a few lines that became superfluous after the previous
epoll changes.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   27 +++------------------------
 1 file changed, 3 insertions(+), 24 deletions(-)

diff -puN fs/eventpoll.c~epoll-avoid-kmemcheck-warning fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-avoid-kmemcheck-warning
+++ a/fs/eventpoll.c
@@ -257,25 +257,6 @@ static inline int ep_cmp_ffd(struct epol
 	        (p1->file < p2->file ? -1 : p1->fd - p2->fd));
 }
 
-/* Special initialization for the RB tree node to detect linkage */
-static inline void ep_rb_initnode(struct rb_node *n)
-{
-	rb_set_parent(n, n);
-}
-
-/* Removes a node from the RB tree and marks it for a fast is-linked check */
-static inline void ep_rb_erase(struct rb_node *n, struct rb_root *r)
-{
-	rb_erase(n, r);
-	rb_set_parent(n, n);
-}
-
-/* Fast check to verify that the item is linked to the main RB tree */
-static inline int ep_rb_linked(struct rb_node *n)
-{
-	return rb_parent(n) != n;
-}
-
 /* Tells us if the item is currently linked */
 static inline int ep_is_linked(struct list_head *p)
 {
@@ -283,13 +264,13 @@ static inline int ep_is_linked(struct li
 }
 
 /* Get the "struct epitem" from a wait queue pointer */
-static inline struct epitem * ep_item_from_wait(wait_queue_t *p)
+static inline struct epitem *ep_item_from_wait(wait_queue_t *p)
 {
 	return container_of(p, struct eppoll_entry, wait)->base;
 }
 
 /* Get the "struct epitem" from an epoll queue wrapper */
-static inline struct epitem * ep_item_from_epqueue(poll_table *p)
+static inline struct epitem *ep_item_from_epqueue(poll_table *p)
 {
 	return container_of(p, struct ep_pqueue, pt)->epi;
 }
@@ -411,8 +392,7 @@ static int ep_remove(struct eventpoll *e
 		list_del_init(&epi->fllink);
 	spin_unlock(&file->f_ep_lock);
 
-	if (ep_rb_linked(&epi->rbn))
-		ep_rb_erase(&epi->rbn, &ep->rbr);
+	rb_erase(&epi->rbn, &ep->rbr);
 
 	spin_lock_irqsave(&ep->lock, flags);
 	if (ep_is_linked(&epi->rdllink))
@@ -728,7 +708,6 @@ static int ep_insert(struct eventpoll *e
 		goto error_return;
 
 	/* Item initialization follow here ... */
-	ep_rb_initnode(&epi->rbn);
 	INIT_LIST_HEAD(&epi->rdllink);
 	INIT_LIST_HEAD(&epi->fllink);
 	INIT_LIST_HEAD(&epi->pwqlist);
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
git-kvm.patch
signals-send_signal-be-paranoid-about-signalfd_notify.patch

