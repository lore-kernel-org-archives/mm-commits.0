Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053707CF18
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 22:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720564911; cv=none; b=sq4HFllbDygZw3Vgu4HaM08S8YGyLWReLnNI05IogZVMSrGD33WsFnWVSSOrbUPb6n8WESYQM/uSKU57J1cDIfPRwNTRtUXQ+mGzyxyB92O2EisSyDEY7kRfDcIAOWj+rA+VQPYgVldGfdgn/YF1VrWfOARvSdN9cpplMKYRR90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720564911; c=relaxed/simple;
	bh=ITaiDgkAzErFpnrwlaGtnzlWEiSApWsqyW76R2iK8XE=;
	h=Date:To:From:Subject:Message-Id; b=sNHrKhefIeTDD/epDL+a2xf7gPO5vyHITs7ozRTSrqhuZl80nOOtvzv3rOKeJmuqcPCZ32Lhfo11Jwa/rrYCrPrqHkMm2jN6fX2df8aEJ0Dpw3EvV2SQerYUo63Z6eMwpyHbFb+mcNcmCmjU7RBvZ9WYWoOroJdUV+jcJwjCc5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r4b9992N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r4b9992N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4711C3277B;
	Tue,  9 Jul 2024 22:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720564910;
	bh=ITaiDgkAzErFpnrwlaGtnzlWEiSApWsqyW76R2iK8XE=;
	h=Date:To:From:Subject:From;
	b=r4b9992NuKbjJlYSpW9lHW87ekSB8Jh7yxROQWiSTB0czXVBn/kFOh4+yeFxrrytw
	 EkIDFiIHmn4sMNqb12AqlvJuDcfMlOBm03kinElUhoRO88NU5Ayqick1p/1A1/njZW
	 yWlk8++a4+/bc9Rqo0gZX3tq26xcQBoT5WrAbOzU=
Date: Tue, 09 Jul 2024 15:41:50 -0700
To: mm-commits@vger.kernel.org,vincent.guittot@linaro.org,peterz@infradead.org,mingo@redhat.com,lkp@intel.com,kent.overstreet@linux.dev,juri.lelli@redhat.com,jcmvbkbc@gmail.com,chris@zankel.net,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] arch-xtensa-always_inline-get_current-and-current_thread_info.patch removed from -mm tree
Message-Id: <20240709224150.B4711C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch/xtensa: always_inline get_current() and current_thread_info()
has been removed from the -mm tree.  Its filename was
     arch-xtensa-always_inline-get_current-and-current_thread_info.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros.patch

