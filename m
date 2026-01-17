Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4532829DB6C
	for <mm-commits@vger.kernel.org>; Sat, 17 Jan 2026 03:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768619775; cv=none; b=PzSz+xLVIqBS8TDQTafSR8HaoY7B5YNCe2zwCdBtfRoi2guUOtCzGsv3wkujlRNJFy5/CYv12YeHL8ekuSukP2qtCMN/9zKLFfI0/DfQs17hmTt9z6Sk7fgLzwW8+td02OderDQOzItVRhNVHtCPdfMR7Fcs2FlBWNPAe2vdpAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768619775; c=relaxed/simple;
	bh=l29AxtyfBsypT1r9pz1wXJi7ehkCWPUe6mSBqR4fGKE=;
	h=Date:To:From:Subject:Message-Id; b=g8ri8pIiatXDfJfxkR6Hv4GGvoSVjAUPH0+cHwh0uR8g3bqWDliL/Ax/7i3NMiQ4o76j7z4QqfV55BZToyzGAOZyCLxDAKHqvuWXLSDaWTNknFlXeqKB00unpYxjglsxEUwgldepZUQb8KmQJvgXRAXoBvxk6pA47c5fsgwR+QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IFWEWO2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IFWEWO2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD58C4CEF7;
	Sat, 17 Jan 2026 03:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768619774;
	bh=l29AxtyfBsypT1r9pz1wXJi7ehkCWPUe6mSBqR4fGKE=;
	h=Date:To:From:Subject:From;
	b=IFWEWO2axDzp3N10PRuhdOPpq0Z/oNMnDTGwDGZBblZ3ujV/comTtW2T6UkZlPt3G
	 T8YeFEyFpEfDMFaLZCLLt9HjlIQBIW3suUUIiyGRnKhAKHdGkkeGq/oIodBNUT8NRu
	 C/RBDvHk8PaxbQDONEjkbyuzBSn184cvPzAaVffw=
Date: Fri, 16 Jan 2026 19:16:13 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,clm@meta.com,cl@linux.com,bigeasy@linutronix.de,dennis@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-add-basic-double-free-check.patch added to mm-new branch
Message-Id: <20260117031614.6CD58C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: add basic double free check
has been added to the -mm mm-new branch.  Its filename is
     percpu-add-basic-double-free-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-add-basic-double-free-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dennis Zhou <dennis@kernel.org>
Subject: percpu: add basic double free check
Date: Thu, 15 Jan 2026 18:32:16 -0800

This adds a basic double free check by validating the first bit of the
allocation in alloc_map and bound_map are set.  If the alloc_map bit is
not set, then this means the area is currently unallocated.  If the
bound_map bit is not set, then we are not freeing from the beginning of
the allocation.

This is a respin of [1] adding the requested changes from me and
Christoph.

Link: https://lore.kernel.org/linux-mm/20250904143514.Yk6Ap-jy@linutronix.de/ [1]
Link: https://lkml.kernel.org/r/20260116023216.14515-1-dennis@kernel.org
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Chistoph Lameter <cl@linux.com>
Cc: Chris Mason <clm@meta.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/mm/percpu.c~percpu-add-basic-double-free-check
+++ a/mm/percpu.c
@@ -79,6 +79,7 @@
 #include <linux/mutex.h>
 #include <linux/percpu.h>
 #include <linux/pfn.h>
+#include <linux/ratelimit.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
@@ -1276,18 +1277,24 @@ static int pcpu_alloc_area(struct pcpu_c
 static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
 {
 	struct pcpu_block_md *chunk_md = &chunk->chunk_md;
+	int region_bits = pcpu_chunk_map_bits(chunk);
 	int bit_off, bits, end, oslot, freed;
 
 	lockdep_assert_held(&pcpu_lock);
-	pcpu_stats_area_dealloc(chunk);
 
 	oslot = pcpu_chunk_slot(chunk);
 
 	bit_off = off / PCPU_MIN_ALLOC_SIZE;
+	if (unlikely(bit_off < 0 || bit_off >= region_bits))
+		return 0;
+
+	/* check double free */
+	if (!test_bit(bit_off, chunk->alloc_map) ||
+	    !test_bit(bit_off, chunk->bound_map))
+		return 0;
 
 	/* find end index */
-	end = find_next_bit(chunk->bound_map, pcpu_chunk_map_bits(chunk),
-			    bit_off + 1);
+	end = find_next_bit(chunk->bound_map, region_bits, bit_off + 1);
 	bits = end - bit_off;
 	bitmap_clear(chunk->alloc_map, bit_off, bits);
 
@@ -1303,6 +1310,8 @@ static int pcpu_free_area(struct pcpu_ch
 
 	pcpu_chunk_relocate(chunk, oslot);
 
+	pcpu_stats_area_dealloc(chunk);
+
 	return freed;
 }
 
@@ -2225,6 +2234,7 @@ static void pcpu_balance_workfn(struct w
  */
 void free_percpu(void __percpu *ptr)
 {
+	static DEFINE_RATELIMIT_STATE(_rs, 60 * HZ, DEFAULT_RATELIMIT_BURST);
 	void *addr;
 	struct pcpu_chunk *chunk;
 	unsigned long flags;
@@ -2242,6 +2252,13 @@ void free_percpu(void __percpu *ptr)
 
 	spin_lock_irqsave(&pcpu_lock, flags);
 	size = pcpu_free_area(chunk, off);
+	if (size == 0) {
+		spin_unlock_irqrestore(&pcpu_lock, flags);
+
+		if (__ratelimit(&_rs))
+			WARN(1, "percpu double free or bad ptr\n");
+		return;
+	}
 
 	pcpu_alloc_tag_free_hook(chunk, off, size);
 
_

Patches currently in -mm which might be from dennis@kernel.org are

percpu-add-basic-double-free-check.patch

