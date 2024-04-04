Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711BB7492
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 01:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712195750; cv=none; b=Au20rmujJHP6jnYbL02T+EAQIq3N+HrmtW+SgTgtW/8LTNq8ZagXZDjMycXoeEG58CxaZVQEix18f2/XMVY0OUN2dLoSFreJ7X/tK9tc+rkFZbokwlvvaWHq7nQO8RQLQMMrZtoWQssDNaGYT0d/KpjLgNdNHCX1n5g5pzjRtA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712195750; c=relaxed/simple;
	bh=AMOVd0uOjyaQ5+GiV9z2w9GDxMUwEQmXKk2Sgx5cYfc=;
	h=Date:To:From:Subject:Message-Id; b=KMQ8gzH+f9OyFA+ui3YFDvokbvyVpWMiCJDiqk0G/fWuXvxB7RKzJfrNPJfZuZ2ohzvD2zx/n9N/8+4SqlPkOmiuLk5c7cyib31uiSOtBpSj8RzCdWHcJK166MoGn61HHQm3/j3mQHOLRhOkglmglqOCjTrKtFL3MNkbR07520E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z2r+b3ya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z2r+b3ya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EE6C433C7;
	Thu,  4 Apr 2024 01:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712195750;
	bh=AMOVd0uOjyaQ5+GiV9z2w9GDxMUwEQmXKk2Sgx5cYfc=;
	h=Date:To:From:Subject:From;
	b=z2r+b3yapfZ9TGpePyxqYz/ZTpb6dV9d+2e7ODAob0ZqTCeNtHpNvyBX7bMGn7Dt0
	 3sNccHC3fRGJ7Di1yY5pTDkNGYS25t4E7MZ/7pxpaBtBCCcAwybdct6OBXK/rxdZCe
	 PsC84E9fwBaH68DJIju4Q8+TEhMKrBaodu/9H2SM=
Date: Wed, 03 Apr 2024 18:55:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osandov@fb.com,osalvador@suse.de,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,pcc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + stackdepot-rename-pool_index-to-pool_index_plus_1.patch added to mm-unstable branch
Message-Id: <20240404015549.E6EE6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: stackdepot: rename pool_index to pool_index_plus_1
has been added to the -mm mm-unstable branch.  Its filename is
     stackdepot-rename-pool_index-to-pool_index_plus_1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/stackdepot-rename-pool_index-to-pool_index_plus_1.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peter Collingbourne <pcc@google.com>
Subject: stackdepot: rename pool_index to pool_index_plus_1
Date: Mon, 1 Apr 2024 17:14:58 -0700

Commit 3ee34eabac2a ("lib/stackdepot: fix first entry having a 0-handle")
changed the meaning of the pool_index field to mean "the pool index plus
1".  This made the code accessing this field less self-documenting, as
well as causing debuggers such as drgn to not be able to easily remain
compatible with both old and new kernels, because they typically do that
by testing for presence of the new field.  Because stackdepot is a
debugging tool, we should make sure that it is debugger friendly. 
Therefore, give the field a different name to improve readability as well
as enabling debugger backwards compatibility.

Link: https://lkml.kernel.org/r/20240402001500.53533-1-pcc@google.com
Link: https://linux-review.googlesource.com/id/Ib3e70c36c1d230dd0a118dc22649b33e768b9f88
Signed-off-by: Peter Collingbourne <pcc@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Omar Sandoval <osandov@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    7 +++----
 lib/stackdepot.c           |    4 ++--
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/include/linux/stackdepot.h~stackdepot-rename-pool_index-to-pool_index_plus_1
+++ a/include/linux/stackdepot.h
@@ -44,10 +44,9 @@ typedef u32 depot_stack_handle_t;
 union handle_parts {
 	depot_stack_handle_t handle;
 	struct {
-		/* pool_index is offset by 1 */
-		u32 pool_index	: DEPOT_POOL_INDEX_BITS;
-		u32 offset	: DEPOT_OFFSET_BITS;
-		u32 extra	: STACK_DEPOT_EXTRA_BITS;
+		u32 pool_index_plus_1	: DEPOT_POOL_INDEX_BITS;
+		u32 offset		: DEPOT_OFFSET_BITS;
+		u32 extra		: STACK_DEPOT_EXTRA_BITS;
 	};
 };
 
--- a/lib/stackdepot.c~stackdepot-rename-pool_index-to-pool_index_plus_1
+++ a/lib/stackdepot.c
@@ -330,7 +330,7 @@ static struct stack_record *depot_pop_fr
 	stack = current_pool + pool_offset;
 
 	/* Pre-initialize handle once. */
-	stack->handle.pool_index = pool_index + 1;
+	stack->handle.pool_index_plus_1 = pool_index + 1;
 	stack->handle.offset = pool_offset >> DEPOT_STACK_ALIGN;
 	stack->handle.extra = 0;
 	INIT_LIST_HEAD(&stack->hash_list);
@@ -441,7 +441,7 @@ static struct stack_record *depot_fetch_
 	const int pools_num_cached = READ_ONCE(pools_num);
 	union handle_parts parts = { .handle = handle };
 	void *pool;
-	u32 pool_index = parts.pool_index - 1;
+	u32 pool_index = parts.pool_index_plus_1 - 1;
 	size_t offset = parts.offset << DEPOT_STACK_ALIGN;
 	struct stack_record *stack;
 
_

Patches currently in -mm which might be from pcc@google.com are

stackdepot-rename-pool_index-to-pool_index_plus_1.patch

