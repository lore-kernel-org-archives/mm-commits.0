Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504F519F137
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 01:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749693446; cv=none; b=HCthnYNj+GiRUHE4AOTEG0WZiVeCckmmvGBQhhIqsHJD+IzGFmL85dPxV/r/Q9FwlvhhYFo7YTrOOn5qCBGl+3jDkiJdYJPul055rOChOSbrxRFlou1tRYVwC9J/wDd9lfzdkDAKsYWCP5bOQ4lbbCBtzf0fbQyP8dxHwEVdpOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749693446; c=relaxed/simple;
	bh=mSYUOrkJ2DkJUJzTLd2HNZj+UjlK9xtKJUJXh64gEa4=;
	h=Date:To:From:Subject:Message-Id; b=mVZyAv5TiCAe3jwHFrzMUwZXXR/31WDtmy1ohl9pLeAPkTwsiNOcVdgsHbC8FO6M//7VaL/CJ/un1tMmZDRdrHuCUggTZsQF73XWmoMiiTfRGNTI71LaQg1uJx2ggsQdaFO+L42unc5Y/LNg/zkbt/UXM/UxTrzx2spGfG1Gy3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qh4dfcTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qh4dfcTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36DFC4CEE3;
	Thu, 12 Jun 2025 01:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749693445;
	bh=mSYUOrkJ2DkJUJzTLd2HNZj+UjlK9xtKJUJXh64gEa4=;
	h=Date:To:From:Subject:From;
	b=qh4dfcTq1Fr8LxluOIPgjHwSg5GCxQaGwoBleMwXEzvTZmlafNZMXXBB1SLR1WMTf
	 B5sHTJhX/ZI6gcsMQe99MsCSWMI/MflbfcROTS9F8NdzPcy4EAFj8nBMjze8HhKhWm
	 sn7vAQRNK572Eej99YPSUTHdpHwotd1iX6Z4q92g=
Date: Wed, 11 Jun 2025 18:57:25 -0700
To: mm-commits@vger.kernel.org,robertpang@google.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,corbet@lwn.net,colyli@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-min_heap-add-typedef-for-sift_down-function-pointer.patch added to mm-nonmm-unstable branch
Message-Id: <20250612015725.D36DFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib min_heap: add typedef for sift_down function pointer
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-min_heap-add-typedef-for-sift_down-function-pointer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-min_heap-add-typedef-for-sift_down-function-pointer.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib min_heap: add typedef for sift_down function pointer
Date: Wed, 11 Jun 2025 05:55:10 +0800

Several min-heap operations such as min_heapify_all(), min_heap_pop(),
min_heap_pop_push(), and min_heap_del() use min_heap_sift_down()
internally.  With the addition of the equal-elements-aware variant
min_heap_sift_down_eqaware(), these functions now need to choose between
multiple sift_down implementations.

Introduce a siftdown_fn_t typedef to represent the function pointer type
for sift_down routines.  This avoids repeating verbose function pointer
declarations and simplifies code that dynamically selects the appropriate
implementation based on heap characteristics.

Link: https://lkml.kernel.org/r/20250610215516.1513296-3-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Robert Pang <robertpang@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/min_heap.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/min_heap.h~lib-min_heap-add-typedef-for-sift_down-function-pointer
+++ a/include/linux/min_heap.h
@@ -49,6 +49,9 @@ struct min_heap_callbacks {
 	void (*swp)(void *lhs, void *rhs, void *args);
 };
 
+typedef void (*siftdown_fn_t)(min_heap_char *heap, size_t pos, size_t elem_size,
+			    const struct min_heap_callbacks *func, void *args);
+
 /**
  * is_aligned - is this pointer & size okay for word-wide copying?
  * @base: pointer to data
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch
riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch
riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch
lib-min_heap-add-equal-elements-aware-sift_down-variant.patch
lib-min_heap-add-typedef-for-sift_down-function-pointer.patch
lib-min_heap-add-eqaware-variant-of-min_heapify_all.patch
lib-min_heap-add-eqaware-variant-of-min_heap_pop.patch
lib-min_heap-add-eqaware-variant-of-min_heap_pop_push.patch
lib-min_heap-add-eqaware-variant-of-min_heap_del.patch
documentation-core-api-min_heap-document-_eqaware-variants-of-min-heap-apis.patch
bcache-fix-the-tail-io-latency-regression-by-using-equality-aware-min-heap-api.patch

