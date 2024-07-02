Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701B5372
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 04:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719894462; cv=none; b=PDV/S7hohIhVhiWuP3YshlJLTmFpB8CJ2kDTIs9ISk546ZwJZaLMgvUkZBjjjDE58tcQxtFUwPRhrjbQYIttZ3D98nD9ugEvn+ei7bvSD0ZQP2zBrOPFTm/J3g5eLtKvoHHuBXac3kJ75XjxPF1MGWa62OLrcWBGixNJ3+t1kE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719894462; c=relaxed/simple;
	bh=Ho5dZO0NMWthasj3vAaV15q34Ewn/NUcunh9T74JuSU=;
	h=Date:To:From:Subject:Message-Id; b=lJBIsDT6BI4Wrctc5pEdgO+RnKGDpdE1U+kdIr+IIrs/LnlF4kpoKzDdlfXSKqhkdGAiMt3k/pYaFa52QvVSOiO+q6oILSsHrBMA6LiJooKVktWHWAClS0lM7R0utxsQFqa4TNxxkM1NNvFpTy30mDW3y0VepDeXoqd58R3ywaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h2xdN9f1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h2xdN9f1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC9BC116B1;
	Tue,  2 Jul 2024 04:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719894462;
	bh=Ho5dZO0NMWthasj3vAaV15q34Ewn/NUcunh9T74JuSU=;
	h=Date:To:From:Subject:From;
	b=h2xdN9f1vNPPfg9/Izg2/LZedln3js5SBilaq8iV1P9Q2Lsbll0yWIxycr8ECR87K
	 VGoX+TnGF8VSKpXTw267CPdEEHJ9tZCIcXFYYshP3wxEufGSkioCiGXwbYBPb5cVJB
	 2/K+WY+Pwokls6dybOKJyPO+l3He2Md3wGtDGRlc=
Date: Mon, 01 Jul 2024 21:27:41 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,oleg@redhat.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch added to mm-unstable branch
Message-Id: <20240702042741.EAC9BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/fork.c: put set_max_threads()/task_struct_whitelist() in __init section
has been added to the -mm mm-unstable branch.  Its filename is
     kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch

This patch will later appear in the mm-unstable branch at
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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: kernel/fork.c: put set_max_threads()/task_struct_whitelist() in __init section
Date: Mon, 1 Jul 2024 01:34:10 +0000

The functions set_max_threads() and task_struct_whitelist() are only used
by fork_init() during bootup.

Let's add __init tag to them.

Link: https://lkml.kernel.org/r/20240701013410.17260-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/fork.c~kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section
+++ a/kernel/fork.c
@@ -997,7 +997,7 @@ void __init __weak arch_task_cache_init(
 /*
  * set_max_threads
  */
-static void set_max_threads(unsigned int max_threads_suggested)
+static void __init set_max_threads(unsigned int max_threads_suggested)
 {
 	u64 threads;
 	unsigned long nr_pages = PHYS_PFN(memblock_phys_mem_size() - memblock_reserved_size());
@@ -1023,7 +1023,7 @@ static void set_max_threads(unsigned int
 int arch_task_struct_size __read_mostly;
 #endif
 
-static void task_struct_whitelist(unsigned long *offset, unsigned long *size)
+static void __init task_struct_whitelist(unsigned long *offset, unsigned long *size)
 {
 	/* Fetch thread_struct whitelist for the architecture. */
 	arch_thread_struct_whitelist(offset, size);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch
kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch

