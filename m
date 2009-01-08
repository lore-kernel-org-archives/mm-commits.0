From: akpm@linux-foundation.org
Subject: - generic-swap-dcache-use-swap-instead-of-private-do_switch.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:51:24 -0800
Message-ID: <200901082251.n08MpOOH030511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763577AbZAHWv1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     generic swap(): dcache: use swap() instead of private do_switch()
has been removed from the -mm tree.  Its filename was
     generic-swap-dcache-use-swap-instead-of-private-do_switch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic swap(): dcache: use swap() instead of private do_switch()
From: Wu Fengguang <fengguang.wu@intel.com>

Use the new generic implementation.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN fs/dcache.c~generic-swap-dcache-use-swap-instead-of-private-do_switch fs/dcache.c
--- a/fs/dcache.c~generic-swap-dcache-use-swap-instead-of-private-do_switch
+++ a/fs/dcache.c
@@ -1567,10 +1567,6 @@ void d_rehash(struct dentry * entry)
 	spin_unlock(&dcache_lock);
 }
 
-#define do_switch(x,y) do { \
-	__typeof__ (x) __tmp = x; \
-	x = y; y = __tmp; } while (0)
-
 /*
  * When switching names, the actual string doesn't strictly have to
  * be preserved in the target - because we're dropping the target
@@ -1589,7 +1585,7 @@ static void switch_names(struct dentry *
 			/*
 			 * Both external: swap the pointers
 			 */
-			do_switch(target->d_name.name, dentry->d_name.name);
+			swap(target->d_name.name, dentry->d_name.name);
 		} else {
 			/*
 			 * dentry:internal, target:external.  Steal target's
@@ -1620,7 +1616,7 @@ static void switch_names(struct dentry *
 			return;
 		}
 	}
-	do_switch(dentry->d_name.len, target->d_name.len);
+	swap(dentry->d_name.len, target->d_name.len);
 }
 
 /*
@@ -1680,7 +1676,7 @@ already_unhashed:
 
 	/* Switch the names.. */
 	switch_names(dentry, target);
-	do_switch(dentry->d_name.hash, target->d_name.hash);
+	swap(dentry->d_name.hash, target->d_name.hash);
 
 	/* ... and switch the parents */
 	if (IS_ROOT(dentry)) {
@@ -1688,7 +1684,7 @@ already_unhashed:
 		target->d_parent = target;
 		INIT_LIST_HEAD(&target->d_u.d_child);
 	} else {
-		do_switch(dentry->d_parent, target->d_parent);
+		swap(dentry->d_parent, target->d_parent);
 
 		/* And add them back to the (new) parent lists */
 		list_add(&target->d_u.d_child, &target->d_parent->d_subdirs);
@@ -1789,7 +1785,7 @@ static void __d_materialise_dentry(struc
 	struct dentry *dparent, *aparent;
 
 	switch_names(dentry, anon);
-	do_switch(dentry->d_name.hash, anon->d_name.hash);
+	swap(dentry->d_name.hash, anon->d_name.hash);
 
 	dparent = dentry->d_parent;
 	aparent = anon->d_parent;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch

