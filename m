Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAAD7CF18
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 22:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720564910; cv=none; b=TlvwUkqVcAlcTe0ZJ313WXhnPr6IyTOmtzNjHlemLp2zUj9WdgdXLfTb2fvs+WhhsZphum+a24Zxwhd5F4Zjgr0hwg3LfaEbXwnKRppSHsWSvTLR7FCqcR8yd9zpUor5C6s8slKoAvIuJMz8ptzvMv4WAP8PfJAr9SrO80h7W2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720564910; c=relaxed/simple;
	bh=9fkTBp6AY43Drt1+GZxqUVtx0AqKKHZRAYPaRjTFG2Q=;
	h=Date:To:From:Subject:Message-Id; b=HT5RREVCLKKRIfTRujivxngCbP9p/6Tkf/5bp0gx+QotRnNefp99bDrUNeAHQjU7z8m/317/DKg4wzAWothuKInnjOjrsqz4rtzSZ6C+l7YyvJP8X+/hBwM9ZdYLLwzxh2p2A9iJPOZa0WvmUPxqO0MzNQh822MD7dsK/OYTZlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CcaTt2wl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CcaTt2wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CE1C3277B;
	Tue,  9 Jul 2024 22:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720564909;
	bh=9fkTBp6AY43Drt1+GZxqUVtx0AqKKHZRAYPaRjTFG2Q=;
	h=Date:To:From:Subject:From;
	b=CcaTt2wlO95tq2mgFV9pJ+Dv6sv6w1Pj2TkR3xakS3OfaCPzkl+jWoaP6DjTIZPcL
	 AKytS9hxWXOF8Xq/9Xj81v5SZ8KTuNq8OkUFEyP3dXogD1zrzp/vHmKeIrnhHq+1gC
	 SCuYU1OgnQPyQCq626FChkdE9ofB3Q33OIrPhLuk=
Date: Tue, 09 Jul 2024 15:41:48 -0700
To: mm-commits@vger.kernel.org,vincent.guittot@linaro.org,peterz@infradead.org,mingo@redhat.com,lkp@intel.com,kent.overstreet@linux.dev,juri.lelli@redhat.com,jcmvbkbc@gmail.com,chris@zankel.net,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] schedh-always_inline-alloc_tag_saverestore-to-fix-modpost-warnings.patch removed from -mm tree
Message-Id: <20240709224149.60CE1C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched.h: always_inline alloc_tag_{save|restore} to fix modpost warnings
has been removed from the -mm tree.  Its filename was
     schedh-always_inline-alloc_tag_saverestore-to-fix-modpost-warnings.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros.patch

