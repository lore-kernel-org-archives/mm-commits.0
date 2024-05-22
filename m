Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF95B43147
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417977; cv=none; b=loYfKeyiRXGRvsBvl1nYTsCYDqQvU8Sz5NuBDtc/TAyUNhTS/HlUevmoSLtsz1UOeqo/j+ur/VC8A5V80wWgIqYnJbV9ggGv3hMkoBzxMV7K/k5AjwNHcwb6O5jSRJ7aJ1F3hToDOWoT9nC8Y+6NmbQuZaC2w7FJg8M4GUAhCSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417977; c=relaxed/simple;
	bh=QsWWCIFC8P8GuOmXI2l3Qk3RmIqTnxPnOVdcIfKgqq8=;
	h=Date:To:From:Subject:Message-Id; b=e2CaDJTFxhtJzTtR9++C5TajfLEhtMTk9bhe0GqlMlBvyLgeGI942kVqeEqmd2WZ0rqRfMzY5dBNscAZeeXsQpMipAJiCNPhew776HLDkGSrN7yHzBdok1kOR6g4RZouO9d+o8xhY2kchu38DF7w3hpmaaA+fmBk5N/RTwSOV6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qve5YhHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qve5YhHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7A1C3277B;
	Wed, 22 May 2024 22:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716417976;
	bh=QsWWCIFC8P8GuOmXI2l3Qk3RmIqTnxPnOVdcIfKgqq8=;
	h=Date:To:From:Subject:From;
	b=qve5YhHs1TLLOfri34f4tbTnkOcVw9Rgc2KwBwtA7aHgkP3kgf0Pcul2Gcs+k5Ne5
	 qzIC5EvIC78zyzJB+CdnNVSzg6tIWlnrB7291pK72BuetlnFwqg6Olv/d3OB1S2hTZ
	 +7PShG8tkrWaRCsRlXrGSEv9BbIGRwjtTylP1xvY=
Date: Wed, 22 May 2024 15:46:15 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rppt@kernel.org,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,echanude@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads.patch added to mm-unstable branch
Message-Id: <20240522224616.4E7A1C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: use node's number of cpus in deferred_page_init_max_threads
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads.patch

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
From: Eric Chanudet <echanude@redhat.com>
Subject: mm/mm_init: use node's number of cpus in deferred_page_init_max_threads
Date: Wed, 22 May 2024 16:38:01 -0400

x86_64 is already using the node's cpu as maximum threads.  Make that the
default for all archs setting DEFERRED_STRUCT_PAGE_INIT.

This returns to the behavior prior making the function arch-specific with
commit ecd096506922 ("mm: make deferred init's max threads
arch-specific").

Setting DEFERRED_STRUCT_PAGE_INIT and testing on a few arm64 platforms
shows faster deferred_init_memmap completions:

|         | x13s        | SA8775p-ride | Ampere R137-P31 | Ampere HR330 |
|         | Metal, 32GB | VM, 36GB     | VM, 58GB        | Metal, 128GB |
|         | 8cpus       | 8cpus        | 8cpus           | 32cpus       |
|---------|-------------|--------------|-----------------|--------------|
| threads |  ms     (%) | ms       (%) |  ms         (%) |  ms      (%) |
|---------|-------------|--------------|-----------------|--------------|
| 1       | 108    (0%) | 72      (0%) | 224        (0%) | 324     (0%) |
| cpus    |  24  (-77%) | 36    (-50%) |  40      (-82%) |  56   (-82%) |

Link: https://lkml.kernel.org/r/20240522203758.626932-4-echanude@redhat.com
Signed-off-by: Eric Chanudet <echanude@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   12 ------------
 mm/mm_init.c          |    2 +-
 2 files changed, 1 insertion(+), 13 deletions(-)

--- a/arch/x86/mm/init_64.c~mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads
+++ a/arch/x86/mm/init_64.c
@@ -1354,18 +1354,6 @@ void __init mem_init(void)
 	preallocate_vmalloc_pages();
 }
 
-#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-int __init deferred_page_init_max_threads(const struct cpumask *node_cpumask)
-{
-	/*
-	 * More CPUs always led to greater speedups on tested systems, up to
-	 * all the nodes' CPUs.  Use all since the system is otherwise idle
-	 * now.
-	 */
-	return max_t(int, cpumask_weight(node_cpumask), 1);
-}
-#endif
-
 int kernel_set_to_readonly;
 
 void mark_rodata_ro(void)
--- a/mm/mm_init.c~mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads
+++ a/mm/mm_init.c
@@ -2126,7 +2126,7 @@ deferred_init_memmap_chunk(unsigned long
 __weak int __init
 deferred_page_init_max_threads(const struct cpumask *node_cpumask)
 {
-	return 1;
+	return max_t(int, cpumask_weight(node_cpumask), 1);
 }
 
 /* Initialise remaining memory on a node */
_

Patches currently in -mm which might be from echanude@redhat.com are

mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads.patch

