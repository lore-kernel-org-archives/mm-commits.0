From: akpm@linux-foundation.org
Subject: [merged] kmemleak-protect-the-seq-start-next-stop-sequence-by-rcu_read_lock.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:38:31 -0700
Message-ID: <200907302038.n6UKcVci013307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752334AbZG3UjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:39:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, nm127@freemail.hu, mm-commits@vger.kernel.org


The patch titled
     kmemleak: protect the seq start/next/stop sequence by rcu_read_lock()
has been removed from the -mm tree.  Its filename was
     kmemleak-protect-the-seq-start-next-stop-sequence-by-rcu_read_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

