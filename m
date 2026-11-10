Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794292674;
	b=ieYCEZ4b80hCPp4W3oeoq72SOCYoQ1YUue8CwXL1mpqVRAcJKanNGNAVriqkePR72a1h
	 gpqCHlmtUoF4RKngYG1q2m5IUhT7r/iY71xh+uGja+ph9d/VuA7pxx0qvztjy8570Ly7q
	 leqbDZN+W2c84xEYom9p+tEDMnO2jZpmqf0syAq3fS0D2yIMdC/nWSsHosSVjFX3bWpED
	 bx+Ng+2fcDsnl0PM7CHjPYNlYwy1vVVi9C4tZgFjw74NUQE7dAwKn3DqXLHB86eIkAYiw
	 0Pz1XzQ8GABiZNZDrbAVUPsLnvgz7LJFxvjoWhMa3jEi38r/9ut18Eq1GARa0OYojUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794292674;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=auMC/qwKOxZoYEgxdsCmkn9y7e9YRUdPtOSfDkxeAvw=;
	b=nt7ERxoQvXB33RgP5hMZkq+DW5J9PTXQp86X/B7se+wypoyIQ1KVTc2Fq4aaUngfVBVY
	 l6Y0ajcRCOhN9g4b9En7QxUSsLDGbIW1syNuCJaGTPFGrGTAG/1U4TFS+ovvg9gkf6GgZ
	 y3l5MPf+NtAiz7f31Yiq6sKLQUeqSk0DQQopMsbz4+pxgQPm+WApcmOz6nrcObmdw+u2G
	 bKKfKBRnRMLGVYqFcZdA2zIjUrWT4JiymIrT0gaNj0BT9eYVcSWpKmOT7eO9B1FN8sqk2
	 DAwGUbO6KqbDH4+ZDbk2FxeE5xoKlmoL1pnLL4Hr/mHY5SomiFl1mHUUIyDtNMahrOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DDfOjFd+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCA0606A31C
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 06:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DDfOjFd+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B2F1F0089F;
	Tue, 10 Nov 2026 06:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794292673;
	bh=auMC/qwKOxZoYEgxdsCmkn9y7e9YRUdPtOSfDkxeAvw=;
	h=Date:To:From:Subject;
	b=DDfOjFd+fJxBVJLCxpEuOvsQRTyoMq1r03lxdFlHleIdZSLJfdfAqfq7nAhebsIDj
	 4JvQ3jq2bUXnbIhShqpxnnYQGDSL1EdIcQubSBcI7dieAPOFiBmmikKMkgJLfGmNWM
	 eOqqdUUHqa+GkEqQZ4KmjS/0SxwoBBSt+se3YjGY=
Date: Mon, 09 Nov 2026 22:37:52 -0800
To: mm-commits@vger.kernel.org,mason@kernel.org,ljs@kernel.org,
	liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple_tree-fix-reverse-iterator-state-when-the-root-disappears.patch removed from -mm tree
Message-Id: <20261110063753.35B2F1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: maple_tree: fix reverse iterator state when the root disappears
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-reverse-iterator-state-when-the-root-disappears.patch

This patch was dropped because it was folded into maple_tree-fix-rcu-reader-null-dereference-after-the-tree-is-emptied.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple_tree: fix reverse iterator state when the root disappears
Date: Tue, 03 Nov 2026 04:28:56 +0000

A reverse walk restarting from a dead node can observe a direct root entry
in mas_rewalk() and then an empty root in mas_prev_no_node().  The second
root read returns NULL, but leaves the iterator in ma_root with index and
last both zero.

Consequently, mas_prev_range() and mas_find_range_rev() can report an
empty range of [0, 0] instead of [0, ULONG_MAX].  A subsequent forward
range walk starts at index 1, omitting index 0 from the empty range.

Set ma_none and extend last to ULONG_MAX when the second root read returns
NULL.  Keep the existing encoded-node retry in mas_prev_slot() for a root
that has grown into a node again.

A deterministic userspace Maple test reproduces the stale state through
both reverse range APIs before this change and checks the full empty range
afterwards, including a subsequent forward walk.

Link: https://lore.kernel.org/20261104104137.2058705ac29734a7ab5666c1@linux-foundation.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/sashiko-outbox-194509@kernel.org
Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Chris Mason <mason@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
---

 lib/maple_tree.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-reverse-iterator-state-when-the-root-disappears
+++ a/lib/maple_tree.c
@@ -3930,6 +3930,8 @@ static inline void *mas_next_no_node(str
 static inline void *mas_prev_no_node(struct ma_state *mas, unsigned long index,
 		unsigned long min)
 {
+	void *entry;
+
 	mas->index = 0;
 	if (mas_is_none(mas)) {
 		mas->last = ULONG_MAX;
@@ -3940,7 +3942,13 @@ static inline void *mas_prev_no_node(str
 	if (!index || min)
 		return NULL;
 
-	return mas_root(mas);
+	entry = mas_root(mas);
+	if (!entry) {
+		mas->status = ma_none;
+		mas->last = ULONG_MAX;
+	}
+
+	return entry;
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mempolicy-use-one-node-set-for-interleave-weights.patch
maple_tree-fix-rcu-reader-null-dereference-after-the-tree-is-emptied.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
mm-migrate_device-allocate-deferred-split-sublists-for-new-huge-folios.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

