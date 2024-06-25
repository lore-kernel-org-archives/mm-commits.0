Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788AD1849
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289040; cv=none; b=EJ5/YoH+xLYCmT+Ac/h8jB21ZbjOr04tCZIrDqOeOIA1gKNWDbA7K7xxP9c8UAR4ZONAD8RpmmMkAKwRwmKzNei9nBJGBTGMjgW1YjJAGezYoypd+GRZItXbTWH+DBp28dReoIJH/kJ4Vf7UZWGYVyL4nBb2sdVZ3DFMrJ/U6Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289040; c=relaxed/simple;
	bh=wjKH1nY2K4xVJy0CSBTicZTCg6KOUO0AimGGMxd+PO0=;
	h=Date:To:From:Subject:Message-Id; b=BmcOmldckdYOMUtXTi5vtQHkMXQTtBoA4GliHqb82P5syv/05bUhwUbCqMEBBVqeEdknuZKW3IYS6V0wZEw83DTEGJYQT9dFRbOX0VytgxbqEk2ehdQWx5zwjqFFA5iJbvfeVe7chMvQb0eR17KIjQPceLxFPgG9wcSXzsEJnqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eakzvmM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eakzvmM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AD5C32782;
	Tue, 25 Jun 2024 04:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289040;
	bh=wjKH1nY2K4xVJy0CSBTicZTCg6KOUO0AimGGMxd+PO0=;
	h=Date:To:From:Subject:From;
	b=eakzvmM+4WCnENyGZFf7cLwZ3KOQxZoAJMHB1GOx4m33ji1H2aC6sslpYjdJpet+U
	 Fhf7/NqgltT8YsukGuA4p5C8rTiGBEBluLCt02o9xTAQxgNGQCHKol9ijSZpoWUkpt
	 cmiWzuNk8GLBC/f6ZSIfchjlF34oVoa3jDLkOejQ=
Date: Mon, 24 Jun 2024 21:17:19 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rppt@kernel.org,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,echanude@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads-v3.patch removed from -mm tree
Message-Id: <20240625041720.46AD5C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads-v3
has been removed from the -mm tree.  Its filename was
     mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads-v3.patch

This patch was dropped because it was folded into mm-mm_init-use-nodes-number-of-cpus-in-deferred_page_init_max_threads.patch

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

