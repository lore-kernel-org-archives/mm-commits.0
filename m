Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFBB49629
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 17:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720115047; cv=none; b=PY5f7/3gYbnf8VDwSemwnVt0sxrO8FTnH3dA8IO1AQEjt6A1ERWgCWsSdo/CnPt4e5t0w2EQD48r5ZZtz/ub1NNuX8Mko4wVqBOmS1UwSpbEM92OjeEecAwoa6gu4hCMFcEl+vb+hsbLy1V9/hhTugp3YjTnPwgChDJRfBflKQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720115047; c=relaxed/simple;
	bh=cLIVQXKmIhHQ6abBi4WtPMTy+mQ/4xk9iFCB5YbB5rE=;
	h=Date:To:From:Subject:Message-Id; b=gZ2Tn0qsfaWX9qDLTXW8KUczKKYzgmu+gYBgL6f2ZqO8VhG95N2WnjPm+xZFj0D/xNNJ60i5/oOQmnYBL6DAck04IRfcgaEcisnivmEE1mhlK3P7/thPKd+O9uFGzYuuUlzPM8GCqIw6Mgkq9B+oKARZGcz+97ZXsjhyoWspkks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LIulSfDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LIulSfDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D9DC3277B;
	Thu,  4 Jul 2024 17:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720115046;
	bh=cLIVQXKmIhHQ6abBi4WtPMTy+mQ/4xk9iFCB5YbB5rE=;
	h=Date:To:From:Subject:From;
	b=LIulSfDLfA3MjsNnc+zvDy97UL0xJyyA6cejVjerZUim1fC408m2pIyVAWQIkcTWw
	 ypkTWeuAur6Z9M6BOxVtERyuXfdnhJKab5QBTFuS0Mc5QpD8nOpb/oz8GuAVlKH0dj
	 uMiFa/VoIGejd9drZ2FDn49qXpxyYcP2lDVjslx0=
Date: Thu, 04 Jul 2024 10:44:06 -0700
To: mm-commits@vger.kernel.org,vincent.guittot@linaro.org,peterz@infradead.org,mingo@redhat.com,lkp@intel.com,kent.overstreet@linux.dev,juri.lelli@redhat.com,jcmvbkbc@gmail.com,chris@zankel.net,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + schedh-always_inline-alloc_tag_saverestore-to-fix-modpost-warnings.patch added to mm-hotfixes-unstable branch
Message-Id: <20240704174406.A9D9DC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sched.h: always_inline alloc_tag_{save|restore} to fix modpost warnings
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     schedh-always_inline-alloc_tag_saverestore-to-fix-modpost-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/schedh-always_inline-alloc_tag_saverestore-to-fix-modpost-warnings.patch

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
Subject: sched.h: always_inline alloc_tag_{save|restore} to fix modpost warnings
Date: Thu, 4 Jul 2024 06:25:05 -0700

Mark alloc_tag_{save|restore} as always_inline to fix the following
modpost warnings:

WARNING: modpost: vmlinux: section mismatch in reference: alloc_tag_save+0x1c (section: .text.unlikely) -> initcall_level_names (section: .init.data)
WARNING: modpost: vmlinux: section mismatch in reference: alloc_tag_restore+0x3c (section: .text.unlikely) -> initcall_level_names (section: .init.data)

The warnings happen when these functions are called from an __init
function and they don't get inlined (remain in the .text section) while
the value returned by get_current() points into .init.data section. 
Assuming get_current() always returns a valid address, this situation can
happen only during init stage and accessing .init.data from .text section
during that stage should pose no issues.

Link: https://lkml.kernel.org/r/20240704132506.1011978-1-surenb@google.com
Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407032306.gi9nZsBi-lkp@intel.com/
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Chris Zankel <chris@zankel.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/sched.h~schedh-always_inline-alloc_tag_saverestore-to-fix-modpost-warnings
+++ a/include/linux/sched.h
@@ -2192,13 +2192,13 @@ static inline int sched_core_idle_cpu(in
 extern void sched_set_stop_task(int cpu, struct task_struct *stop);
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING
-static inline struct alloc_tag *alloc_tag_save(struct alloc_tag *tag)
+static __always_inline struct alloc_tag *alloc_tag_save(struct alloc_tag *tag)
 {
 	swap(current->alloc_tag, tag);
 	return tag;
 }
 
-static inline void alloc_tag_restore(struct alloc_tag *tag, struct alloc_tag *old)
+static __always_inline void alloc_tag_restore(struct alloc_tag *tag, struct alloc_tag *old)
 {
 #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
 	WARN(current->alloc_tag != tag, "current->alloc_tag was changed:\n");
_

Patches currently in -mm which might be from surenb@google.com are

schedh-always_inline-alloc_tag_saverestore-to-fix-modpost-warnings.patch
arch-xtensa-always_inline-get_current-and-current_thread_info.patch
mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros.patch

