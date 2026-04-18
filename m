Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCA336F42D;
	Sat, 18 Apr 2026 07:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498914; cv=none; b=DGaB/znQ31wSaZAQ3OE36RKIxVUT7vUX1cfbJrlqN8MLG15guctVfqraZkPZK5AQx9bLhcf67xeDerT4lEUFokxzug3+2zCT9ThYH6nDT+3wYCpL7KwlZb8Ap2lg5mg0Oz4KpZHPyxlrHam53NYezApDf7nIIkWzNO82Ef1FZoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498914; c=relaxed/simple;
	bh=INN9fD0UBYNZqSrShfsbeP1YLFD+RPP1jRzWQNz2n2M=;
	h=Date:To:From:Subject:Message-Id; b=fsCb5gT9NiPiyKDkTVcqRay9OuhHPYImF8tsQiCKicXgrIAEoH/cdieg7MjIqEEZhhxNN/jsnbz/onV0FmXSBluU72+35ntTMbYwT+vL/HONT6NH4ZDdTJn6t5EjsYrYPX+0tTzEY0OSKVBCxQH72QRq3C2T3R1lUvJbGkD8Cg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PA8v+gPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PA8v+gPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED776C19424;
	Sat, 18 Apr 2026 07:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498914;
	bh=INN9fD0UBYNZqSrShfsbeP1YLFD+RPP1jRzWQNz2n2M=;
	h=Date:To:From:Subject:From;
	b=PA8v+gPRAwLEQoCXwb264Ct4ca835QFgCJGfiZIpxgRkY4AbGH351CdQw8srbLRux
	 clXXy6SERU409GPKXR1TqYjjznZKv2SvYHpvAS46xAI6Y/T4BnmjNEoV9OEMcZ5Z1m
	 W31A93OJOWi1aIKEm9RJhHY9BVq9Ek5287VS0Gko=
Date: Sat, 18 Apr 2026 00:55:09 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,liuyun01@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-fix-memory-leaks-in-weighted_interleave_auto_store.patch removed from -mm tree
Message-Id: <20260418075513.ED776C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: fix memory leaks in weighted_interleave_auto_store()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-memory-leaks-in-weighted_interleave_auto_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jackie Liu <liuyun01@kylinos.cn>
Subject: mm/mempolicy: fix memory leaks in weighted_interleave_auto_store()
Date: Wed, 1 Apr 2026 08:57:02 +0800

weighted_interleave_auto_store() fetches old_wi_state inside the if
(!input) block only.  This causes two memory leaks:

1. When a user writes "false" and the current mode is already manual,
   the function returns early without freeing the freshly allocated
   new_wi_state.

2. When a user writes "true", old_wi_state stays NULL because the
   fetch is skipped entirely. The old state is then overwritten by
   rcu_assign_pointer() but never freed, since the cleanup path is
   gated on old_wi_state being non-NULL. A user can trigger this
   repeatedly by writing "1" in a loop.

Fix both leaks by moving the old_wi_state fetch before the input check,
making it unconditional.  This also allows a unified early return for both
"true" and "false" when the requested mode matches the current mode.

Link: https://lore.kernel.org/20260401005702.7096-1-liu.yun@linux.dev
Link: https://sashiko.dev/#/patchset/20260331100740.84906-1-liu.yun@linux.dev
Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed by: Donet Tom <donettom@linux.ibm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org> # v6.16+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-memory-leaks-in-weighted_interleave_auto_store
+++ a/mm/mempolicy.c
@@ -3700,18 +3700,19 @@ static ssize_t weighted_interleave_auto_
 		new_wi_state->iw_table[i] = 1;
 
 	mutex_lock(&wi_state_lock);
-	if (!input) {
-		old_wi_state = rcu_dereference_protected(wi_state,
-					lockdep_is_held(&wi_state_lock));
-		if (!old_wi_state)
-			goto update_wi_state;
-		if (input == old_wi_state->mode_auto) {
-			mutex_unlock(&wi_state_lock);
-			return count;
-		}
+	old_wi_state = rcu_dereference_protected(wi_state,
+				lockdep_is_held(&wi_state_lock));
+
+	if (old_wi_state && input == old_wi_state->mode_auto) {
+		mutex_unlock(&wi_state_lock);
+		kfree(new_wi_state);
+		return count;
+	}
 
-		memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
-					       nr_node_ids * sizeof(u8));
+	if (!input) {
+		if (old_wi_state)
+			memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
+						       nr_node_ids * sizeof(u8));
 		goto update_wi_state;
 	}
 
_

Patches currently in -mm which might be from liuyun01@kylinos.cn are


