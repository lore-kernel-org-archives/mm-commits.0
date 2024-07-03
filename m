Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F63A1822FB;
	Wed,  3 Jul 2024 22:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720047087; cv=none; b=rb6hb+8FQIUC2xMrRQWKoUFKGNNC7ymmlujUyFDHUDKpM8WZ6cdblP0+xuco/N/AOuHIe+bCipqA4edYiDT0tZAuvg7V8lZOCgQO2V9mKS3TVkZaBJ6Z4fS14WsM+9ydyVSkOWEpFsyhAv2F7DjNODRP6238Y8sJrBDug1zg/B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720047087; c=relaxed/simple;
	bh=ezonhlygC2kdrQvOLHpEGC/S9uMXbcXG/5SVo8SsPrY=;
	h=Date:To:From:Subject:Message-Id; b=FiH6T1jCNsOimsCo078a7YjCBwhc6+eh3RYrySh1faN3OJ0vLpNEjmslmUtaIzkhtqALVW8J9MCzvht+WWebzWrHUDU/5B6aVSNaiYzpJ0PIQLWEQ4Yu0nxCwC9Z5GMx5X4NoVv5QGTnieCu0XTKtBQI8zWOGT6NW9d4T48on54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ANJqMzmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ANJqMzmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA48C4AF0D;
	Wed,  3 Jul 2024 22:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720047086;
	bh=ezonhlygC2kdrQvOLHpEGC/S9uMXbcXG/5SVo8SsPrY=;
	h=Date:To:From:Subject:From;
	b=ANJqMzmqj1Kq9W0P6chKuK5bBukrREiO5lTHUrXRHTUyzmGrBOBHX7io6mE9SPaRH
	 bfN0y33dKyqGr6lIQ4GaxnYxPvEX7P7eO8hy99sQ5ZrQ30qLi4HV3OR+PRoi4bcv+5
	 ZnHeRXpX9ZrNEElS941EOG4JQlG6WobfelXNJMK0=
Date: Wed, 03 Jul 2024 15:51:26 -0700
To: mm-commits@vger.kernel.org,vincent.guittot@linaro.org,stable@vger.kernel.org,peterz@infradead.org,mingo@redhat.com,lkp@intel.com,kent.overstreet@linux.dev,juri.lelli@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + schedh-always_inline-alloc_tag_saverestore-to-fix-modpost-warnings.patch added to mm-hotfixes-unstable branch
Message-Id: <20240703225126.AFA48C4AF0D@smtp.kernel.org>
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
Date: Wed, 3 Jul 2024 15:15:20 -0700

Mark alloc_tag_{save|restore} as always_inline to fix the following
modpost warnings:

WARNING: modpost: vmlinux: section mismatch in reference: alloc_tag_save+0x1c (section: .text.unlikely) -> initcall_level_names (section: .init.data)
WARNING: modpost: vmlinux: section mismatch in reference: alloc_tag_restore+0x3c (section: .text.unlikely) -> initcall_level_names (section: .init.data)

Link: https://lkml.kernel.org/r/20240703221520.4108464-1-surenb@google.com
Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allocation profiling")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407032306.gi9nZsBi-lkp@intel.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: <stable@vger.kernel.org>
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
mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros.patch

