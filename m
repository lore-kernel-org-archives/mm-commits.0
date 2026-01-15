Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D269232FA0D
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 23:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768518744; cv=none; b=pK01hj78Hd3MR5f0hpy9PCNZUIDl7utQ62vYVMUn+vWqYSbRhsVVLpa8cNhMYnUd4Uyx4cr41PyZ7FrNmisPyyBaNd8dyTFddOgm6RBgS9IFDqPWNwZWsz6mdcCVxwNExqiWep3UMUAMcuGa2HfhIgDii3gyV9rMzPnGXTeK1Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768518744; c=relaxed/simple;
	bh=MyUbM1TUVaryfVNW85VnqADb6hLX5rIrWJY/De/JpAA=;
	h=Date:To:From:Subject:Message-Id; b=szXIm7mv2/wei1a7P0q3Q+j+w4j3+pP9Wp55BkugXEONCrYDk30Wr68OFdQsN/Ud29KnvnxVmUhKT1OgeQO6LvzyJWtteZIWHeLqLpQLLFibt0DzGKIMLzg3lAxCmAk/GLIB1QVM7BjHpfKv3CbXRznIcEMF4JY05OgsY1EG/Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=po73WLc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="po73WLc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189A0C19422;
	Thu, 15 Jan 2026 23:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768518744;
	bh=MyUbM1TUVaryfVNW85VnqADb6hLX5rIrWJY/De/JpAA=;
	h=Date:To:From:Subject:From;
	b=po73WLc4dT/GFGRZvD3lREr00CnHQM/drn5YFuJ3gl7Sf/rKj4YgUmZKlv/3K99cG
	 5RDU87KIzoUIqFQxZ+coQ9liV5nRa1GO3tBZkwSAm2hteZIhHw5+jlJx1jvdUCp+E7
	 vRpVMngppXOgniKWuYkDqtq3BtmiACxY5UVf/MWc=
Date: Thu, 15 Jan 2026 15:12:23 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,cl@linux.com,bigeasy@linutronix.de,dennis@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] percpu-add-basic-double-free-check.patch removed from -mm tree
Message-Id: <20260115231224.189A0C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: add basic double free check
has been removed from the -mm tree.  Its filename was
     percpu-add-basic-double-free-check.patch

This patch was dropped because an updated version will be issued

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


