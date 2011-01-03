From: akpm@linux-foundation.org
Subject: [merged] kernel-userc-fix-freeing-user_struct-in-user-cache.patch removed from -mm tree
Date: Mon, 03 Jan 2011 10:52:18 -0800
Message-ID: <201101031853.p03Irbrj023073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146Ab1ACSxn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 13:53:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, serge@hallyn.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     kernel/user.c: fix freeing user_struct in user cache
has been removed from the -mm tree.  Its filename was
     kernel-userc-fix-freeing-user_struct-in-user-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/user.c: fix freeing user_struct in user cache
From: Hillf Danton <dhillf@gmail.com>

When racing on adding into user cache, the new allocated from mm slab
is freed without putting user namespace.

Since the user namespace is already operated by getting, putting has
to be issued.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/user.c~kernel-userc-fix-freeing-user_struct-in-user-cache kernel/user.c
--- a/kernel/user.c~kernel-userc-fix-freeing-user_struct-in-user-cache
+++ a/kernel/user.c
@@ -158,6 +158,7 @@ struct user_struct *alloc_uid(struct use
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
 		if (up) {
+			put_user_ns(ns);
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch

