Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC6833937A
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465814; cv=none; b=NUFlrOrm+1rrzjPuefdGbGoSQpkO0iiskIZhnCOpM0ZodTED6tGoZZd3uKH7TRUg6eHSZPrnxcVug1+yZUMCccmgbf1Ty6djfJLJuzHLwTjNN/6659mVoNlXyW6srh71qbSi/MZv+5PG6tH2gin6qZ1u6RE/kdSAVqM59c1wMuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465814; c=relaxed/simple;
	bh=uRpH7fwx77Vs6bb9ugpR+TRETWUG37Fd9Lx4Fwg84iw=;
	h=Date:To:From:Subject:Message-Id; b=rlddWSF6tdM7v45UxpV5aNqBhUSkPh0SUsuWusQujZoo75zYDLk7HlCI5CqwKCLN6+M6JKgJFCxWTadO92ePiaDlxUO67rqMGwGzMQaIVtwBRw8ToGkTkvqu6BkGbUOSN6ZI9Tk1Zmen7HCfB1pdXomcaUhFvrKeNDELtpaVzms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lc5oJrgS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lc5oJrgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322D11F00A3A;
	Fri, 31 Jul 2026 02:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465813;
	bh=H3toU7gOiYAtkstBZMNW3BLgtcXQlA6Xd7MwiMChT2I=;
	h=Date:To:From:Subject;
	b=lc5oJrgSFlLV0isa47CWKVCqEgbGFBV932DGKkbJ5kf5APwbXAkfnTrqkjXK0Xlmq
	 vlTzhPXcoTa6iXOQ07QLwoz1wCXYiBBLin4sVMpOYg+fyUHqVy1AQg/KrgMeFnnG3U
	 P37NtvPtTbuyPvFsubu5iYoIdiBIum/Icfm1is2U=
Date: Thu, 30 Jul 2026 19:43:32 -0700
To: mm-commits@vger.kernel.org,jackmanb@google.com,hao.ge@linux.dev,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-the-__gfp_no_obj_ext-flag.patch removed from -mm tree
Message-Id: <20260731024333.322D11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove the __GFP_NO_OBJ_EXT flag
has been removed from the -mm tree.  Its filename was
     mm-remove-the-__gfp_no_obj_ext-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Hao Ge <hao.ge@linux.dev>
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

mm-page_alloc-move-capture_control-to-the-page-allocator.patch

