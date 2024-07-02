Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FFD372
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 04:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719894460; cv=none; b=euwkFPZInSiwXEAZjff3kMxwJsdZWK2jq0D6nbi3JvNqTSkjpoLoZt0ISWU4HTlKqzlLBCjkyX6cLsWp39p95e+jKWgiJmlBvA0nMIchzMdew3c7oV4H40h1w7E3vFZlGRA6BD4Zhpyn5RX3a8nmkeM+XFbi68orAtIsuMJ6pwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719894460; c=relaxed/simple;
	bh=P92cWe2Euynr3Buw7d7x6WzPKnpVpLXc2bGZHIJJWdQ=;
	h=Date:To:From:Subject:Message-Id; b=tSzYGyUD7ZknkKw4LxpZ6TzbrgMUXYTH03HwGliRkxiSzM2At58Y/vun815ggLBPFaPmUOiomOZ5LaYSEY1A9viMjq2JWtd03t8sP3aLimQlpuhmYsx6wjn4DNbZWmjrH89k3BNlSz8CbysdYQ8gpkmuTJMEU5TvkSAJl3qqGvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dp/78WJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dp/78WJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D8FC116B1;
	Tue,  2 Jul 2024 04:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719894460;
	bh=P92cWe2Euynr3Buw7d7x6WzPKnpVpLXc2bGZHIJJWdQ=;
	h=Date:To:From:Subject:From;
	b=Dp/78WJyyd5nmfHB9jMzJTN/ivo5F10AD89/a9tMWK3hWSZ/s3YRF0G3HtLzNezk8
	 Mhc030Zro+qpellMRScGV5RsKX0XVhYLGcjbbnwre4HqwdbaX9TLNUxbU28xjxayUO
	 4khH3vkw2Yn3GrTIBcJOV/fNE3F+1Up8kEzUJ4Y4=
Date: Mon, 01 Jul 2024 21:27:39 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,oleg@redhat.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch added to mm-unstable branch
Message-Id: <20240702042740.02D8FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/fork.c: get totalram_pages from memblock to calculate max_threads
has been added to the -mm mm-unstable branch.  Its filename is
     kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch

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
Subject: kernel/fork.c: get totalram_pages from memblock to calculate max_threads
Date: Mon, 1 Jul 2024 01:34:09 +0000

Since we plan to move the accounting into __free_pages_core(),
totalram_pages may not represent the total usable pages on system at this
point when defer_init is enabled.

Instead we can get the total usable pages from memblock directly.

Link: https://lkml.kernel.org/r/20240701013410.17260-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/fork.c~kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads
+++ a/kernel/fork.c
@@ -44,6 +44,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
+#include <linux/memblock.h>
 #include <linux/nsproxy.h>
 #include <linux/capability.h>
 #include <linux/cpu.h>
@@ -999,7 +1000,7 @@ void __init __weak arch_task_cache_init(
 static void set_max_threads(unsigned int max_threads_suggested)
 {
 	u64 threads;
-	unsigned long nr_pages = totalram_pages();
+	unsigned long nr_pages = PHYS_PFN(memblock_phys_mem_size() - memblock_reserved_size());
 
 	/*
 	 * The number of threads shall be limited such that the thread
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch
kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch

