Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9658E247DE1
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 23:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765928485; cv=none; b=hCBPQDtacLqNxAsdcyWNcZ1IbQCDJALyKe5zowgNA5AH3Kr30gNwvVkOSIhZlNdSYC0rYDjvzuyeI7HJj3Lekfk7GZiZwBu6JHKIrUUtzrrDhNLldja2n9n34S9DdCzHtzZEYcCNC9Ceeky1GpF0JVXuhNDOopUL6jB9SmdFIoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765928485; c=relaxed/simple;
	bh=1NMNn3hZzzqreMa09r4dT5A368O6UYGnF+aCrhC21s0=;
	h=Date:To:From:Subject:Message-Id; b=ewKvL33YVMCHblANwgo0tzbQo5PTJ1RI6AVwNjvWfSqsFkNUPkuv/LyK+1Di1nHux8BBKq0D3rbIyHxhTjmbsiFnJrHS0N6MQ2nLHd/ZsBpYo9vuHwWpmu6K47jPmR1gTKn9rDeCG/HjVgtHxpliWEBVkgsLazKwKh8/UPj/2NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J3p4e23t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J3p4e23t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20389C4CEF1;
	Tue, 16 Dec 2025 23:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765928485;
	bh=1NMNn3hZzzqreMa09r4dT5A368O6UYGnF+aCrhC21s0=;
	h=Date:To:From:Subject:From;
	b=J3p4e23tGmu05lcgEtzy0T0D52eoqNZssIQfEjrNAb2I11Z3AAp28tiviEUvbrZLy
	 Xj9iG21UJN6Q0Hfb38amlivRUgtb8H6Sh1ojKmBbB9AlQXwZzTqCGsoFYbNULynUan
	 Wwi777P9MnCfQBYGVA6pxmhyI77Xa7YUNKcTwHG4=
Date: Tue, 16 Dec 2025 15:41:24 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,oleg@redhat.com,david.laight.linux@gmail.com,brauner@kernel.org,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pid-only-take-pidmap_lock-once-on-alloc.patch added to mm-nonmm-unstable branch
Message-Id: <20251216234125.20389C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pid: only take pidmap_lock once on alloc
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     pid-only-take-pidmap_lock-once-on-alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-only-take-pidmap_lock-once-on-alloc.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |  134 +++++++++++++++++++++++++++++++------------------
 1 file changed, 86 insertions(+), 48 deletions(-)

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

ns-pad-refcount.patch
pid-only-take-pidmap_lock-once-on-alloc.patch

