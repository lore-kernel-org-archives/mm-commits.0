From: akpm@linux-foundation.org
Subject: + memcg-only-free-spare-array-when-readers-are-done.patch added
 to -mm tree
Date: Fri, 15 Jan 2016 12:40:49 -0800
Message-ID: <56995951.qiyNVYh2bTEc0k7d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbcAOUku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 15:40:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maco@google.com, hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     From: Martijn Coenen <maco@google.com>
has been added to the -mm tree.  Its filename is
     memcg-only-free-spare-array-when-readers-are-done.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-only-free-spare-array-when-readers-are-done.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-only-free-spare-array-when-readers-are-done.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Martijn Coenen <maco@google.com>
Subject: memcg: Only free spare array when readers are done

A spare array holding mem cgroup threshold events is kept around
to make sure we can always safely deregister an event and have an
array to store the new set of events in.

In the scenario where we're going from 1 to 0 registered events, the
pointer to the primary array containing 1 event is copied to the spare
slot, and then the spare slot is freed because no events are left.
However, it is freed before calling synchronize_rcu(), which means
readers may still be accessing threshold->primary after it is freed.

Fixed by only freeing after synchronize_rcu().

Signed-off-by: Martijn Coenen <maco@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-only-free-spare-array-when-readers-are-done mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-only-free-spare-array-when-readers-are-done
+++ a/mm/memcontrol.c
@@ -3491,16 +3491,17 @@ static void __mem_cgroup_usage_unregiste
 swap_buffers:
 	/* Swap primary and spare array */
 	thresholds->spare = thresholds->primary;
-	/* If all events are unregistered, free the spare array */
-	if (!new) {
-		kfree(thresholds->spare);
-		thresholds->spare = NULL;
-	}
 
 	rcu_assign_pointer(thresholds->primary, new);
 
 	/* To be sure that nobody uses thresholds */
 	synchronize_rcu();
+
+	/* If all events are unregistered, free the spare array */
+	if (!new) {
+		kfree(thresholds->spare);
+		thresholds->spare = NULL;
+	}
 unlock:
 	mutex_unlock(&memcg->thresholds_lock);
 }
_

Patches currently in -mm which might be from maco@google.com are

memcg-only-free-spare-array-when-readers-are-done.patch

