Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EF822F17B
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 21:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746654225; cv=none; b=AOq0uh81JrV5EO8DW8Jwg2H8bagtBKCrytSySLKpb32U+cMxF6/VARoSr6MlILenRFmpoxxtl1FDk/jMH5vRr8de/6mNccGffG0RYlNjbyxXoPCd57PnPuY/X+v3pf6Lc6c/azFEQ6fiLp53c9ZUi4O/BpkicGn1jSdxwCj0WFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746654225; c=relaxed/simple;
	bh=3Z16QOfEEVl5GpenyWibkI+ReviEr7eYknltR7cMGBc=;
	h=Date:To:From:Subject:Message-Id; b=k1JBQPWSGAFwkYCZWM0Cq/NA8J4lI0w1kiiDVECzo/rykqDvHJvI5Fy9EbDBy8BMxUXrLL8ssSybVjWJYcR5XW0fzOlIuZxqRBQIT/57llRUFF8RYkRe8jsankyK1YvdQxumPiyM8bB/05VLEZXLFopox5V3jEtTtxi6BIamORo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m/ZC882G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m/ZC882G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09068C4CEE2;
	Wed,  7 May 2025 21:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746654225;
	bh=3Z16QOfEEVl5GpenyWibkI+ReviEr7eYknltR7cMGBc=;
	h=Date:To:From:Subject:From;
	b=m/ZC882GXa4E2Px9zCtDyXgktAVPcT5XIJZPjg5WPFKV1A1F3VlfZ8nDnRidhjcsQ
	 +h1ZziymOyDFKGKxnkC949QNQcx4DYb/mV0PGFF6Q0uthHn+SGjtZvunU+NPCWOBAb
	 Y3WjOablHo24JF6J0yt8emwSOvrxbD4+WJ0m3zYU=
Date: Wed, 07 May 2025 14:43:44 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,iii@linux.ibm.com,elver@google.com,dvyukov@google.com,bvanassche@acm.org,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-fix-usage-of-kmsan_enter_runtime-in-kmsan_vmap_pages_range_noflush.patch added to mm-new branch
Message-Id: <20250507214345.09068C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: fix usage of kmsan_enter_runtime() in kmsan_vmap_pages_range_noflush()
has been added to the -mm mm-new branch.  Its filename is
     kmsan-fix-usage-of-kmsan_enter_runtime-in-kmsan_vmap_pages_range_noflush.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-fix-usage-of-kmsan_enter_runtime-in-kmsan_vmap_pages_range_noflush.patch

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
Subject: kmsan: fix usage of kmsan_enter_runtime() in kmsan_vmap_pages_range_noflush()
Date: Wed, 7 May 2025 18:00:09 +0200

Only enter the runtime to call __vmap_pages_range_noflush(), so that error
handling does not skip kmsan_leave_runtime().

This bug was spotted by CONFIG_WARN_CAPABILITY_ANALYSIS=y

Link: https://lkml.kernel.org/r/20250507160012.3311104-2-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/shadow.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/kmsan/shadow.c~kmsan-fix-usage-of-kmsan_enter_runtime-in-kmsan_vmap_pages_range_noflush
+++ a/mm/kmsan/shadow.c
@@ -247,17 +247,19 @@ int kmsan_vmap_pages_range_noflush(unsig
 	kmsan_enter_runtime();
 	mapped = __vmap_pages_range_noflush(shadow_start, shadow_end, prot,
 					    s_pages, page_shift);
+	kmsan_leave_runtime();
 	if (mapped) {
 		err = mapped;
 		goto ret;
 	}
+	kmsan_enter_runtime();
 	mapped = __vmap_pages_range_noflush(origin_start, origin_end, prot,
 					    o_pages, page_shift);
+	kmsan_leave_runtime();
 	if (mapped) {
 		err = mapped;
 		goto ret;
 	}
-	kmsan_leave_runtime();
 	flush_tlb_kernel_range(shadow_start, shadow_end);
 	flush_tlb_kernel_range(origin_start, origin_end);
 	flush_cache_vmap(shadow_start, shadow_end);
_

Patches currently in -mm which might be from glider@google.com are

kmsan-apply-clang-format-to-files-mm-kmsan.patch
kmsan-fix-usage-of-kmsan_enter_runtime-in-kmsan_vmap_pages_range_noflush.patch
kmsan-drop-the-declaration-of-kmsan_save_stack.patch
kmsan-enter-the-runtime-around-kmsan_internal_memmove_metadata-call.patch
kmsan-rework-kmsan_in_runtime-handling-in-kmsan_report.patch

