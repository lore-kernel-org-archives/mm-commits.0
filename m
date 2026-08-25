Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2794B313545;
	Tue, 25 Aug 2026 01:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622306; cv=none; b=btpeLesqHuvM1RZWktaRUtlBDJfwtilU8UmqG9TFK0dvE28PA3iQNvuT4HngLgt8nq3xP7pbxYw1nV2rvlA8RzE0mc+5qzjjbt5CaHond/tzjj5LUypTBgUxAAPRIdruGWt2JXrD0KGT9k6y9re4Z0uIOG374PZQe1TYZjR9gvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622306; c=relaxed/simple;
	bh=sMpZUMqPdOphVvKcnAlW61q0q21l1tF57kzV23+yx78=;
	h=Date:To:From:Subject:Message-Id; b=KDY6CI0BdO8ZnmlEuwB/570HyRa7UMACxPS4jiQa/mTgB9gY3lHDBpDDxe9iD9mnCLMz1Prq/icS4A3S15uGi/yEiNNw+FUU7Ftovd+KquYBXXItimG5rIvsJGpk9Kn8F1NXlME8wHN5VzsuaiTg3lB6DOFMkZZ9zjdwZW6t0uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HZXbKMX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HZXbKMX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A801F000E9;
	Tue, 25 Aug 2026 01:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622304;
	bh=e3YhobTR7/umOkKHr4SCH7VZwgZH9eUTttBjErIYId8=;
	h=Date:To:From:Subject;
	b=HZXbKMX0bDprX5rfyjkyw9LBxGO806PaQNk9d5lrvdtb96WOebto11W2pCC+h3sh7
	 1DdASPJUaklLd2uf9AkvegUiojS18ZgUMWX4ejoH/uONqUDRh2HdJzEYcT5w3KC4Ft
	 lXIzzaFPdZdbZkmDKCmSs686IryUj+WWmaEVWENg=
Date: Mon, 24 Aug 2026 18:45:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,puranjay@kernel.org,paulmck@kernel.org,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch removed from -mm tree
Message-Id: <20260825014504.A5A801F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmemleak: report RCU-tasks quiescent states during the scan
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/kmemleak: report RCU-tasks quiescent states during the scan
Date: Mon, 20 Jul 2026 06:23:45 -0700

kmemleak_scan() can run for ages on large debug kernels. It was
causing some soft-lockups which I got fixed with commit
3175fcfec8b16baeb ("mm/kmemleak: avoid soft lockup when scanning task
stacks") with our beloved cond_resched().

I've got the fix above deployed in the Meta fleet, and now I am seeing:

  INFO: rcu_tasks detected stalls on tasks:
    task:kmemleak state:R ... nvcsw: 274/274 holdout: 1 idle_cpu: -1/3
     scan_block
     scan_gray_list
     kmemleak_scan

and, worse, blocks the callers waiting on that grace period.  Here a BPF
struct_ops map free, which waits via synchronize_rcu_mult(call_rcu,
call_rcu_tasks), is stuck long enough to also trip the hung task check:

  INFO: task kworker/...:bpf_map_free_deferred blocked for 122 seconds
     __wait_rcu_gp
     bpf_struct_ops_map_free

Then I've learned that cond_resched() is not an RCU-tasks quiescent
state, so, we need to use stronger primitives.

Use cond_resched_tasks_rcu_qs() at the scan reschedule points so the scan
reports an RCU-tasks quiescent state as it proceeds.

Inspired by commit b96285e10aad ("tracing: Have osnoise_main() add a
quiescent state for task rcu").

Link: https://lore.kernel.org/20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org
Fixes: c4b28963fd79 ("mm/kmemleak: rely on rcu for task stack scanning")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Puranjay Mohan <puranjay@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan
+++ a/mm/kmemleak.c
@@ -1571,7 +1571,7 @@ static int scan_large_block(void *start,
 		if (scan_block(start, next, NULL))
 			return 1;
 		start = next;
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 
 	return 0;
@@ -1608,7 +1608,7 @@ static void scan_object(struct kmemleak_
 			scan_block(start, end, object);
 
 			raw_spin_unlock_irqrestore(&object->lock, flags);
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 			raw_spin_lock_irqsave(&object->lock, flags);
 			if (!(object->flags & OBJECT_ALLOCATED))
 				break;
@@ -1630,7 +1630,7 @@ static void scan_object(struct kmemleak_
 				break;
 
 			raw_spin_unlock_irqrestore(&object->lock, flags);
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 			raw_spin_lock_irqsave(&object->lock, flags);
 		} while (object->flags & OBJECT_ALLOCATED);
 	} else {
@@ -1658,7 +1658,7 @@ static void scan_gray_list(void)
 	 */
 	object = list_entry(gray_list.next, typeof(*object), gray_list);
 	while (&object->gray_list != &gray_list) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		/* may add new objects to the list */
 		if (!scan_should_stop())
@@ -1693,7 +1693,7 @@ static void kmemleak_cond_resched(struct
 	raw_spin_unlock_irq(&kmemleak_lock);
 
 	rcu_read_unlock();
-	cond_resched();
+	cond_resched_tasks_rcu_qs();
 	rcu_read_lock();
 
 	raw_spin_lock_irq(&kmemleak_lock);
@@ -1738,7 +1738,7 @@ static void kmemleak_scan_task_stacks(vo
 			}
 			put_task_struct(p);
 		}
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	} while (pid && !stop);
 }
 
@@ -1915,7 +1915,7 @@ static void kmemleak_scan(void)
 			struct page *page = pfn_to_online_page(pfn);
 
 			if (!(pfn & 63))
-				cond_resched();
+				cond_resched_tasks_rcu_qs();
 
 			if (!page)
 				continue;
_

Patches currently in -mm which might be from leitao@debian.org are


