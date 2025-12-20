Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F0D24169D
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 19:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766260435; cv=none; b=q18RCXtJH45jXevIzB3qYxTZs5UsAzAzPIwg7LoOS/5YvdwYjM8QsnpEFOEeTml2BJiVgLkcRZUJpTjpVtXZhHJeYXzqMyPxDON6Y5pLb5dxuhp34wZSUFBDkPVLBZCLn1tkRZ3Ugqlkrzqw7heBx5OztAXv4fi5Dds0ujLwQJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766260435; c=relaxed/simple;
	bh=Jt1f202sPBTDMikifNgdGYxl1K4fwJrGvRW/2ykaRtg=;
	h=Date:To:From:Subject:Message-Id; b=l9CxERW+vZT5zyFX95fe2uF2JhlvUGWDdCcvZwb4QbymEVaZFjk8aJCYc0CCPNt0S6T6Zx6/dTAathtjofABDu764GdoqGeuXUt6LOslXPC3ahPdn1F38BmvkzTIiQyIvqnKrcvsIBs+NFMDhoQn3rjiB4STJSNtT1yM6LUHpws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EFpiamOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EFpiamOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D17FC4CEF5;
	Sat, 20 Dec 2025 19:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766260434;
	bh=Jt1f202sPBTDMikifNgdGYxl1K4fwJrGvRW/2ykaRtg=;
	h=Date:To:From:Subject:From;
	b=EFpiamOh3jzsHzLUVVu0VczXLRWSKKR5VfpxnJU7TcTUpFcz877EQj7uUA4xgHQ0K
	 b4KCkd1xCMmds6lisZaKCbOgPSuFC1okjiN/zRa+LAo57ojJNRwAcp7wwaubc4kB5l
	 KTJkIAocHn7w3yHVLxi9o5xDz0AOsqdH5XfHJ6K8=
Date: Sat, 20 Dec 2025 11:53:54 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,cl@linux.com,bigeasy@linutronix.de,dennis@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-add-basic-double-free-check.patch added to mm-new branch
Message-Id: <20251220195354.9D17FC4CEF5@smtp.kernel.org>
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
Date: Fri, 19 Dec 2025 16:27:37 -0800

This adds a basic double free check by validating the first bit of the
allocation in alloc_map and bound_map are set.  If the alloc_map bit is
not set, then this means the area is currently unallocated.  If the
bound_map bit is not set, then we are not freeing from the beginning of
the allocation.

This is a respin of [1] adding the requested changes from me and
Christoph.

Link: https://lkml.kernel.org/r/20251220002737.84100-1-dennis@kernel.org
Link: https://lore.kernel.org/linux-mm/20250904143514.Yk6Ap-jy@linutronix.de/ [1]
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Chistoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

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
@@ -1285,6 +1286,11 @@ static int pcpu_free_area(struct pcpu_ch
 
 	bit_off = off / PCPU_MIN_ALLOC_SIZE;
 
+	/* check double free */
+	if (!test_bit(bit_off, chunk->alloc_map) ||
+	    !test_bit(bit_off, chunk->bound_map))
+		return 0;
+
 	/* find end index */
 	end = find_next_bit(chunk->bound_map, pcpu_chunk_map_bits(chunk),
 			    bit_off + 1);
@@ -2225,6 +2231,7 @@ static void pcpu_balance_workfn(struct w
  */
 void free_percpu(void __percpu *ptr)
 {
+	static DEFINE_RATELIMIT_STATE(_rs, 60 * HZ, DEFAULT_RATELIMIT_BURST);
 	void *addr;
 	struct pcpu_chunk *chunk;
 	unsigned long flags;
@@ -2242,6 +2249,13 @@ void free_percpu(void __percpu *ptr)
 
 	spin_lock_irqsave(&pcpu_lock, flags);
 	size = pcpu_free_area(chunk, off);
+	if (size == 0) {
+		spin_unlock_irqrestore(&pcpu_lock, flags);
+
+		if (__ratelimit(&_rs))
+			WARN(1, "percpu double free\n");
+		return;
+	}
 
 	pcpu_alloc_tag_free_hook(chunk, off, size);
 
_

Patches currently in -mm which might be from dennis@kernel.org are

percpu-add-basic-double-free-check.patch

