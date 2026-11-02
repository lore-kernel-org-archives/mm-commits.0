Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793633364;
	b=wY0/zJ01wlqy5qmDAMPYKHgeKnUUmmafYub6Rf/2k1meTOvtnm2jSbzvyO0ejXxKeA2s
	 hs/s++ufq8Tgaedkk+osVg/ijHLpAtzdxIBiqol7mPgLIWgcePumN6RzaTfIHL+W9EhMN
	 GcTtRUG0U3C1+np31orLDpkGB/gxtq5aE0sSQrGB2e86xD7q4ieA7wXp4Ho8tXJk3/FCq
	 IiQkkVZHGxj+c0wqE8xdX+ZSANjgrJ1Zd317al8DordE7MHo0oFI5IvRBUHGSo/PxSFKe
	 5qCcfxux8YGsyIVq/vf31DrQal3HEs6qAnUJDtXnQmeKAAOCpxNMAin7+6CfsWUHZLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793633364;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=bnCyI5uGFtn9RHe75cGgPIK8StUpPFt5c7ZKI1cHgPk=;
	b=Hy1bi90AR8YSHobKlnFgAVvoGGnmTMDxKEJ3N1XWahmRoIPBqHHQPjls5iX7Foaw1Ic3
	 ZiI9r1MjL7Z1lFgbSkcon2HeFp4AQOUIQuWbTKWdt5FbZwZ1juQhqKmVyBVuMxhDSQNUe
	 j5qVhbx9PeTGXvtFFuDFtdNIkGt6v4mV2E/FyXIi70Wvhnt3/pCyGnMPfIyV80WZuJCPf
	 FTzDbr7X01/jU9FkzDKLJe4pWfB0WuSLPJ3nIDxL/MhIHqoe4TtZhcpzgMG3BChmOSc5b
	 VJRgfYT27ZzcHh/gCvqQT1ixQNWCXQrW9ZSzk8kjiEzD5SHmiCp6wutMRic4xFJ9KKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC29606AB8B;
	Mon,  2 Nov 2026 15:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502EF1F00A16;
	Mon,  2 Nov 2026 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793633363;
	bh=bnCyI5uGFtn9RHe75cGgPIK8StUpPFt5c7ZKI1cHgPk=;
	h=Date:To:From:Subject;
	b=D81NOHqrDVGMSE0LVhQvFoY4UTCqN0h2r+X8dSNJmmUFoAefqhYasbCuU1sZFjNFf
	 wO5qouFc9R9F4N9xKsAZ+kt9aIjt10lbP6H7PNIbX8uGso5seW4FlUZTr1TE3Y6bp1
	 u5dqBsGKdFWgjZ187ntZoFWMRmy0MgKfgoK1XH68=
Date: Mon, 02 Nov 2026 07:29:20 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,david@kernel.org,
	baoquan.he@linux.dev,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-bail-out-if-in-softirq-context.patch removed from -mm tree
Message-Id: <20261102152923.502EF1F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vmalloc: bail out if in softirq context
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-bail-out-if-in-softirq-context.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: bail out if in softirq context
Date: Mon, 26 Oct 2026 11:25:03 +0100

vmalloc() is not allowed to be invoked from the NMI, hard-irq and softirq
contexts because doing so may deadlock on internal locks.

Commit 04aa71da5f35 ("mm/vmalloc: do not trigger BUG() on BH disabled
context") replaced the deprecated in_interrupt() macro with explicit
in_nmi() and in_hardirq() checks, but unintentionally dropped the softirq
context check.

Example:

<snip>
vzalloc() in a task
 spin_lock(&vn->busy.lock)
  <------ Hard irq
   irq_exit()
    process softirq on the same CPU
     vmalloc()
      spin_lock(&vn->busy.lock)
       spins forever
<snip>

Restore the check by checking the caller's context with the
in_serving_softirq() helper.  Note that, it is still allowed to invoke
vmalloc() with disabled bottom halves.

Replace BUG_ON() with WARN_ON_ONCE() for in_nmi() and
in_hardirq() case.

Link: https://lore.kernel.org/20261026102503.30860-1-urezki@gmail.com
Fixes: 04aa71da5f35 ("mm/vmalloc: do not trigger BUG() on BH disabled context")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/vmalloc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-bail-out-if-in-softirq-context
+++ a/mm/vmalloc.c
@@ -3258,7 +3258,13 @@ struct vm_struct *__get_vm_area_node(uns
 	struct vm_struct *area;
 	unsigned long requested_size = size;
 
-	BUG_ON(in_nmi() || in_hardirq());
+	/* IRQ re-entrancy -> irq_exit() -> process softirq. */
+	if (in_serving_softirq())
+		return NULL;
+
+	if (WARN_ON_ONCE(in_nmi() || in_hardirq()))
+		return NULL;
+
 	size = ALIGN(size, 1ul << shift);
 	if (unlikely(!size))
 		return NULL;
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-use-dedicated-unbound-workqueues-for-vmap-drain.patch

