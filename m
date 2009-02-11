From: akpm@linux-foundation.org
Subject: + user-namespaces-only-put-the-userns-when-we-unhash-the-uid.patch added to -mm tree
Date: Wed, 11 Feb 2009 15:54:21 -0800
Message-ID: <200902112354.n1BNsLfq009506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752763AbZBKXys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 18:54:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com, dhowells@redhat.com, snakebyte@gmx.de, vegard.nossum@gmail.com


The patch titled
     user namespaces: only put the userns when we unhash the uid
has been added to the -mm tree.  Its filename is
     user-namespaces-only-put-the-userns-when-we-unhash-the-uid.patch

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
Subject: user namespaces: only put the userns when we unhash the uid
From: "Serge E. Hallyn" <serue@us.ibm.com>

uids in namespaces other than init don't get a sysfs entry.

For those in the init namespace, while we're waiting to remove the
sysfs entry for the uid the uid is still hashed, and alloc_uid() may
re-grab that uid without getting a new reference to the user_ns, which
we've already put in free_user before scheduling
remove_user_sysfs_dir().

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/user.c~user-namespaces-only-put-the-userns-when-we-unhash-the-uid kernel/user.c
--- a/kernel/user.c~user-namespaces-only-put-the-userns-when-we-unhash-the-uid
+++ a/kernel/user.c
@@ -72,6 +72,7 @@ static void uid_hash_insert(struct user_
 static void uid_hash_remove(struct user_struct *up)
 {
 	hlist_del_init(&up->uidhash_node);
+	put_user_ns(up->user_ns);
 }
 
 static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
@@ -334,7 +335,6 @@ static void free_user(struct user_struct
 	atomic_inc(&up->__count);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
 
-	put_user_ns(up->user_ns);
 	INIT_WORK(&up->work, remove_user_sysfs_dir);
 	schedule_work(&up->work);
 }
@@ -357,7 +357,6 @@ static void free_user(struct user_struct
 	sched_destroy_user(up);
 	key_put(up->uid_keyring);
 	key_put(up->session_keyring);
-	put_user_ns(up->user_ns);
 	kmem_cache_free(uid_cachep, up);
 }
 
_

Patches currently in -mm which might be from serue@us.ibm.com are

linux-next.patch
vfs-simple_set_mnt-should-return-void.patch
user-namespaces-only-put-the-userns-when-we-unhash-the-uid.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch
reiser4.patch

