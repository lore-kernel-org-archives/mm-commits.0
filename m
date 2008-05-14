From: akpm@linux-foundation.org
Subject: - list_for_each_rcu-must-die-audit.patch removed from -mm tree
Date: Wed, 14 May 2008 13:54:38 -0700
Message-ID: <200805142054.m4EKsdhd020314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755946AbYENUze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 16:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     list_for_each_rcu must die: audit
has been removed from the -mm tree.  Its filename was
     list_for_each_rcu-must-die-audit.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: list_for_each_rcu must die: audit
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

All uses of list_for_each_rcu() can be profitably replaced by the
easier-to-use list_for_each_entry_rcu().  This patch makes this change for the
Audit system, in preparation for removing the list_for_each_rcu() API
entirely.

Signed_off_by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit_tree.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/audit_tree.c~list_for_each_rcu-must-die-audit kernel/audit_tree.c
--- a/kernel/audit_tree.c~list_for_each_rcu-must-die-audit
+++ a/kernel/audit_tree.c
@@ -172,10 +172,9 @@ static void insert_hash(struct audit_chu
 struct audit_chunk *audit_tree_lookup(const struct inode *inode)
 {
 	struct list_head *list = chunk_hash(inode);
-	struct list_head *pos;
+	struct audit_chunk *p;
 
-	list_for_each_rcu(pos, list) {
-		struct audit_chunk *p = container_of(pos, struct audit_chunk, hash);
+	list_for_each_entry_rcu(p, list, hash) {
 		if (p->watch.inode == inode) {
 			get_inotify_watch(&p->watch);
 			return p;
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

linux-next.patch
list_for_each_rcu-must-die-audit.patch
list_for_each_rcu-must-die-networking.patch
revert-list_for_each_rcu-must-die-networking.patch
git-block.patch

