Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C88D361977
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350904; cv=none; b=cEK5OhfpGoJzf5FHC6ZLv2m3eJFflGgF7crn6yMNNyEx+zqKDhPhs6zhNz6JiwjTbRXpcIdq8U6Cp2ykmv5947h5ohI0A2Yc854zWWOIGIcgsxKTWjlbsFyhq6fYM/GQ7FI3HRugs2/Y8Y4N673/sV4gGaK7L5uopmnZytimMvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350904; c=relaxed/simple;
	bh=i9BqkHjNipFI7MGjTK+pmvhwIIHbGkSOHvJN21ulSl0=;
	h=Date:To:From:Subject:Message-Id; b=WHwQFAjeDsQikhMi16j2kqbf5F5HG+kGHFxeZIeSEDVIpzV0sx3DU7NF3Elcweh+wT/YlbP4UkhSveWfDqfTnWwqFPLaDyMPny70hUQNZavZLuUSpplrALa5PQa8kMyd5ka4TDdLUWqRvKj+ODPeoiP0A4X5/OP1KamKJXexLa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a9taR6Hi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a9taR6Hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A291F00A3E;
	Fri, 21 Aug 2026 22:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787350903;
	bh=kQirqErDGmS5osvmG0I0hLicIcWDMvVPzRiWMX1fZdo=;
	h=Date:To:From:Subject;
	b=a9taR6HipG5XqMqAL5bc6thaK8yIjeR2UDC35OT2YoTRcmW6c3r8paDUJNRKsinYT
	 YHflO/E5zb8IE4kiAAg4497Zwh7nLi9PCbMw9hEUBLkR+vmjXyhL/CDhtHDdvpNgg+
	 qichxyKEJsXh7kAACduEM7BbhWlGGw1tFKKG8uGo=
Date: Fri, 21 Aug 2026 15:21:42 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-documentation-fix.patch removed from -mm tree
Message-Id: <20260821222143.34A291F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: documentation fix
has been removed from the -mm tree.  Its filename was
     maple_tree-documentation-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: documentation fix
Date: Tue, 30 Jun 2026 15:08:28 -0400

Don't include the word flag in the quotes with the actual flag.

Link: https://lore.kernel.org/20260630190843.3563858-5-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
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

 Documentation/core-api/maple_tree.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/core-api/maple_tree.rst~maple_tree-documentation-fix
+++ a/Documentation/core-api/maple_tree.rst
@@ -211,7 +211,7 @@ Advanced Locking
 
 The maple tree uses a spinlock by default, but external locks can be used for
 tree updates as well.  To use an external lock, the tree must be initialized
-with the ``MT_FLAGS_LOCK_EXTERN flag``, this is usually done with the
+with the ``MT_FLAGS_LOCK_EXTERN`` flag, this is usually done with the
 MTREE_INIT_EXT() #define, which takes an external lock as an argument.
 
 Functions and structures
_

Patches currently in -mm which might be from liam@infradead.org are

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

