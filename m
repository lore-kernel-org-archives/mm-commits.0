Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585043B05A2
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350903; cv=none; b=duS1IU5nZfm12Bm9/OF4Vlo4YoQPlZ81UyouRM7WMH3Jy13WbNW3b+UyZmYSnFujFLp10xW9o/Og0xpWE/FYcCBu8pzVEJ/lRIzK5aAH4ys7I4GuCv/OlBWV9FZvTaXJGTUUhbDRw+oyomxK3YKI8RY2wA8+UVn3JGXKbb0vuQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350903; c=relaxed/simple;
	bh=NSwJffno3LepxPLdUxUKcgpy94MFVUuYxixncqoCt88=;
	h=Date:To:From:Subject:Message-Id; b=P3qwS6vEJeZLyMvqcb7B7NEjVI+SxhROutP8C+M7nsJXMgoegyL3TP0vbY15IX2Q93vWWzx4EAgr1pg1NOQk/ySPL25vvLtP+lhDmR3FAMdC4axMYZR9Wy4YDNtGP/fUlBgE0qyv3yxTn0QmKHjQoSKus+yP5/VxwWBVM1pTAqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jHZt1VBp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jHZt1VBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C241F00A3A;
	Fri, 21 Aug 2026 22:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787350902;
	bh=TN2DTxmgmeBQkT2eyzX+i5gwBZkE51AJDVSTCoeLm8Y=;
	h=Date:To:From:Subject;
	b=jHZt1VBpXmn3SH8qOqmK9pAhaLgai7p621MLKbwqybNa36YZazsZ7DmcEval4zuph
	 kJrA9uA5E9tMa4XVNPEy/cjT76GvODKFIKi3ldwHhfmz3myS9/nJ8athtrFS/SWTlX
	 s+aptMhnFDKSLypsn5Amxjws6zND6F698PMrZm/k=
Date: Fri, 21 Aug 2026 15:21:41 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-stop-flooding-logs-when-debug_locks-is-set-to-zero-fix.patch removed from -mm tree
Message-Id: <20260821222141.F3C241F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree-stop-flooding-logs-when-debug_locks-is-set-to-zero-fix
has been removed from the -mm tree.  Its filename was
     maple_tree-stop-flooding-logs-when-debug_locks-is-set-to-zero-fix.patch

This patch was dropped because an updated version will be issued

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
@@ -1166,6 +1166,8 @@ static void mas_lock_check(struct ma_sta
 {
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map *map;
+	u32 seq;
+
 	if (!mas_is_active(mas))
 		return;
 
@@ -1177,8 +1179,12 @@ static void mas_lock_check(struct ma_sta
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
@@ -1196,8 +1202,8 @@ static void mas_init_lock_check(struct m
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

