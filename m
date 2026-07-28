Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1979C44C51A
	for <mm-commits@vger.kernel.org>; Tue, 28 Jul 2026 19:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785268663; cv=none; b=RFEq1uZogXH1i0FxFQlij7fO1UQ3+nLG4EadI8y2VtqHUVFY57wUBhtMNe07kR7NxXm57+oMj3LTM8Q+1zjmNs20qLgh7dz3FIKXttyCpv5s6nbsDWCzGcbMiF8zKcyBthM52R/dKekaXczNtKYreO5jumZEsQAwBAE+6Y2gZa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785268663; c=relaxed/simple;
	bh=/PcS0AvQY7/IK8QBgV9lcne0skdCv1p4QUNomRZtS6g=;
	h=Date:To:From:Subject:Message-Id; b=dE+v40vdUZuIXZSo5EuWO62DX6UYRiiuKa9U28k085QjoymjmPy0yeeHH06lS06kaWBeYjdqMG0AB+28X1FeehFtm7eCn+yMMIvAG4LSFkc02UOxYXk19Lmn7g5ovxSHjlCXr2WqqiwziGmcnSffqWJLsvA86ekTqF/+KMc4tCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PfUVg4+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PfUVg4+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993B61F000E9;
	Tue, 28 Jul 2026 19:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785268661;
	bh=2BEVWcGC8c+DF44k6x0WXo/RH/YuiKSXRuylx1rgexk=;
	h=Date:To:From:Subject;
	b=PfUVg4+2sZSczLwLld1Pjv2nSbeQKl9MzjvLlHAlQstflzTXUMgpge72kYm89Ad1b
	 ecVF99eB5J5PY9Ps/9eE4r5OrO1PSwjnKvl07/kCtKS2tRWiUAg1rbe9qLfHfuRnhG
	 fXwnYGnT48zwdJSIERFme7K5pAT+03WR+IQ/XaRo=
Date: Tue, 28 Jul 2026 12:57:41 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-stop-flooding-logs-when-debug_locks-is-set-to-zero-fix.patch added to mm-unstable branch
Message-Id: <20260728195741.993B61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree-stop-flooding-logs-when-debug_locks-is-set-to-zero-fix
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-stop-flooding-logs-when-debug_locks-is-set-to-zero-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-stop-flooding-logs-when-debug_locks-is-set-to-zero-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree-stop-flooding-logs-when-debug_locks-is-set-to-zero-fix
Date: Mon, 20 Jul 2026 17:30:38 -0400

stop flooding logs when debug_locks is set to zero

When lockdep detects an issue, it sets debug_locks to 0 disabling further
reports.  The newly added maple tree sequence counting on locks to detect
errors is not taking this nor the fact that lock_is_held() can return -1
(unknown state) into account.  The resulting action is a flood of logging
of not matching sequence numbers being reported on failure.

__lock_sequnece() will return u32 ~0 when debug_locks is zero, and the
real sequnece count cannot return such a high value as it is less than
32bits.

By always updating the sequence number, regardless of lock state and by
ignoring ~0 value in the sequence number will avoid ever printing a
WARN_ON when this condition is hit.

Link: https://lore.kernel.org/fo5r2xl3fql6gyvjasfvfu4ftugjti2vxg7zskdw7hjeo3xvqm@kk66qmsf762s
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Tested-by: Breno Leitao <leitao@debian.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/lib/maple_tree.c~maple_tree-stop-flooding-logs-when-debug_locks-is-set-to-zero-fix
+++ a/lib/maple_tree.c
@@ -1171,6 +1171,8 @@ static void mas_lock_check(struct ma_sta
 {
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map *map;
+	u32 seq;
+
 	if (!mas_is_active(mas))
 		return;
 
@@ -1182,8 +1184,12 @@ static void mas_lock_check(struct ma_sta
 #endif /* CONFIG_RCU_STRICT_GRACE_PERIOD */
 
 	map = mas_lockdep_map(mas);
-	if (map && lock_is_held(map))
-		WARN_ON_ONCE(mas->ld_seq != lock_sequence(map));
+	if (!map)
+		return;
+
+	seq = lock_sequence(map);
+	if (seq != UINT_MAX && mas->ld_seq != UINT_MAX)
+		WARN_ON_ONCE(mas->ld_seq != seq);
 #endif /* CONFIG_LOCKDEP */
 
 }
@@ -1201,8 +1207,8 @@ static void mas_init_lock_check(struct m
 #endif /* CONFIG_RCU_STRICT_GRACE_PERIOD */
 
 	map = mas_lockdep_map(mas);
-	if (map && lock_is_held(map))
-		mas->ld_seq = lock_sequence(mas_lockdep_map(mas));
+	if (map) /* Update regardless of lock state */
+		mas->ld_seq = lock_sequence(map);
 #endif /* CONFIG_LOCKDEP */
 
 }
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch
locking-lockdep-add-sequence-counter-to-held_lock.patch
maple_tree-add-write-lock-checking-with-lockdep-sequence-numbers.patch
maple_tree-stop-flooding-logs-when-debug_locks-is-set-to-zero-fix.patch
maple_tree-documentation-fix.patch
maple_tree-drop-dead-code-from-mas_extend_spanning_null.patch
maple_tree-drop-maple_alloc_slots.patch
maple_tree-clarify-comments-on-mas_nomem.patch
maple_tree-use-prefetched-value-in-mas_wr_store_type.patch
maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch
maple_tree-micro-optimisation-of-mas_wr_store_type.patch
maple_tree-add-bulk-parent-set-helper.patch
maple_tree-catch-race-in-mas_alloc_cyclic.patch
maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-warn_on_once-when-allocations-fail.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

