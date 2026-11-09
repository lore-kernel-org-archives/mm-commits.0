Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794245567;
	b=UI3PUpGbmT5WHtIKCSyoLbv8cKQ44wCGItr+pMDFMqoFPOXRAprepu3B6Yi22yULOywc
	 vqLkJvavfdJW9DcoavrLYn3XOEXr8IJgsrcCPwVSfYvh8f22L1SEBArPlQLySZICiadAn
	 6MSyoPXxfT7woLLZfcYgxmIQoUN2bZY9rt48MEXXjkFkju7k/kqbKY2f6WCR1njydKUMU
	 7GagFbznTvCwYXFxINiB+0rtzZQSYx+T0ZvTuw63K28dt93cOqTSadWA8LBfdI7gco1xQ
	 Zbmcqad+FRdFt3yzVV7GTKS+kyN4BQd7GH29GvnVaKNGpjFENHlRvctVaWdhIH9BuAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794245567;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=b1Q4RphqPpL0ABKOLfwzKjea9PUjfhburkyzX5PF8Rc=;
	b=o2vUbbLNKkkAR/r8IQQmQhAOYg8w2OeGjxBqJOxvMv0whle83BNImysoo1t6fMaAOxml
	 c8Ucf/O9acmYG1QOeb1JYzrZxfedD1paI/VXU68/pajJgZB0lvyGiM7fgMv6qlhxnWKfJ
	 jH+RPO5n89mfFM86ZUr2dX4rvmBnCwZHbUKO8vWSMfxgg61IqD7W9Q59f5d4OLsmtgqQm
	 IiGomwsCLj7+vkwaDltugubDnwwTFuN+UacEDhl7zGwvf5RO4VwpCElFIWiuvPeBeyNYj
	 9RyWi/+1K3uuZJ+eTTELRfYDPir9VjuqNbB5dfVPtfWJpnET/+wJ09efJhSz0MhlN4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LpJJD2l5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7C5606A333;
	Mon,  9 Nov 2026 17:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LpJJD2l5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A559D1F008A1;
	Mon,  9 Nov 2026 17:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794245566;
	bh=b1Q4RphqPpL0ABKOLfwzKjea9PUjfhburkyzX5PF8Rc=;
	h=Date:To:From:Subject;
	b=LpJJD2l55ceQ/HId13hO7+flZMvX6MSHYeJjdlzk602YSHwZBGFCrSEpyww3+N+Zy
	 fT+9NiNP51MyKCx+xViNG0emgrLZrYo7vVNPZWyuxh58IKOZeiX4LEfXlOWW5s4iM5
	 EFFVPsyZ7bLTdnj5gipqMH63yC39arH/yTM0UjvM=
Date: Mon, 09 Nov 2026 09:32:46 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,david@kernel.org,
	baoquan.he@linux.dev,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-bail-out-if-in-softirq-context.patch added to mm-hotfixes-unstable branch
Message-Id: <20261109173246.A559D1F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vmalloc: bail out if in softirq context
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-bail-out-if-in-softirq-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-bail-out-if-in-softirq-context.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-vmalloc-bail-out-if-in-softirq-context.patch
mm-vmalloc-use-dedicated-unbound-workqueues-for-vmap-drain.patch

