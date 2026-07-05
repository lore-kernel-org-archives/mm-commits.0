Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B73F35F191
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 07:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783236718; cv=none; b=O3kV6u7VbQpbr8yJYrcMSS569+nLgsSNhkOkKiM/5smH35iRA3z2Na+kLf7RpCGfNIPIbQUgelJ9QnCd+J+ahDjdQj8jcpmZnjov+m3abHod4plF+IDJP2+9Sz4mXfoE3WzWQyupHObhRvAm+FY8Odccj3bv78Bf0IjsCwcRnnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783236718; c=relaxed/simple;
	bh=CByZ/YNuT2zfLmQ05CiHtQc/gOYeozhYP8w6KDaNL5E=;
	h=Date:To:From:Subject:Message-Id; b=Fxb89F5VApP5eNc4eVSygo9ZeWlYN6rsMeYBvtEHfBP35YBZzgaN0oeFF4j6VLVi1IGtWKtUKRIPTqCbsnMBwSREBrFZiXZXUSf8opYeSa/LaWhW/mQhXbiWiWYtlHlQZh+r4DgSwgDAAppQpQ5rdfzhevbOm/e/jKWvZ7wlxx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y8kCo6FD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y8kCo6FD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB0D1F000E9;
	Sun,  5 Jul 2026 07:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783236716;
	bh=pqMd9d79ZWcFqIzmUbwwPPXIy42pt+es93o46At2mMU=;
	h=Date:To:From:Subject;
	b=y8kCo6FDmlUvPqMWPmlYppf1DM4YFfGnyFV/vuK1XJZD51hBy5kmLH+L4GD6hx9cA
	 Umt5D/Fo6k5kxfrwjYzMJtKbu9QMcN6/xH/a+r7gkL/JKzl4dRnOeMpo/gk5XWAISR
	 lz6iz0uPdgahiAJbUCkF3ao5rTzYDTEpdhYxzPoA=
Date: Sun, 05 Jul 2026 00:31:56 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-__gfp_no_obj_ext-flag.patch added to mm-new branch
Message-Id: <20260705073156.CBB0D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove the __GFP_NO_OBJ_EXT flag
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-the-__gfp_no_obj_ext-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-__gfp_no_obj_ext-flag.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: mm: remove the __GFP_NO_OBJ_EXT flag
Date: Fri, 03 Jul 2026 12:31:56 +0000

All users of the flag are converted to SLAB_ALLOC_NO_RECURSE or
ALLOC_NO_CODETAG (from __GFP_NO_CODETAG which reused the NO_OBJ_EXT bit). 
Free up the flag bit.

[Rebased onto __GFP_NO_CODETAG removal]
Link: https://lore.kernel.org/20260703-alloc-trylock-v5-16-c87b714e19d3@google.com
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp_types.h       |    7 -------
 include/trace/events/mmflags.h  |   10 +---------
 tools/include/linux/gfp_types.h |    7 -------
 3 files changed, 1 insertion(+), 23 deletions(-)

--- a/include/linux/gfp_types.h~mm-remove-the-__gfp_no_obj_ext-flag
+++ a/include/linux/gfp_types.h
@@ -55,7 +55,6 @@ enum {
 #ifdef CONFIG_LOCKDEP
 	___GFP_NOLOCKDEP_BIT,
 #endif
-	___GFP_NO_OBJ_EXT_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -96,7 +95,6 @@ enum {
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
-#define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -138,17 +136,12 @@ enum {
  *
  * %__GFP_ACCOUNT causes the allocation to be accounted to the active
  * cgroup context.
- *
- * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
- * mark_obj_codetag_empty() should be called upon freeing for objects allocated
- * with this flag to indicate that their NULL tags are expected and normal.
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
 #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
 #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
-#define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
 
 /**
  * DOC: Watermark modifiers
--- a/include/trace/events/mmflags.h~mm-remove-the-__gfp_no_obj_ext-flag
+++ a/include/trace/events/mmflags.h
@@ -54,18 +54,10 @@
 # define TRACE_GFP_FLAGS_LOCKDEP
 #endif
 
-#ifdef CONFIG_SLAB_OBJ_EXT
-# define TRACE_GFP_FLAGS_SLAB			\
-	TRACE_GFP_EM(NO_OBJ_EXT)
-#else
-# define TRACE_GFP_FLAGS_SLAB
-#endif
-
 #define TRACE_GFP_FLAGS				\
 	TRACE_GFP_FLAGS_GENERAL			\
 	TRACE_GFP_FLAGS_KASAN			\
-	TRACE_GFP_FLAGS_LOCKDEP			\
-	TRACE_GFP_FLAGS_SLAB
+	TRACE_GFP_FLAGS_LOCKDEP
 
 #undef TRACE_GFP_EM
 #define TRACE_GFP_EM(a) TRACE_DEFINE_ENUM(___GFP_##a##_BIT);
--- a/tools/include/linux/gfp_types.h~mm-remove-the-__gfp_no_obj_ext-flag
+++ a/tools/include/linux/gfp_types.h
@@ -55,7 +55,6 @@ enum {
 #ifdef CONFIG_LOCKDEP
 	___GFP_NOLOCKDEP_BIT,
 #endif
-	___GFP_NO_OBJ_EXT_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -96,7 +95,6 @@ enum {
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
-#define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -137,17 +135,12 @@ enum {
  * node with no fallbacks or placement policy enforcements.
  *
  * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
- *
- * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
- * mark_obj_codetag_empty() should be called upon freeing for objects allocated
- * with this flag to indicate that their NULL tags are expected and normal.
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
 #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
 #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
-#define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
 
 /**
  * DOC: Watermark modifiers
_

Patches currently in -mm which might be from vbabka@kernel.org are

mm-remove-the-__gfp_no_obj_ext-flag.patch

