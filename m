From: akpm@linux-foundation.org
Subject: + kmemleak-protect-the-seq-start-next-stop-sequence-by-rcu_read_lock.patch added to -mm tree
Date: Wed, 29 Jul 2009 17:00:12 -0700
Message-ID: <200907300000.n6U00CNa012964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755258AbZG3ABP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 20:01:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, nm127@freemail.hu


The patch titled
     kmemleak: protect the seq start/next/stop sequence by rcu_read_lock()
has been added to the -mm tree.  Its filename is
     kmemleak-protect-the-seq-start-next-stop-sequence-by-rcu_read_lock.patch

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
Subject: kmemleak: protect the seq start/next/stop sequence by rcu_read_lock()
From: Catalin Marinas <catalin.marinas@arm.com>

Objects passed to kmemleak_seq_next() have an incremented reference count
(hence not freed) but they may point via object_list.next to other freed
objects.  To avoid this, the whole start/next/stop sequence must be
protected by rcu_read_lock().

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13761

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Marton Nemeth <nm127@freemail.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/kmemleak.c~kmemleak-protect-the-seq-start-next-stop-sequence-by-rcu_read_lock mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-protect-the-seq-start-next-stop-sequence-by-rcu_read_lock
+++ a/mm/kmemleak.c
@@ -1217,7 +1217,6 @@ static void *kmemleak_seq_start(struct s
 	}
 	object = NULL;
 out:
-	rcu_read_unlock();
 	return object;
 }
 
@@ -1233,13 +1232,11 @@ static void *kmemleak_seq_next(struct se
 
 	++(*pos);
 
-	rcu_read_lock();
 	list_for_each_continue_rcu(n, &object_list) {
 		next_obj = list_entry(n, struct kmemleak_object, object_list);
 		if (get_object(next_obj))
 			break;
 	}
-	rcu_read_unlock();
 
 	put_object(prev_obj);
 	return next_obj;
@@ -1255,6 +1252,7 @@ static void kmemleak_seq_stop(struct seq
 		 * kmemleak_seq_start may return ERR_PTR if the scan_mutex
 		 * waiting was interrupted, so only release it if !IS_ERR.
 		 */
+		rcu_read_unlock();
 		mutex_unlock(&scan_mutex);
 		if (v)
 			put_object(v);
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
fs-ramfs-file-nommuc-needs-include-linux-schedh.patch
linux-next.patch
kmemleak-protect-the-seq-start-next-stop-sequence-by-rcu_read_lock.patch

