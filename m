From: akpm@linux-foundation.org
Subject: + generic-swap-dcache-use-swap-instead-of-private-do_switch.patch added to -mm tree
Date: Wed, 03 Dec 2008 00:19:19 -0800
Message-ID: <200812030819.mB38JJZT010318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbYLCITX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 03:19:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, viro@zeniv.linux.org.uk


The patch titled
     generic swap(): dcache: use swap() instead of private do_switch()
has been added to the -mm tree.  Its filename is
     generic-swap-dcache-use-swap-instead-of-private-do_switch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1572,10 +1572,6 @@ void d_rehash(struct dentry * entry)
 	spin_unlock(&dcache_lock);
 }
 
-#define do_switch(x,y) do { \
-	__typeof__ (x) __tmp = x; \
-	x = y; y = __tmp; } while (0)
-
 /*
  * When switching names, the actual string doesn't strictly have to
  * be preserved in the target - because we're dropping the target
@@ -1594,7 +1590,7 @@ static void switch_names(struct dentry *
 			/*
 			 * Both external: swap the pointers
 			 */
-			do_switch(target->d_name.name, dentry->d_name.name);
+			swap(target->d_name.name, dentry->d_name.name);
 		} else {
 			/*
 			 * dentry:internal, target:external.  Steal target's
@@ -1625,7 +1621,7 @@ static void switch_names(struct dentry *
 			return;
 		}
 	}
-	do_switch(dentry->d_name.len, target->d_name.len);
+	swap(dentry->d_name.len, target->d_name.len);
 }
 
 /*
@@ -1685,7 +1681,7 @@ already_unhashed:
 
 	/* Switch the names.. */
 	switch_names(dentry, target);
-	do_switch(dentry->d_name.hash, target->d_name.hash);
+	swap(dentry->d_name.hash, target->d_name.hash);
 
 	/* ... and switch the parents */
 	if (IS_ROOT(dentry)) {
@@ -1693,7 +1689,7 @@ already_unhashed:
 		target->d_parent = target;
 		INIT_LIST_HEAD(&target->d_u.d_child);
 	} else {
-		do_switch(dentry->d_parent, target->d_parent);
+		swap(dentry->d_parent, target->d_parent);
 
 		/* And add them back to the (new) parent lists */
 		list_add(&target->d_u.d_child, &target->d_parent->d_subdirs);
@@ -1794,7 +1790,7 @@ static void __d_materialise_dentry(struc
 	struct dentry *dparent, *aparent;
 
 	switch_names(dentry, anon);
-	do_switch(dentry->d_name.hash, anon->d_name.hash);
+	swap(dentry->d_name.hash, anon->d_name.hash);
 
 	dparent = dentry->d_parent;
 	aparent = anon->d_parent;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
9p-convert-d_iname-references-to-d_namename.patch
nfs-remove-redundant-tests-on-reading-new-pages.patch
generic-swap-ath9k-rename-swap-to-swap_array.patch
generic-swap-sparc-rename-swap-to-swap_ulong.patch
generic-swap-iphase-rename-swap-to-swap_byte_order.patch
generic-swap-lib-sortc-rename-swap-to-swap_func.patch
generic-swap-introduce-global-macro-swapa-b.patch
generic-swap-ext3-remove-local-swap-macro.patch
generic-swap-ext4-remove-local-swap-macro.patch
generic-swap-sched-remove-local-swap-macro.patch
generic-swap-dcache-use-swap-instead-of-private-do_switch.patch

