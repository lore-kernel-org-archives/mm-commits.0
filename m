Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CFF3D3B3
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 17:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720115049; cv=none; b=IpDObJH6+B3A6KlbPEmQs2tuLmm0zrDs1TkIOqqK5nuttnS9OfdU4g1TLpwGTcWxw7wv0GfH7uMSbcXvSeUN6fA1Qudyn7HHdVxQHuN5HTnP5fgos3VlX0r1ZEWI/POhbsfXLHC92o1+7gVVR6nTvDn2/aA4/D+8rU67oBsSquo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720115049; c=relaxed/simple;
	bh=xQl1nok3KNSmvA7vZCsSkk9SHXQMmckbwXjnWH6ydh4=;
	h=Date:To:From:Subject:Message-Id; b=WIPBz+tLfb8EatGms6PHJupvTgBZaRyJbRK1/OIc8pmLLN57lxbIRUz74lo5awgvkrJWrR3+j1gho9zc4C3baRuujGrqA1DmgT8C9bXjAdJHBFPpTMdeV2CS7JAWKenP4sHsZZRbuzCaLWuIoeWQGIQEno0ZiJ4GnYPF5eATiPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=orFhJQk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="orFhJQk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E91CC3277B;
	Thu,  4 Jul 2024 17:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720115048;
	bh=xQl1nok3KNSmvA7vZCsSkk9SHXQMmckbwXjnWH6ydh4=;
	h=Date:To:From:Subject:From;
	b=orFhJQk6mdEsHiNzadMCEtExZeMuxkXb7bc9WvzJGbt1jFx65VLfEhyUrvrTr7z9q
	 4/hYtEc6qtMwpGvETJCgzTdQ/CgAGziKIwmvrWgt3L2d5p69Q901TuM1ue11XnUgSy
	 IuqSpZfr77Xu1GMAkJnjdBLHPYOcaGPNxBt/eY2s=
Date: Thu, 04 Jul 2024 10:44:08 -0700
To: mm-commits@vger.kernel.org,vincent.guittot@linaro.org,peterz@infradead.org,mingo@redhat.com,lkp@intel.com,kent.overstreet@linux.dev,juri.lelli@redhat.com,jcmvbkbc@gmail.com,chris@zankel.net,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-xtensa-always_inline-get_current-and-current_thread_info.patch added to mm-hotfixes-unstable branch
Message-Id: <20240704174408.9E91CC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/xtensa: always_inline get_current() and current_thread_info()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     arch-xtensa-always_inline-get_current-and-current_thread_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-xtensa-always_inline-get_current-and-current_thread_info.patch

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
Subject: arch/xtensa: always_inline get_current() and current_thread_info()
Date: Thu, 4 Jul 2024 06:25:06 -0700

Mark get_current() and current_thread_info() functions as always_inline to
fix the following modpost warning:

WARNING: modpost: vmlinux: section mismatch in reference: get_current+0xc (section: .text.unlikely) -> initcall_level_names (section: .init.data)

The warning happens when these functions are called from an __init
function and they don't get inlined (remain in the .text section) while
the value they return points into .init.data section.  Assuming
get_current() always returns a valid address, this situation can happen
only during init stage and accessing .init.data from .text section during
that stage should pose no issues.

Link: https://lkml.kernel.org/r/20240704132506.1011978-2-surenb@google.com
Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Chris Zankel <chris@zankel.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/current.h     |    2 +-
 arch/xtensa/include/asm/thread_info.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/xtensa/include/asm/current.h~arch-xtensa-always_inline-get_current-and-current_thread_info
+++ a/arch/xtensa/include/asm/current.h
@@ -19,7 +19,7 @@
 
 struct task_struct;
 
-static inline struct task_struct *get_current(void)
+static __always_inline struct task_struct *get_current(void)
 {
 	return current_thread_info()->task;
 }
--- a/arch/xtensa/include/asm/thread_info.h~arch-xtensa-always_inline-get_current-and-current_thread_info
+++ a/arch/xtensa/include/asm/thread_info.h
@@ -91,7 +91,7 @@ struct thread_info {
 }
 
 /* how to get the thread information struct from C */
-static inline struct thread_info *current_thread_info(void)
+static __always_inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
 	 __asm__("extui %0, a1, 0, "__stringify(CURRENT_SHIFT)"\n\t"
_

Patches currently in -mm which might be from surenb@google.com are

schedh-always_inline-alloc_tag_saverestore-to-fix-modpost-warnings.patch
arch-xtensa-always_inline-get_current-and-current_thread_info.patch
mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros.patch

