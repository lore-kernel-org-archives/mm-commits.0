Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB9E4C3C6
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 16:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UtCV1qUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FE0C433F1;
	Wed, 10 Jan 2024 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704902869;
	bh=w7LvAxksCxxVjuNTi1eNitbZFLUeND29zDnOL3YyjCk=;
	h=Date:To:From:Subject:From;
	b=UtCV1qUNV1YGpPI9SyVk2jxvGp5ldnSLEFdKYU7NqpUakQBCoK4iqKqKXymx+U5mj
	 MtLWkiiT2LlIBHXuM23G1/TNdBtU5jtcbVk4OTusBuo4PmskLlISxwRWsviSMbnj2G
	 WeIobh4Ji0fQvu4LqP5++Ah1YTJUfhdpwTJoTKvc=
Date: Wed, 10 Jan 2024 08:07:49 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,ming.lei@redhat.com,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-group_cpus-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation.patch added to mm-nonmm-unstable branch
Message-Id: <20240110160749.C8FE0C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/group_cpus: don't zero cpumasks in group_cpus_evenly() on allocation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-group_cpus-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpus-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation.patch

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
From: Yury Norov <yury.norov@gmail.com>
Subject: lib/group_cpus: don't zero cpumasks in group_cpus_evenly() on allocation
Date: Thu, 28 Dec 2023 12:09:32 -0800

nmsk and npresmsk are both allocated with zalloc_cpumask_var(), but they
are initialized by copying later in the code, and so may be allocated
uninitialized.

Link: https://lkml.kernel.org/r/20231228200936.2475595-6-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/group_cpus.c~lib-group_cpus-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation
+++ a/lib/group_cpus.c
@@ -354,10 +354,10 @@ struct cpumask *group_cpus_evenly(unsign
 	int ret = -ENOMEM;
 	struct cpumask *masks = NULL;
 
-	if (!zalloc_cpumask_var(&nmsk, GFP_KERNEL))
+	if (!alloc_cpumask_var(&nmsk, GFP_KERNEL))
 		return NULL;
 
-	if (!zalloc_cpumask_var(&npresmsk, GFP_KERNEL))
+	if (!alloc_cpumask_var(&npresmsk, GFP_KERNEL))
 		goto fail_nmsk;
 
 	node_to_cpumask = alloc_node_to_cpumask();
_

Patches currently in -mm which might be from yury.norov@gmail.com are

cpumask-introduce-for_each_cpu_and_from.patch
lib-group_cpus-optimize-inner-loop-in-grp_spread_init_one.patch
lib-group_cpus-relax-atomicity-requirement-in-grp_spread_init_one.patch
lib-group_cpus-optimize-outer-loop-in-grp_spread_init_one.patch
lib-group_cpus-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation.patch
lib-group_cpus-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly.patch
cpumask-define-cleanup-function-for-cpumasks.patch
lib-group_cpus-rework-group_cpus_evenly.patch
lib-group_cpus-simplify-group_cpus_evenly-for-more.patch

