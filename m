Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56CA17839F
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 19:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716925332; cv=none; b=rfLiWsNhDAfDxI93xjPGEoyadjqzZClpVhZyW/oRbqftx1LlHGLJw3+lSww6JgmDlp/Rn5Cogao+jiTUu6pnJ+ZPDE0eHN6Mnxbm6ZxlZafFDpbNFU9xnWerzZokmjzmvJ30MuPzz+naUqNRu1rCyNLhwFhYB4ZOtxCJOGk1BDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716925332; c=relaxed/simple;
	bh=2klv4MRLJKiHx5lb5O1/HCiI4aKYLx8w/Al5u8OkPIE=;
	h=Date:To:From:Subject:Message-Id; b=AAZ6Au39eAvrUJMsf9N7GkwfSRIRG2K5DYXeegi35hRqvkqPNOocSMOZWLtNiG+PBvxWfJtXsj94jA1yy2dfqRtaS49ClQTrmT0c6T6JVi1HByJCRUWnHeWYb4jizVgR//LgeWo2ga291ADjYfTQVapnUubsjOLsW9Q/SSEBHYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IUEIwHDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IUEIwHDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EA1C3277B;
	Tue, 28 May 2024 19:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716925332;
	bh=2klv4MRLJKiHx5lb5O1/HCiI4aKYLx8w/Al5u8OkPIE=;
	h=Date:To:From:Subject:From;
	b=IUEIwHDJ+Gec+19/f15/HZBYBdFgQGuKOIDDKiVhlX4pyM7edP6RjtLJiA60fKWwf
	 e0dcydXsIz9h/D1DDTbAgSkk++0NJLDFU7998AJFI2bANokHD5eSzulFJpZPQRfamJ
	 UMcJd4KnrPhGLDaVwJ3nVozdoghn6QMnrbTyaQqE=
Date: Tue, 28 May 2024 12:42:11 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rppt@kernel.org,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,echanude@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads-v3.patch added to mm-unstable branch
Message-Id: <20240528194212.56EA1C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads-v3.patch

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
Subject: mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads-v3
Date: Tue, 28 May 2024 14:54:58 -0400

 - deferred_page_init_max_threads returns unsigned and use max instead
   of max_t.
 - Make deferred_page_init_max_threads static since there are no more
   override.

Link: https://lkml.kernel.org/r/20240528185455.643227-4-echanude@redhat.com
Signed-off-by: Eric Chanudet <echanude@redhat.com>
Tested-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    2 --
 mm/mm_init.c             |    5 ++---
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/include/linux/memblock.h~mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads-v3
+++ a/include/linux/memblock.h
@@ -335,8 +335,6 @@ void __next_mem_pfn_range_in_zone(u64 *i
 	for (; i != U64_MAX;					  \
 	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end))
 
-int __init deferred_page_init_max_threads(const struct cpumask *node_cpumask);
-
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 /**
--- a/mm/mm_init.c~mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads-v3
+++ a/mm/mm_init.c
@@ -2122,11 +2122,10 @@ deferred_init_memmap_chunk(unsigned long
 	}
 }
 
-/* An arch may override for more concurrency. */
-__weak int __init
+static unsigned int __init
 deferred_page_init_max_threads(const struct cpumask *node_cpumask)
 {
-	return max_t(int, cpumask_weight(node_cpumask), 1);
+	return max(cpumask_weight(node_cpumask), 1U);
 }
 
 /* Initialise remaining memory on a node */
_

Patches currently in -mm which might be from echanude@redhat.com are

mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads.patch
mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads-v3.patch

