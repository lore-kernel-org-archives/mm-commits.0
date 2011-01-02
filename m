From: akpm@linux-foundation.org
Subject: + kernel-userc-fix-freeing-user_struct-in-user-cache.patch added to -mm tree
Date: Sun, 02 Jan 2011 00:01:21 -0800
Message-ID: <201101020802.p0282RLd007080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133Ab1ABIDA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jan 2011 03:03:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, serge@hallyn.com, stable@kernel.org


The patch titled
     kernel/user.c: fix freeing user_struct in user cache
has been added to the -mm tree.  Its filename is
     kernel-userc-fix-freeing-user_struct-in-user-cache.patch

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

linux-next.patch
kernel-userc-fix-freeing-user_struct-in-user-cache.patch

