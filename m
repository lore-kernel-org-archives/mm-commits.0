Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B448D13C9A2
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291582; cv=none; b=MLjlmmW3SvCM0dys9vON8+k9KoWgoc1veJsghm54+jp8ZtS6U34jJnHDJV6uJ/masFhLnK/anIhr3V/2oCIhFU5yncZvrsFT3AoYjAxh5mfOCByHT7zFX+F+T/jPn+Vy9GJkDamlk/gG5xlu5bktcObei0uhE0jQ0rvVVZU0nSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291582; c=relaxed/simple;
	bh=EAuRnf5wSSIcSOE0jG1fOs8vkXCI2zXGGEeX4yXKfOw=;
	h=Date:To:From:Subject:Message-Id; b=lbR3+KS6iOH781cmvalR6Zw9Y1BAoUR44MLKgrURAOisV8GkCze6vUw0y0ZK5es0TpaLHB8xmPataxZIzLcmzRyY0mZQ99qcwuPgqJIVb3T3Tnc3DGxs2fvohuhhBLeaOqhBjCtYvYzn13aqpkNnTC4DldM6hERGinPekXwtL3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uc07nNGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uc07nNGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884DFC32782;
	Tue, 25 Jun 2024 04:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291582;
	bh=EAuRnf5wSSIcSOE0jG1fOs8vkXCI2zXGGEeX4yXKfOw=;
	h=Date:To:From:Subject:From;
	b=Uc07nNGeB/36zUMLEfd651j6MtylBrawMOhcxQLhgF3VwROSUgdAnpuo2hzrx1pTN
	 o85nSTOlctwUxLFB8X0bCTU9bblpPr4fhfqV519a9yTeYAZ7+7tlSxcTCibbym/FZ3
	 rd5Id4HtWiaPxoxQmEAU7JDDDdhss/0QVtiaItyE=
Date: Mon, 24 Jun 2024 21:59:42 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rppt@kernel.org,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,agordeev@linux.ibm.com,echanude@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads.patch removed from -mm tree
Message-Id: <20240625045942.884DFC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: use node's number of cpus in deferred_page_init_max_threads
has been removed from the -mm tree.  Its filename was
     mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Michael Ellerman reported:

: On a machine here (1TB, 40 cores, 4KB pages) the existing code gives:
: 
:   [    0.500124] node 2 deferred pages initialised in 210ms
:   [    0.515790] node 3 deferred pages initialised in 230ms
:   [    0.516061] node 0 deferred pages initialised in 230ms
:   [    0.516522] node 7 deferred pages initialised in 230ms
:   [    0.516672] node 4 deferred pages initialised in 230ms
:   [    0.516798] node 6 deferred pages initialised in 230ms
:   [    0.517051] node 5 deferred pages initialised in 230ms
:   [    0.523887] node 1 deferred pages initialised in 240ms
: 
: vs with the patch:
: 
:   [    0.379613] node 0 deferred pages initialised in 90ms
:   [    0.380388] node 1 deferred pages initialised in 90ms
:   [    0.380540] node 4 deferred pages initialised in 100ms
:   [    0.390239] node 6 deferred pages initialised in 100ms
:   [    0.390249] node 2 deferred pages initialised in 100ms
:   [    0.390786] node 3 deferred pages initialised in 110ms
:   [    0.396721] node 5 deferred pages initialised in 110ms
:   [    0.397095] node 7 deferred pages initialised in 110ms
: 
: Which is a nice speedup.

[echanude@redhat.com: v3]
  Link: https://lkml.kernel.org/r/20240528185455.643227-4-echanude@redhat.com
Link: https://lkml.kernel.org/r/20240522203758.626932-4-echanude@redhat.com
Signed-off-by: Eric Chanudet <echanude@redhat.com>
Tested-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c    |   12 ------------
 include/linux/memblock.h |    2 --
 mm/mm_init.c             |    5 ++---
 3 files changed, 2 insertions(+), 17 deletions(-)

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
--- a/include/linux/memblock.h~mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads
+++ a/include/linux/memblock.h
@@ -335,8 +335,6 @@ void __next_mem_pfn_range_in_zone(u64 *i
 	for (; i != U64_MAX;					  \
 	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end))
 
-int __init deferred_page_init_max_threads(const struct cpumask *node_cpumask);
-
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 /**
--- a/mm/mm_init.c~mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads
+++ a/mm/mm_init.c
@@ -2122,11 +2122,10 @@ deferred_init_memmap_chunk(unsigned long
 	}
 }
 
-/* An arch may override for more concurrency. */
-__weak int __init
+static unsigned int __init
 deferred_page_init_max_threads(const struct cpumask *node_cpumask)
 {
-	return 1;
+	return max(cpumask_weight(node_cpumask), 1U);
 }
 
 /* Initialise remaining memory on a node */
_

Patches currently in -mm which might be from echanude@redhat.com are


