Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BF1EC7
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737687; cv=none; b=SjqmgskNj/aIuf9jkRwdhDPh1ExA2RbwCUmzMPG3qV2KvPSo9HsQbiLdsULTNq/QswtncRekxl1DWOdAxGxUYLaBWoQM2VDVFaHSisWOd3mL9AgMabCcV7ColZyra1Gjz9WZ2LXV+sIjXwR6wU56JY1wGrpUjClmewLx5pUlK8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737687; c=relaxed/simple;
	bh=PGwT/SV5D2vG2WtjJ+m8vHTqbV7D8ERA3wuuVED1Gts=;
	h=Date:To:From:Subject:Message-Id; b=OIyoc/ORN/IlqsmWn99nDTlYNCA1oGmFlL/zDLUNuOT3kOr75nRpnaagvHxz5l+W4ibBQPR8PimhK78ab/tKW2E+FvlS9KAXJeVisJm8a05TnhRo+GFDXxA0uvoD4asZlBj0hF+GCyv+xhhJqTkJneJfScFpYCKZcDOIEdtUxuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sxm5RB+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sxm5RB+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797C3C433C7;
	Sat, 24 Feb 2024 01:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708737686;
	bh=PGwT/SV5D2vG2WtjJ+m8vHTqbV7D8ERA3wuuVED1Gts=;
	h=Date:To:From:Subject:From;
	b=Sxm5RB+TsGt1qK0NGlzDt4/Beq1VtJtmStVBeg7c3AT7fBuNIFp861/yTnz96dAqs
	 yJ8hxcPGR3WDTY/ftc1fXUtu4ZHECM8dqYLBtZ/NXbnAjwTmjFjZ+9IdRVVIcva+hM
	 xl6Ox7al0ATKSvCkiGLy2YXZtdk53tlmR2HRdb2E=
Date: Fri, 23 Feb 2024 17:21:25 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,andreyknvl@gmail.com,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] stackdepot-use-variable-size-records-for-non-evictable-entries-fix.patch removed from -mm tree
Message-Id: <20240224012126.797C3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: stackdepot: fix -Wstringop-overflow warning
has been removed from the -mm tree.  Its filename was
     stackdepot-use-variable-size-records-for-non-evictable-entries-fix.patch

This patch was dropped because it was folded into stackdepot-use-variable-size-records-for-non-evictable-entries.patch

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: stackdepot: fix -Wstringop-overflow warning
Date: Thu, 1 Feb 2024 10:04:30 +0100

Since 113a61863ecb ("Makefile: Enable -Wstringop-overflow globally")
string overflow checking is enabled by default. Within stackdepot, the
compiler (GCC 13.2.0) assumes that a multiplication overflow may be
possible and flex_array_size() can return SIZE_MAX (4294967295 on
32-bit), resulting in this warning:

 In function 'depot_alloc_stack',
     inlined from 'stack_depot_save_flags' at lib/stackdepot.c:688:4:
 arch/x86/include/asm/string_32.h:150:25: error: '__builtin_memcpy' specified bound 4294967295 exceeds maximum object size 2147483647 [-Werror=stringop-overflow=]
   150 | #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
 lib/stackdepot.c:459:9: note: in expansion of macro 'memcpy'
   459 |         memcpy(stack->entries, entries, flex_array_size(stack, entries, nr_entries));
       |         ^~~~~~
 cc1: all warnings being treated as errors

This is due to depot_alloc_stack() accepting an 'int nr_entries' which
could be negative without deeper analysis of callers.

The call to depot_alloc_stack() from stack_depot_save_flags(), however,
only passes in its nr_entries which is unsigned int. Fix the warning by
switching depot_alloc_stack()'s nr_entries to also be unsigned.

Link: https://lore.kernel.org/all/20240201135747.18eca98e@canb.auug.org.au/
Link: https://lkml.kernel.org/r/20240201090434.1762340-1-elver@google.com
Link: https://lore.kernel.org/all/CABXGCsOzpRPZGg23QqJAzKnqkZPKzvieeg=W7sgjgi3q0pBo0g@mail.gmail.com/
Fixes: d869d3fb362c ("stackdepot: use variable size records for non-evictable entries")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/stackdepot.c~stackdepot-use-variable-size-records-for-non-evictable-entries-fix
+++ a/lib/stackdepot.c
@@ -420,7 +420,7 @@ static inline size_t depot_stack_record_
 
 /* Allocates a new stack in a stack depot pool. */
 static struct stack_record *
-depot_alloc_stack(unsigned long *entries, int nr_entries, u32 hash, depot_flags_t flags, void **prealloc)
+depot_alloc_stack(unsigned long *entries, unsigned int nr_entries, u32 hash, depot_flags_t flags, void **prealloc)
 {
 	struct stack_record *stack = NULL;
 	size_t record_size;
_

Patches currently in -mm which might be from elver@google.com are

stackdepot-use-variable-size-records-for-non-evictable-entries.patch
kasan-revert-eviction-of-stack-traces-in-generic-mode.patch

