Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4AB172776
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 18:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712341337; cv=none; b=DNv9IVEOyvv51pDREaEzyhnVfaBMlinDiOliLCn9mB95Rd6QqdEs4gA3yBK+7Hn4lF/MCSAAV+P8XFO7Q3B+odCOISvSlV4cSoepURwyw243Y7DNUmR3Em6w0HDzkUQtC509WTkIDwsJlFW5PnYBOO0O+gzWVMu/KsDsLZG2akc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712341337; c=relaxed/simple;
	bh=fp0Jz7UMHUdyY9JQ/11zDio3MrQzJzEfNL2mb9tivnI=;
	h=Date:To:From:Subject:Message-Id; b=e+DJFmu90dKc2DILH/yNWd9MezCNhjK0LgDAAFY0xdVBMPizEFMW6KZq9KVlO/+rklM1/HvC1RR8KdjffY25YDbiaBDJQB2jp8cY84w8Jn577enplwBNG9DngI1MVgp186cfDqVOEugbGIL4zEMooHOHUdcD/awNPJiUUSgsf0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2DhnlHvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2DhnlHvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00942C433C7;
	Fri,  5 Apr 2024 18:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712341337;
	bh=fp0Jz7UMHUdyY9JQ/11zDio3MrQzJzEfNL2mb9tivnI=;
	h=Date:To:From:Subject:From;
	b=2DhnlHvlsEGiFWEUMMYac0GNS2sh4OV6D+yl0Muep7drXnLw6LvgOTHdoQmtrHJrq
	 O+FgQGJ8ekDA9x30tteHa3BlZ1uo9yf49pHOqUPS4scr3bV+hhex8eUccyLGJMlfaM
	 Bc4L/PxUTtOi57CtLXtjSJvmAyhf6kAmErNYt41E=
Date: Fri, 05 Apr 2024 11:22:16 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osandov@fb.com,osalvador@suse.de,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,pcc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] stackdepot-rename-pool_index-to-pool_index_plus_1.patch removed from -mm tree
Message-Id: <20240405182217.00942C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: stackdepot: rename pool_index to pool_index_plus_1
has been removed from the -mm tree.  Its filename was
     stackdepot-rename-pool_index-to-pool_index_plus_1.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

This is needed in 6.9, which would otherwise become an odd release with
the new semantics and old name so debuggers wouldn't recognize the new
semantics there.

Fixes: 3ee34eabac2a ("lib/stackdepot: fix first entry having a 0-handle")
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


