Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89A3286D7D
	for <mm-commits@vger.kernel.org>; Fri, 23 Jan 2026 22:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769207485; cv=none; b=CGFnqLzYpxScJRIsYVrlh0ugHiA/9ERwP9czyiKXc/ySMp4mcTmx6+a7eTZJoP/DzUv/InGmVLLnuQJ2WcyuRmbyG9n7C+V2m2E5tA/agl0r7iZxq+AbeHjR0wsx59Uw7YKCCYNznkxiTJ0t+UGs2zFqtm8aYqdHF9Rm1Gktlso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769207485; c=relaxed/simple;
	bh=XEwRyIH5s1dalhFyxW/0DXW4xydzqC+BD7sq8GacNOU=;
	h=Date:To:From:Subject:Message-Id; b=pnVRaalDLihyW35roGlnfPREdnqya35UR+FUjTIk1Iq1nxb+Q0m898iKxm944DjoI9y6/LlTEL1c9QnwZnIegqArzMuAptYaEumiSOYiKVJdvHGNkelTtkWgdY9cCTftrS05owmpgX2VwZ/4Pxc8q1JVhIyyMcxFrlPqCjR2Uos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d5nRrm03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d5nRrm03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE1FC4CEF1;
	Fri, 23 Jan 2026 22:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769207485;
	bh=XEwRyIH5s1dalhFyxW/0DXW4xydzqC+BD7sq8GacNOU=;
	h=Date:To:From:Subject:From;
	b=d5nRrm0333zn73fZZdcbd2pndJp7Ru5fNG2t5q8CtlLkmyjKr70kHJQibAqS0ZVbD
	 PV+Rtzw9HCSCrt6/s47XXSP+nfQlfAt+Y8OpuavLZsBgRgkobRFnxgKCrwh3XU9ZyW
	 oS5bExyzBSPJirTsydUyMwx6A6THokV3qEREkUvE=
Date: Fri, 23 Jan 2026 14:31:24 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,cl@linux.com,cl@gentwo.org,bigeasy@linutronix.de,dennis@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-add-double-free-check-to-pcpu_free_area.patch added to mm-new branch
Message-Id: <20260123223125.1BE1FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: add double free check to pcpu_free_area()
has been added to the -mm mm-new branch.  Its filename is
     percpu-add-double-free-check-to-pcpu_free_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-add-double-free-check-to-pcpu_free_area.patch

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

percpu-add-double-free-check-to-pcpu_free_area.patch

