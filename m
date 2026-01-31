Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC52D38B7BA
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898387; cv=none; b=RvVgrA4GPfXvmrZ/gq3C7yacuQfTUA9LNsTob5P8Qh9S8d62NA+P+FOeXzzQsazHPXFp0gVBXegTPNf/mUxYNWlDsJA1mmk/9AIEh9kUadqvnqBFH95G7utL6d4XusxFqdP/u/R7Swqw4cRe+wJZJrWBbcMjlc3Ozx9c4hDEQZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898387; c=relaxed/simple;
	bh=daaPPgS1nkls7O2Zmo1vZ3Ud3kYQKHk4I/nzZzypX54=;
	h=Date:To:From:Subject:Message-Id; b=DJ4pUw7RGDf4ODfUub6yrbK7DO5yKOfBhd8sBC5j8480xQpT1Q+bvEOZk82pPxZbRoNN1RerDSWQZ9cGjUz4W12L0eivDcCCppj3YqSLVUE/U25D/dBn042GX8/owiPfzdoZfwPhfSnI9K2YJP/oUVDEE57VWJrnH2fb0Dr84rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HFzIyrJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HFzIyrJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945E5C4CEF1;
	Sat, 31 Jan 2026 22:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898387;
	bh=daaPPgS1nkls7O2Zmo1vZ3Ud3kYQKHk4I/nzZzypX54=;
	h=Date:To:From:Subject:From;
	b=HFzIyrJE2Dlwxxm7eRD8hKiguX8YUshsZ5Oenay6trs/basdDaz4EPw89jPU7B/rY
	 /uPHSKOn0UJxoWpqlwuL2gw0bK/EBKJUhjx3p3aDxZa0L7Te6zyUjRgWylu1JpdZ91
	 XKGjNnC/hBc4BC7rsm9wJW4/GAExpdf+jyc7fDMM=
Date: Sat, 31 Jan 2026 14:26:27 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,cl@linux.com,cl@gentwo.org,bigeasy@linutronix.de,dennis@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-add-double-free-check-to-pcpu_free_area.patch removed from -mm tree
Message-Id: <20260131222627.945E5C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: add double free check to pcpu_free_area()
has been removed from the -mm tree.  Its filename was
     percpu-add-double-free-check-to-pcpu_free_area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dennis Zhou <dennis@kernel.org>
Subject: percpu: add double free check to pcpu_free_area()
Date: Fri, 23 Jan 2026 12:55:35 -0800

Percpu memory provides access via offsets into the percpu address space. 
Offsets are essentially fixed for the lifetime of a chunk and therefore
require all users be good samaritans.  If a user improperly handles the
lifetime of the percpu object, it can result in corruption in a couple of
ways:

 - immediate double free - breaks percpu metadata accounting
 - free after subsequent allocation
    - corruption due to multiple owner problem (either prior owner still
      writes or future allocation happens)
    - potential for oops if the percpu pages are reclaimed as the
      subsequent allocation isn't pinning the pages down
    - can lead to page->private pointers pointing to freed chunks

Sebastian noticed that if this happens, none of the memory debugging
facilities add additional information [1].

This patch aims to catch invalid free scenarios within valid chunks.  To
better guard free_percpu(), we can either add a magic number or some
tracking facility to the percpu subsystem in a separate patch.

The invalid free check in pcpu_free_area() validates that the allocation's
starting bit is set in both alloc_map and bound_map.  The alloc_map bit
test ensures the area is allocated while the bound_map bit test checks we
are freeing from the beginning of an allocation.  We choose not to check
the validity of the offset as that is encoded in page->private being a
valid chunk.

pcpu_stats_area_dealloc() is moved later to only be on the happy path so
stats are only updated on valid frees.

Link: https://lkml.kernel.org/r/20260123205535.35267-1-dennis@kernel.org
Link: https://lore.kernel.org/lkml/20260119074813.ecAFsGaT@linutronix.de/ [1]
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Chistoph Lameter <cl@linux.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/mm/percpu.c~percpu-add-double-free-check-to-pcpu_free_area
+++ a/mm/percpu.c
@@ -1279,12 +1279,16 @@ static int pcpu_free_area(struct pcpu_ch
 	int bit_off, bits, end, oslot, freed;
 
 	lockdep_assert_held(&pcpu_lock);
-	pcpu_stats_area_dealloc(chunk);
 
 	oslot = pcpu_chunk_slot(chunk);
 
 	bit_off = off / PCPU_MIN_ALLOC_SIZE;
 
+	/* check invalid free */
+	if (!test_bit(bit_off, chunk->alloc_map) ||
+	    !test_bit(bit_off, chunk->bound_map))
+		return 0;
+
 	/* find end index */
 	end = find_next_bit(chunk->bound_map, pcpu_chunk_map_bits(chunk),
 			    bit_off + 1);
@@ -1303,6 +1307,8 @@ static int pcpu_free_area(struct pcpu_ch
 
 	pcpu_chunk_relocate(chunk, oslot);
 
+	pcpu_stats_area_dealloc(chunk);
+
 	return freed;
 }
 
@@ -2242,6 +2248,13 @@ void free_percpu(void __percpu *ptr)
 
 	spin_lock_irqsave(&pcpu_lock, flags);
 	size = pcpu_free_area(chunk, off);
+	if (size == 0) {
+		spin_unlock_irqrestore(&pcpu_lock, flags);
+
+		/* invalid percpu free */
+		WARN_ON_ONCE(1);
+		return;
+	}
 
 	pcpu_alloc_tag_free_hook(chunk, off, size);
 
_

Patches currently in -mm which might be from dennis@kernel.org are


