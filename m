Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0F322258C
	for <mm-commits@vger.kernel.org>; Thu, 18 Dec 2025 23:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766100813; cv=none; b=dBoBOAHUHlzf5KMLKkJFQhQRWIWZZJmvzbryQT2o8VQusajJFo/jpL3UcJrxpVVA5nXgveESS1Cph1RO8n7lyl6f7PlD403Hkpc+faaiRqQL28fVMP58uAFCJVzsa1K8W5nUtY5v72lWz3ouP4bgN1cfaw98PzhgjOOpjsqgVf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766100813; c=relaxed/simple;
	bh=qgnD9TG+r678irhEFKrsDKukbtjOzQVr6Ja15PJkFJY=;
	h=Date:To:From:Subject:Message-Id; b=Zab34pcAW65V9RrBNBWFXHiaMGlkBW6ajMhFjrkfzsJzShrJ93LWODuCPF/QsfsubwBkagpKVwXWT1K0oSY9jV/quaMOCixIXWitCMtRkecvtI+D+PaeVC+goUjntdEmFrf8w18nhQfKEgkE+8+Tsn9nO4Mq1Bfm6ttKDzMNzFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X3vLHdYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X3vLHdYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68197C4CEFB;
	Thu, 18 Dec 2025 23:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766100813;
	bh=qgnD9TG+r678irhEFKrsDKukbtjOzQVr6Ja15PJkFJY=;
	h=Date:To:From:Subject:From;
	b=X3vLHdYYn2ym/5dVWOtVCY9TNE3TEaAvxF8tTnODbwNR+H0j6Ynuvrq2unbiVpW7s
	 GXk5Od+RYyK5AckA1VBao+htxM6DTsQNhVjWkXvZYxhNJo+ldZ3WlIX7QFUrYpq8cz
	 N2UWLaEwFC1Sk+oJvG2cSnA870nR6D0jMyXCNw7k=
Date: Thu, 18 Dec 2025 15:33:32 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tycho@kernel.org,oleg@redhat.com,david.laight.linux@gmail.com,brauner@kernel.org,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] pid-only-take-pidmap_lock-once-on-alloc.patch removed from -mm tree
Message-Id: <20251218233333.68197C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: pid: only take pidmap_lock once on alloc
has been removed from the -mm tree.  Its filename was
     pid-only-take-pidmap_lock-once-on-alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: pid: only take pidmap_lock once on alloc
Date: Sat, 6 Dec 2025 14:19:55 +0100

When spawning and killing threads in separate processes in parallel the
primary bottleneck on the stock kernel is pidmap_lock, largely because of
a back-to-back acquire in the common case.  This aspect is fixed with the
patch.

Performance improvement varies between reboots.  When benchmarking with 20
processes creating and killing threads in a loop, the unpatched baseline
hovers around 465k ops/s, while patched is anything between ~510k ops/s
and ~560k depending on false-sharing (which I only minimally sanitized). 
So this is at least 10% if you are unlucky.

The change also facilitated some cosmetic changes.

Link: https://lkml.kernel.org/r/20251206131955.780557-3-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Tycho Andersen (AMD) <tycho@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/kernel/pid.c~pid-only-take-pidmap_lock-once-on-alloc
+++ a/kernel/pid.c
@@ -159,65 +159,94 @@ void free_pids(struct pid **pids)
 			free_pid(pids[tmp]);
 }
 
-struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
-		      size_t set_tid_size)
+struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
+		      size_t arg_set_tid_size)
 {
+	int set_tid[MAX_PID_NS_LEVEL + 1] = {};
+	int pid_max[MAX_PID_NS_LEVEL + 1] = {};
 	struct pid *pid;
 	enum pid_type type;
 	int i, nr;
 	struct pid_namespace *tmp;
 	struct upid *upid;
 	int retval = -ENOMEM;
+	bool retried_preload;
 
 	/*
-	 * set_tid_size contains the size of the set_tid array. Starting at
+	 * arg_set_tid_size contains the size of the arg_set_tid array. Starting at
 	 * the most nested currently active PID namespace it tells alloc_pid()
 	 * which PID to set for a process in that most nested PID namespace
-	 * up to set_tid_size PID namespaces. It does not have to set the PID
-	 * for a process in all nested PID namespaces but set_tid_size must
+	 * up to arg_set_tid_size PID namespaces. It does not have to set the PID
+	 * for a process in all nested PID namespaces but arg_set_tid_size must
 	 * never be greater than the current ns->level + 1.
 	 */
-	if (set_tid_size > ns->level + 1)
+	if (unlikely(arg_set_tid_size > ns->level + 1))
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * Prep before we take locks:
+	 *
+	 * 1. allocate and fill in pid struct
+	 */
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
-	if (!pid)
+	if (unlikely(!pid))
 		return ERR_PTR(retval);
 
-	tmp = ns;
+	get_pid_ns(ns);
 	pid->level = ns->level;
+	refcount_set(&pid->count, 1);
+	spin_lock_init(&pid->lock);
+	for (type = 0; type < PIDTYPE_MAX; ++type)
+		INIT_HLIST_HEAD(&pid->tasks[type]);
+	init_waitqueue_head(&pid->wait_pidfd);
+	INIT_HLIST_HEAD(&pid->inodes);
 
-	for (i = ns->level; i >= 0; i--) {
-		int tid = 0;
-		int pid_max = READ_ONCE(tmp->pid_max);
+	/*
+	 * 2. perm check checkpoint_restore_ns_capable()
+	 *
+	 * This stores found pid_max to make sure the used value is the same should
+	 * later code need it.
+	 */
+	for (tmp = ns, i = ns->level; i >= 0;) {
+		pid_max[ns->level - i] = READ_ONCE(tmp->pid_max);
 
-		if (set_tid_size) {
-			tid = set_tid[ns->level - i];
+		if (arg_set_tid_size) {
+			int tid = set_tid[ns->level - i] = arg_set_tid[ns->level - i];
 
 			retval = -EINVAL;
-			if (tid < 1 || tid >= pid_max)
-				goto out_free;
+			if (tid < 1 || tid >= pid_max[ns->level - i])
+				goto out_abort;
 			/*
 			 * Also fail if a PID != 1 is requested and
 			 * no PID 1 exists.
 			 */
 			if (tid != 1 && !tmp->child_reaper)
-				goto out_free;
+				goto out_abort;
 			retval = -EPERM;
 			if (!checkpoint_restore_ns_capable(tmp->user_ns))
-				goto out_free;
-			set_tid_size--;
+				goto out_abort;
+			arg_set_tid_size--;
 		}
 
-		idr_preload(GFP_KERNEL);
-		spin_lock(&pidmap_lock);
+		tmp = tmp->parent;
+		i--;
+	}
+
+	/*
+	 * Prep is done, id allocation goes here:
+	 */
+	retried_preload = false;
+	idr_preload(GFP_KERNEL);
+	spin_lock(&pidmap_lock);
+	for (tmp = ns, i = ns->level; i >= 0;) {
+		int tid = set_tid[ns->level - i];
 
 		if (tid) {
 			nr = idr_alloc(&tmp->idr, NULL, tid,
 				       tid + 1, GFP_ATOMIC);
 			/*
 			 * If ENOSPC is returned it means that the PID is
-			 * alreay in use. Return EEXIST in that case.
+			 * already in use. Return EEXIST in that case.
 			 */
 			if (nr == -ENOSPC)
 				nr = -EEXIST;
@@ -235,19 +264,41 @@ struct pid *alloc_pid(struct pid_namespa
 			 * a partially initialized PID (see below).
 			 */
 			nr = idr_alloc_cyclic(&tmp->idr, NULL, pid_min,
-					      pid_max, GFP_ATOMIC);
+					      pid_max[ns->level - i], GFP_ATOMIC);
+			if (nr == -ENOSPC)
+				nr = -EAGAIN;
 		}
-		spin_unlock(&pidmap_lock);
-		idr_preload_end();
 
-		if (nr < 0) {
-			retval = (nr == -ENOSPC) ? -EAGAIN : nr;
+		if (unlikely(nr < 0)) {
+			/*
+			 * Preload more memory if idr_alloc{,cyclic} failed with -ENOMEM.
+			 *
+			 * The IDR API only allows us to preload memory for one call, while we may end
+			 * up doing several with GFP_ATOMIC. It may be the situation is salvageable with
+			 * GFP_KERNEL. But make sure to not loop indefinitely if preload did not help
+			 * (the routine unfortunately returns void, so we have no idea if it got anywhere).
+			 *
+			 * The pidmap lock can be safely dropped and picked up as historically pid allocation
+			 * for different namespaces was *not* atomic -- we try to hold on to it the
+			 * entire time only for performance reasons.
+			 */
+			if (nr == -ENOMEM && !retried_preload) {
+				spin_unlock(&pidmap_lock);
+				idr_preload_end();
+				retried_preload = true;
+				idr_preload(GFP_KERNEL);
+				spin_lock(&pidmap_lock);
+				continue;
+			}
+			retval = nr;
 			goto out_free;
 		}
 
 		pid->numbers[i].nr = nr;
 		pid->numbers[i].ns = tmp;
 		tmp = tmp->parent;
+		i--;
+		retried_preload = false;
 	}
 
 	/*
@@ -257,25 +308,15 @@ struct pid *alloc_pid(struct pid_namespa
 	 * is what we have exposed to userspace for a long time and it is
 	 * documented behavior for pid namespaces. So we can't easily
 	 * change it even if there were an error code better suited.
+	 *
+	 * This can't be done earlier because we need to preserve other
+	 * error conditions.
 	 */
 	retval = -ENOMEM;
-
-	get_pid_ns(ns);
-	refcount_set(&pid->count, 1);
-	spin_lock_init(&pid->lock);
-	for (type = 0; type < PIDTYPE_MAX; ++type)
-		INIT_HLIST_HEAD(&pid->tasks[type]);
-
-	init_waitqueue_head(&pid->wait_pidfd);
-	INIT_HLIST_HEAD(&pid->inodes);
-
-	upid = pid->numbers + ns->level;
-	idr_preload(GFP_KERNEL);
-	spin_lock(&pidmap_lock);
-	if (!(ns->pid_allocated & PIDNS_ADDING))
-		goto out_unlock;
+	if (unlikely(!(ns->pid_allocated & PIDNS_ADDING)))
+		goto out_free;
 	pidfs_add_pid(pid);
-	for ( ; upid >= pid->numbers; --upid) {
+	for (upid = pid->numbers + ns->level; upid >= pid->numbers; --upid) {
 		/* Make the PID visible to find_pid_ns. */
 		idr_replace(&upid->ns->idr, pid, upid->nr);
 		upid->ns->pid_allocated++;
@@ -286,13 +327,7 @@ struct pid *alloc_pid(struct pid_namespa
 
 	return pid;
 
-out_unlock:
-	spin_unlock(&pidmap_lock);
-	idr_preload_end();
-	put_pid_ns(ns);
-
 out_free:
-	spin_lock(&pidmap_lock);
 	while (++i <= ns->level) {
 		upid = pid->numbers + i;
 		idr_remove(&upid->ns->idr, upid->nr);
@@ -303,7 +338,10 @@ out_free:
 		idr_set_cursor(&ns->idr, 0);
 
 	spin_unlock(&pidmap_lock);
+	idr_preload_end();
 
+out_abort:
+	put_pid_ns(ns);
 	kmem_cache_free(ns->pid_cachep, pid);
 	return ERR_PTR(retval);
 }
_

Patches currently in -mm which might be from mjguzik@gmail.com are


