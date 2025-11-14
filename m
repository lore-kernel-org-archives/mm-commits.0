Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547E0284672
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 20:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763151194; cv=none; b=LEweSrKsbjHDy1cUw72YcR1hZ8s5bBZqmjG/nM/fdFgEBwL0c3Yr0g1H2lZBomoZAG68yjEDFjmmoQ34uqXkGfnT0aSxPDkvo3Q4B9nWv8dmb00oOm5DEm1Ew53XwDzMi7/bdYBhDOGQG/4oa/2N85Vy2iIkJbgugcFQ4SzGzMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763151194; c=relaxed/simple;
	bh=KyTZHj04Tl0mrG5wRjmRgEBfsax5t0G1tpaNWcTtDD0=;
	h=Date:To:From:Subject:Message-Id; b=qZB3KxXO9u/kAmbMD7Ku7DdoOSwjg0WXXKcA4od3kT4QLtx0TBXC+SOgtJGZiGmMMxapmO1hsbRfOiyQRaOqSP4UZ3CAF2MWnWqU8tgBcNY1Fzl1EDp/Bu8asizF+CkI/VIHlm1iFPZ1kUA5/VNtA5oGPmEx/OVqyg0HWH4ugnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e43FUZAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e43FUZAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF048C4CEF5;
	Fri, 14 Nov 2025 20:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763151193;
	bh=KyTZHj04Tl0mrG5wRjmRgEBfsax5t0G1tpaNWcTtDD0=;
	h=Date:To:From:Subject:From;
	b=e43FUZArzkUixe2eiKopmfVqx6dqIKnxOuZW9RhO3V3q4tJqguJ1o+iwZlvEexmzO
	 E5aE3r5KSYbyl7rXV3wUvtWAo0t55R2w0McR2apf2vNiJx0xW+Nx33Z7v+JJzVp12T
	 jnv6qCRCS25C58Qbk86cw16rVc90nAVJ8CA7H3O8=
Date: Fri, 14 Nov 2025 12:13:13 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,vbabka@suse.cz,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,cl@gentwo.org,bigeasy@linutronix.de,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mempool-clarify-behavior-of-mempool_alloc_preallocated.patch removed from -mm tree
Message-Id: <20251114201313.AF048C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mempool: clarify behavior of mempool_alloc_preallocated()
has been removed from the -mm tree.  Its filename was
     mempool-clarify-behavior-of-mempool_alloc_preallocated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: mempool: clarify behavior of mempool_alloc_preallocated()
Date: Tue, 14 Oct 2025 14:17:23 +0200

The documentation of that function promises to never sleep.  However on
PREEMPT_RT a spinlock_t might in fact sleep.

Reword the documentation so users can predict its behavior better.

mempool could also replace spinlock_t with raw_spinlock_t which doesn't
sleep even on PREEMPT_RT but that would take away the improved
preemptibility of sleeping locks.

Link: https://lkml.kernel.org/r/20251014-mempool-doc-v1-1-bc9ebf169700@linutronix.de
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempool.c~mempool-clarify-behavior-of-mempool_alloc_preallocated
+++ a/mm/mempool.c
@@ -461,8 +461,8 @@ EXPORT_SYMBOL(mempool_alloc_noprof);
  *             mempool_create().
  *
  * This function is similar to mempool_alloc, but it only attempts allocating
- * an element from the preallocated elements. It does not sleep and immediately
- * returns if no preallocated elements are available.
+ * an element from the preallocated elements. It only takes a single spinlock_t
+ * and immediately returns if no preallocated elements are available.
  *
  * Return: pointer to the allocated element or %NULL if no elements are
  * available.
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are


