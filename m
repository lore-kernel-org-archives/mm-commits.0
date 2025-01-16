Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464B57346F
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006241; cv=none; b=LMewwk1rqWEQaCrKW/yhtRtL2iTPS6Pb7Spxzj+iOeLtNOAc3pfmE0Pie1VItUi3Dxp44JU2ysmD15t4olS4WEEeW2PN6MwxkbXvUUzltI4RFYHXIKtP3f5ezrWTvzt43s4TxwM5k6ViYH5YT4f7plZbQ6Kp55M990KpvIm6C8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006241; c=relaxed/simple;
	bh=XkX78/iPoixLTnNN6TvyO0fQzuO2iuC68xJW33cfU1M=;
	h=Date:To:From:Subject:Message-Id; b=MEQA/q3HW7KDiHIzSo6EraThMxDU2635BZEu4rk2D8QP9t9EcRJcrAnWqAiB8OhBa0WM7IYxJNRu3uYXAEXYCkJjKWw1gab7XilBupYJYaGUtl3zU4miosUn19JZM9WiFWO59lMi2AXPPC+NTrCe9ONL6iVD2TTnthjJFcu55pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NPcezbGK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NPcezbGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B454C4CED6;
	Thu, 16 Jan 2025 05:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006241;
	bh=XkX78/iPoixLTnNN6TvyO0fQzuO2iuC68xJW33cfU1M=;
	h=Date:To:From:Subject:From;
	b=NPcezbGKRpyAb4d2EiWVM3BeeOo5kDn1t29Q+1qq3olCCgA33kt5l17qTYzsJSbAT
	 0EFPb21XLMsl678O/hPVYoDwM8Tf61kNEXvZB5qO3PeJh0+JHeGJY+dPKkIJkUPHlR
	 CZu8FPbDsUHvNk/zDq6LctrNVoaL5y8NOf2OhxSw=
Date: Wed, 15 Jan 2025 21:44:00 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,quic_zhenhuah@quicinc.com,kent.overstreet@linux.dev,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch removed from -mm tree
Message-Id: <20250116054401.1B454C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: avoid current->alloc_tag manipulations when profiling is disabled
has been removed from the -mm tree.  Its filename was
     alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: avoid current->alloc_tag manipulations when profiling is disabled
Date: Thu, 26 Dec 2024 13:16:38 -0800

When memory allocation profiling is disabled there is no need to update
current->alloc_tag and these manipulations add unnecessary overhead.  Fix
the overhead by skipping these extra updates.

I ran comprehensive testing on Pixel 6 on Big, Medium and Little cores:

                 Overhead before fixes            Overhead after fixes
                 slab alloc      page alloc          slab alloc      page alloc
Big               6.21%           5.32%                3.31%          4.93%
Medium            4.51%           5.05%                3.79%          4.39%
Little            7.62%           1.82%                6.68%          1.02%

This is an allocation microbenchmark doing allocations in a tight loop. 
Not a really realistic scenario and useful only to make performance
comparisons.

Link: https://lkml.kernel.org/r/20241226211639.1357704-1-surenb@google.com
Fixes: b951aaff5035 ("mm: enable page allocation tagging")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |   11 ++++++++---
 lib/alloc_tag.c           |    2 ++
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/include/linux/alloc_tag.h~alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled
+++ a/include/linux/alloc_tag.h
@@ -224,9 +224,14 @@ static inline void alloc_tag_sub(union c
 
 #define alloc_hooks_tag(_tag, _do_alloc)				\
 ({									\
-	struct alloc_tag * __maybe_unused _old = alloc_tag_save(_tag);	\
-	typeof(_do_alloc) _res = _do_alloc;				\
-	alloc_tag_restore(_tag, _old);					\
+	typeof(_do_alloc) _res;						\
+	if (mem_alloc_profiling_enabled()) {				\
+		struct alloc_tag * __maybe_unused _old;			\
+		_old = alloc_tag_save(_tag);				\
+		_res = _do_alloc;					\
+		alloc_tag_restore(_tag, _old);				\
+	} else								\
+		_res = _do_alloc;					\
 	_res;								\
 })
 
--- a/lib/alloc_tag.c~alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled
+++ a/lib/alloc_tag.c
@@ -29,6 +29,8 @@ EXPORT_SYMBOL(_shared_alloc_tag);
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
+EXPORT_SYMBOL(mem_alloc_profiling_key);
+
 DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
 
 struct alloc_tag_kernel_section kernel_tags = { NULL, 0 };
_

Patches currently in -mm which might be from surenb@google.com are


