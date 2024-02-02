Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660397763F
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706875964; cv=none; b=WFgwQphwNpq70VDN+I2KasPVsMVTeiIb2RdgQRb1i7mmgpN696B1Ets13HNXMljzds7BwIOwioguhedd0r9e0dif2gxMg1VanECPKmH7tYrvaUTUvRiJHr66LYzfNQ7x/TgUjF2lKojYp0iDCAipMcq5kWyipKxH/T3p+OyFpxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706875964; c=relaxed/simple;
	bh=GAGcp5cONYvksISDM3zFLuXmdp7i4GK1ldwu/+q4Bh8=;
	h=Date:To:From:Subject:Message-Id; b=PZ9OOXZ5PD34ffnkAzNZoGbEUwTGD9tk0021LNxuoYMdRXdEYU7y4Ht6p2c29L4cDK6in2krUZCkS0PVD/9uVcarhAflkV6QNhnQhqxC+OLdg3kGHgZ4uECueMaA57Ysn9kVG5h3NQMAEV9hyUiN/uJgawR9QCxuDGebotSVy2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xOYKlHRv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xOYKlHRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BDBC433F1;
	Fri,  2 Feb 2024 12:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706875963;
	bh=GAGcp5cONYvksISDM3zFLuXmdp7i4GK1ldwu/+q4Bh8=;
	h=Date:To:From:Subject:From;
	b=xOYKlHRv77P0/q67rD2sBpVeEbamGibAACXXMQIx2JzhfI+D8+7iFv3lMedEvlRSQ
	 Tag9S9QQqcxwZ/0G1XpOVc6p46SQZdhNkEtVYrky3fntO6W4LydU58m1BwAy7v0BgH
	 2m4eS0kxVpjMGx1ZbvidJJJfMaVwLWDcf8R/unno=
Date: Fri, 02 Feb 2024 04:12:41 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,andreyknvl@gmail.com,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + stackdepot-use-variable-size-records-for-non-evictable-entries-fix.patch added to mm-unstable branch
Message-Id: <20240202121243.80BDBC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: stackdepot: fix -Wstringop-overflow warning
has been added to the -mm mm-unstable branch.  Its filename is
     stackdepot-use-variable-size-records-for-non-evictable-entries-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/stackdepot-use-variable-size-records-for-non-evictable-entries-fix.patch

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
stackdepot-use-variable-size-records-for-non-evictable-entries-fix.patch
kasan-revert-eviction-of-stack-traces-in-generic-mode.patch

