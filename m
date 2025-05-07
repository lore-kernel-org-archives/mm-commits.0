Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC68E22F17B
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 21:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746654223; cv=none; b=Z5ogNsVjcyZPf48EmqKro8xJfKXgtE6sglngSCJ+1ZCrW0Tbcy8i9VNuN/ZyEqDuHPGBwly1QTNGGRTlGoAVrGExZlaKyBj3Qw+OGAPhJVCTySLAuqoRX8TiUXZufkmeDF1PW76dSQc1Y9SEKdSvz3PsUUJ1hvo1irIhaTMkpas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746654223; c=relaxed/simple;
	bh=d8GJ6j/dXi7CKs0WDJm2qotK42kcGrPsJVSq575GpYo=;
	h=Date:To:From:Subject:Message-Id; b=hIA+E5AE3hq2R+A02bpHijSGgLi2HchtUOUGaL6BhmTk3BkfGomORBhDv6CU0u0F7jZReFnOhkUoSsalY2wU7WI6V+vND1AmZNBpz5sVmry+19G/8uakLxPLQYurfMxJd6e+kgEuZ5YUIH9nkzhbac+vgh6SgYQzwCmj2cWiXvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QJ6DoBtH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QJ6DoBtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39872C4CEE2;
	Wed,  7 May 2025 21:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746654223;
	bh=d8GJ6j/dXi7CKs0WDJm2qotK42kcGrPsJVSq575GpYo=;
	h=Date:To:From:Subject:From;
	b=QJ6DoBtHL6UYq89nYrQYOrFDzn/n1HseGTOhPyTwcjEYspyObXasp9kpPNexTcFll
	 olJ7VfRPrYLWzepI6mWkRvWzvw5vfXOaJA9BfLX7lZTXYSds37DBU/wApKmW750uYF
	 WpS0FVvfg7TB9TZu0TOWGsBK3lrNqDsSUZ3OUCFE=
Date: Wed, 07 May 2025 14:43:42 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,iii@linux.ibm.com,elver@google.com,dvyukov@google.com,bvanassche@acm.org,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-apply-clang-format-to-files-mm-kmsan.patch added to mm-new branch
Message-Id: <20250507214343.39872C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: apply clang-format to files mm/kmsan/
has been added to the -mm mm-new branch.  Its filename is
     kmsan-apply-clang-format-to-files-mm-kmsan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-apply-clang-format-to-files-mm-kmsan.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: apply clang-format to files mm/kmsan/
Date: Wed, 7 May 2025 18:00:08 +0200

KMSAN source files are expected to be formatted with clang-format, fix
some nits that slipped in.  No functional change.

Link: https://lkml.kernel.org/r/20250507160012.3311104-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Bart van Assche <bvanassche@acm.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Macro Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c   |    4 ++--
 mm/kmsan/hooks.c  |    4 +---
 mm/kmsan/init.c   |    3 +--
 mm/kmsan/shadow.c |    3 +--
 4 files changed, 5 insertions(+), 9 deletions(-)

--- a/mm/kmsan/core.c~kmsan-apply-clang-format-to-files-mm-kmsan
+++ a/mm/kmsan/core.c
@@ -159,8 +159,8 @@ depot_stack_handle_t kmsan_internal_chai
 	 * Make sure we have enough spare bits in @id to hold the UAF bit and
 	 * the chain depth.
 	 */
-	BUILD_BUG_ON(
-		(1 << STACK_DEPOT_EXTRA_BITS) <= (KMSAN_MAX_ORIGIN_DEPTH << 1));
+	BUILD_BUG_ON((1 << STACK_DEPOT_EXTRA_BITS) <=
+		     (KMSAN_MAX_ORIGIN_DEPTH << 1));
 
 	extra_bits = stack_depot_get_extra_bits(id);
 	depth = kmsan_depth_from_eb(extra_bits);
--- a/mm/kmsan/hooks.c~kmsan-apply-clang-format-to-files-mm-kmsan
+++ a/mm/kmsan/hooks.c
@@ -114,9 +114,7 @@ void kmsan_kfree_large(const void *ptr)
 	kmsan_enter_runtime();
 	page = virt_to_head_page((void *)ptr);
 	KMSAN_WARN_ON(ptr != page_address(page));
-	kmsan_internal_poison_memory((void *)ptr,
-				     page_size(page),
-				     GFP_KERNEL,
+	kmsan_internal_poison_memory((void *)ptr, page_size(page), GFP_KERNEL,
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
 }
--- a/mm/kmsan/init.c~kmsan-apply-clang-format-to-files-mm-kmsan
+++ a/mm/kmsan/init.c
@@ -35,8 +35,7 @@ static void __init kmsan_record_future_s
 	KMSAN_WARN_ON(future_index == NUM_FUTURE_RANGES);
 	KMSAN_WARN_ON((nstart >= nend) ||
 		      /* Virtual address 0 is valid on s390. */
-		      (!IS_ENABLED(CONFIG_S390) && !nstart) ||
-		      !nend);
+		      (!IS_ENABLED(CONFIG_S390) && !nstart) || !nend);
 	nstart = ALIGN_DOWN(nstart, PAGE_SIZE);
 	nend = ALIGN(nend, PAGE_SIZE);
 
--- a/mm/kmsan/shadow.c~kmsan-apply-clang-format-to-files-mm-kmsan
+++ a/mm/kmsan/shadow.c
@@ -207,8 +207,7 @@ void kmsan_free_page(struct page *page,
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
 	kmsan_enter_runtime();
-	kmsan_internal_poison_memory(page_address(page),
-				     page_size(page),
+	kmsan_internal_poison_memory(page_address(page), page_size(page),
 				     GFP_KERNEL,
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
_

Patches currently in -mm which might be from glider@google.com are

kmsan-apply-clang-format-to-files-mm-kmsan.patch
kmsan-fix-usage-of-kmsan_enter_runtime-in-kmsan_vmap_pages_range_noflush.patch
kmsan-drop-the-declaration-of-kmsan_save_stack.patch
kmsan-enter-the-runtime-around-kmsan_internal_memmove_metadata-call.patch
kmsan-rework-kmsan_in_runtime-handling-in-kmsan_report.patch

