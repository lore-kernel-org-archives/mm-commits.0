Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930101EDA06
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846608; cv=none; b=C8P6ndvsoqiYvyHhdEfegEzDD3SxBOsEiNHY4TM0dxTZlVo/ZWY4QK4arTZAOtgyKIsGqXrHTMbjZg/4dL7UYHzvKXHA75NqIT1YRfYot0b145jqeiFreb7TtNfzPRVltgNH3M7Okhdg3KMe/jgq6+eTd0jicZQQyL/7pyj4maE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846608; c=relaxed/simple;
	bh=Gw9e8iL00CM0CuBHyUFm4qWHypjCLhhLz5415zY+CrE=;
	h=Date:To:From:Subject:Message-Id; b=X7ywthrmgSm8HVwQxiB9sPhS2fWktkoN7gljntqtFPEPq2fpLBrIeRi0YQ5SzoPSgbNfF0tpsM9qwZIM3pxP6AsTkI6F9IZgNRw5DBhbFPThpPfJsJINjHaEunOOi4wEqRtiJyHpX6h3adloPY2zJf58Dh//e89lXFdssCim/jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gd0FcnwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gd0FcnwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE481C4CEE4;
	Wed, 21 May 2025 16:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846608;
	bh=Gw9e8iL00CM0CuBHyUFm4qWHypjCLhhLz5415zY+CrE=;
	h=Date:To:From:Subject:From;
	b=Gd0FcnwIawyAy1rNi8Zax8GPV8rPj/5C2SjsRkj0sXC9TLneAcdj5NIMwJZ7D7N4k
	 uL4s4zh6NPEAI9Zlry2GYJ7hoJn8K9Cmdif7VeZyCTdr9WhS6PD4WiRne4icKGsbyX
	 SfCR813AHZTlFPq+IA8m54T3ruHsrvLVbdl8RBpo=
Date: Wed, 21 May 2025 09:56:47 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,iii@linux.ibm.com,elver@google.com,dvyukov@google.com,bvanassche@acm.org,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-fix-usage-of-kmsan_enter_runtime-in-kmsan_vmap_pages_range_noflush.patch removed from -mm tree
Message-Id: <20250521165647.EE481C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: fix usage of kmsan_enter_runtime() in kmsan_vmap_pages_range_noflush()
has been removed from the -mm tree.  Its filename was
     kmsan-fix-usage-of-kmsan_enter_runtime-in-kmsan_vmap_pages_range_noflush.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


