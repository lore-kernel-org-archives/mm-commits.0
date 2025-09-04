Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25179273D6C
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 22:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757026283; cv=none; b=N1TINuyEwrPA9mGiAc0gKGZ3rBVMSA1jLtOGeGpYd+stKb+wCVOHN5K0IfeM12Pik8PkxnrNGRGHGXAvqALuWhwjJ1T5xb9fsS4tewZzZHp2orYn1u0hCvSZCUO8zBCuWDUPm3cG6GmYXQeuHXbPXVWCSLUOz7D3xIcIqXL8Vfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757026283; c=relaxed/simple;
	bh=/GYBK1pu9YZqDk3YZsUHI9Q1DWd5t1y7pg841ucDKmI=;
	h=Date:To:From:Subject:Message-Id; b=YvIvH15iFms7+jQYE8RbSaNjczlBHzRTIyGF0LnGwmgH1WRhqWQc7kQ3y4cl+7lqNstOdZQ11/mcBdjae0rZWCOpMjiXN/Y7yFjLUoQba5kbr2/diBnDr3tqVSLoU8MT0sRVl7k88FJafxrV7E2bmu/uPezaPD6Tlh5yhrymxNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tH/mN/3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tH/mN/3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78962C4CEF0;
	Thu,  4 Sep 2025 22:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757026282;
	bh=/GYBK1pu9YZqDk3YZsUHI9Q1DWd5t1y7pg841ucDKmI=;
	h=Date:To:From:Subject:From;
	b=tH/mN/3GXGLQvjtSCBFQDnGPfiI1g7V9lz/rwAI1tPSa6HUg6LNOlNyGBr8u+dXAc
	 U/WfhBoUHcrqydRmsxH3ViRJyHDbDEsYdtGeOdAaKPYIQscQCGMffSUmDly0Iy8H3F
	 I4HLL8JvT7UdtYv7KHfUpGcjJrh3py4X+s6tlrhE=
Date: Thu, 04 Sep 2025 15:51:21 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@gentwo.org,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-add-a-simple-double-free-check-for-per-cpu-memory.patch added to mm-new branch
Message-Id: <20250904225122.78962C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/percpu: add a simple double-free check for per-CPU memory
has been added to the -mm mm-new branch.  Its filename is
     mm-percpu-add-a-simple-double-free-check-for-per-cpu-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-add-a-simple-double-free-check-for-per-cpu-memory.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/percpu: add a simple double-free check for per-CPU memory
Date: Thu, 4 Sep 2025 16:35:14 +0200

The free path clears the allocation bits in pcpu_chunk::alloc_map.  A
simple double free check would be to check if the bits, which are about to
be cleared, are already cleared.

Check if the bit is already cleared. Issue a warning and abort free in
that case.

Link: https://lkml.kernel.org/r/20250904143514.Yk6Ap-jy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/percpu.c~mm-percpu-add-a-simple-double-free-check-for-per-cpu-memory
+++ a/mm/percpu.c
@@ -1276,7 +1276,7 @@ static int pcpu_alloc_area(struct pcpu_c
 static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
 {
 	struct pcpu_block_md *chunk_md = &chunk->chunk_md;
-	int bit_off, bits, end, oslot, freed;
+	int bit_off, bits, end, oslot, freed, free_bit;
 
 	lockdep_assert_held(&pcpu_lock);
 	pcpu_stats_area_dealloc(chunk);
@@ -1289,6 +1289,11 @@ static int pcpu_free_area(struct pcpu_ch
 	end = find_next_bit(chunk->bound_map, pcpu_chunk_map_bits(chunk),
 			    bit_off + 1);
 	bits = end - bit_off;
+
+	free_bit = find_next_bit(chunk->alloc_map, end, bit_off);
+	if (WARN(free_bit != bit_off, "Trying to free already free memory"))
+		return 0;
+
 	bitmap_clear(chunk->alloc_map, bit_off, bits);
 
 	freed = bits * PCPU_MIN_ALLOC_SIZE;
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-percpu-add-a-simple-double-free-check-for-per-cpu-memory.patch

