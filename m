Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F6625A657
	for <mm-commits@vger.kernel.org>; Tue,  4 Feb 2025 00:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738629069; cv=none; b=q7REg+HPrmIPxOPW1v7GAvDnwIMawu62n09xOZyCVcn9OFtLCFIsGQMuaTTCmX8PsJLZBhROp2+XIObq6ObqcMDOBJQcxwrexkSCPlzSIJDtLXIBCbq7lVmeFS/kT5WkD3hcG3GwfJzPNBDOnMUnZxIS4xTxaXHways6DUJ3gVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738629069; c=relaxed/simple;
	bh=JvwOr1mPYW+c35fu+0SmmRxy5wPeoga9npa+0dWWrUM=;
	h=Date:To:From:Subject:Message-Id; b=bZCbUUvvYiw+SwjrxqGH0YvWsVIlA6uhbHRHsiRtd6ruI0OdSyNdiCDNJQ0Ngb2Cu27YFD/Da4xue/kiczz15B4vRvltELD4yCyF9gr6uZhjurU0fqnD3gd7MBUYpDc621vM49OAmIj8bb+tNcDgKkEuvkpURnt8A/3rPJFzE6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tzidhR0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tzidhR0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D958C4CEE0;
	Tue,  4 Feb 2025 00:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738629069;
	bh=JvwOr1mPYW+c35fu+0SmmRxy5wPeoga9npa+0dWWrUM=;
	h=Date:To:From:Subject:From;
	b=tzidhR0ZCxZ3F04+hYDRXky0ddgI8cDV1X4rxK48Z6kvTTlubVeorSJT9N7kN4bNR
	 4n8dHC23VGEvxIzQh2DXizYRctG/TVj8HF/57OZz13OFPBiGgZkf5ay/zrlqrVKkDo
	 +uROL3OVRIOEQPnnFIAUCmPAQK14nkF/B+/td6gg=
Date: Mon, 03 Feb 2025 16:31:08 -0800
To: mm-commits@vger.kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,lkp@intel.com,kent.overstreet@linux.dev,justinstitt@google.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-work-around-clang-14-issue-with-__builtin_object_size.patch added to mm-hotfixes-unstable branch
Message-Id: <20250204003109.1D958C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: work around clang-14 build issue with __builtin_object_size()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     alloc_tag-work-around-clang-14-issue-with-__builtin_object_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-work-around-clang-14-issue-with-__builtin_object_size.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: work around clang-14 build issue with __builtin_object_size()
Date: Sat, 1 Feb 2025 12:05:03 -0800

Additional condition in the allocation hooks causes Clang version 14
(tested on 14.0.6) to treat the allocated object size as unknown at
compile-time (__builtin_object_size(obj, 1) returns -1) even though both
branches of that condition yield the same result.  Other versions of Clang
(tested with 13.0.1, 15.0.7, 16.0.6 and 17.0.6) compile the same code
without issues.  Add build-time Clang version check which removes this
condition and effectively restores the unconditional tag store/restore
flow when compiled with clang-14.

Link: https://lkml.kernel.org/r/20250201200503.2532357-1-surenb@google.com
Fixes: 07438779313c ("alloc_tag: avoid current->alloc_tag manipulations when profiling is disabled")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501310832.kiAeOt2z-lkp@intel.com/
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~alloc_tag-work-around-clang-14-issue-with-__builtin_object_size
+++ a/include/linux/alloc_tag.h
@@ -222,10 +222,23 @@ static inline void alloc_tag_sub(union c
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
+/* See https://lore.kernel.org/all/202501310832.kiAeOt2z-lkp@intel.com/ */
+#if defined(CONFIG_CC_IS_CLANG) && CONFIG_CLANG_VERSION >= 140000 && CONFIG_CLANG_VERSION < 150000
+static inline bool store_current_tag(void)
+{
+	return true;
+}
+#else
+static inline bool store_current_tag(void)
+{
+	return mem_alloc_profiling_enabled();
+}
+#endif
+
 #define alloc_hooks_tag(_tag, _do_alloc)				\
 ({									\
 	typeof(_do_alloc) _res;						\
-	if (mem_alloc_profiling_enabled()) {				\
+	if (store_current_tag()) {					\
 		struct alloc_tag * __maybe_unused _old;			\
 		_old = alloc_tag_save(_tag);				\
 		_res = _do_alloc;					\
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-work-around-clang-14-issue-with-__builtin_object_size.patch
mm-avoid-extra-mem_alloc_profiling_enabled-checks.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-slab-allocator.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-page-allocator.patch

