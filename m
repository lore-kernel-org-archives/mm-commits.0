Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793312089;
	b=c7JsPJ9G4bcv99VHp11olecnVrrlNcWSiXSbAHEO8OKoGIF/n/45HqCALAZ8vUKCaAPA
	 mwl14O1But0IzvS+4JzJtHS1JyRZOgUgzPvR++Oql5dTiUxgWutPfYjDBkxXnQDoaaV93
	 9CEpjxPNAuZvhhmHqADCPqYtHq2z0CSjmKYxuDhsqwumbvwU6ywix4IJZ6C01pxvTRO4Q
	 cAK7DPk+l8aGLw/TIZNLngZE5J8BW977M4TYHcHA79UKmI8I4SSXIx9m7dUy+ixl8WNwU
	 X1H7QvUYw3vPeLIKW9iIOGwzqDJIlWBoiJ1iuNAT5kf0ifpQtaPetQ+/QoviavCoDIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793312089;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=IuL5Apdarg8zdTyQndN7HMmIRjIj58PHSVoF/vRfG3E=;
	b=C+k7/b0WAj4Zm5MPMV/8/iQN7nzv395zKrG2f/rnMcLYbEKRE1qUNGiEk3ONuKYoc/M5
	 eXx1n/9Nmt5mCVhe/aknFi9KTYa7fCCJaeFQEiCHJ3KL9P3+6JKuiwgMLRAvgfbIkWK+7
	 euqNcj2H4+jgYjUl2XdNMmugWPj8TwYRyC+DhC4xbKLBRxlseS1shzAflyS28lUGeMy9+
	 QJfnnvLzlFsbTv0CAFdimimDSnT74H0UkU2+5sfgS0E0L+0ddDkzMXFu+SplsWT71lX90
	 0BDsvOmYkmeyl9Lr6I9N+8PyfWOJ3VxgqFyM85DN2nIgL7iQnt/53FSUaWg/ebRcn5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=shcxDEEq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDDA606A31A
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 22:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=shcxDEEq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3554A1F01816;
	Thu, 29 Oct 2026 22:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793312088;
	bh=IuL5Apdarg8zdTyQndN7HMmIRjIj58PHSVoF/vRfG3E=;
	h=Date:To:From:Subject;
	b=shcxDEEqfcj5GtnSrEIavp522BrCs6QExWuuxLWA0QtWVVazvCF03eFzYdYS9P56G
	 y/Yqv6ko50q8SEP4+XQEj31tP2dsO00vI9ZDInCLkThzaUznQqzf/sTxS50JaNcj8r
	 2O/QP5RaxEzrq0RmdnspmevXquQcG7HrRpGMupz4=
Date: Thu, 29 Oct 2026 15:14:47 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,
	hannes@cmpxchg.org,kuniyu@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-annotate-slow-paths-in-consume_stock-and-refill_stock.patch added to mm-new branch
Message-Id: <20261029221448.3554A1F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: memcg: annotate slow paths in consume_stock() and refill_stock().
has been added to the -mm mm-new branch.  Its filename is
     memcg-annotate-slow-paths-in-consume_stock-and-refill_stock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-annotate-slow-paths-in-consume_stock-and-refill_stock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Kuniyuki Iwashima <kuniyu@google.com>
Subject: memcg: annotate slow paths in consume_stock() and refill_stock().
Date: Thu, 29 Oct 2026 19:44:14 +0000

In consume_stock() and refill_stock(), each per-CPU stock slot
holds up to MEMCG_STOCK_HIGH (64) pages, so depleting a slot in
consume_stock() (!stock_pages) or trimming a slot in refill_stock()
(stock_pages > MEMCG_STOCK_HIGH) happens at most once per batch.

Similarly, requests larger than MEMCG_CHARGE_BATCH, local_trylock()
failure, and insufficient cached pages (stock_pages < nr_pages)
are all slow paths.

Without unlikely() annotations (when building without FDO, or
when an FDO profile does not cover a caller), Clang 23 treats
these branches as likely and inlines css_put() in consume_stock()
and memcg_uncharge() in refill_stock() right into the middle of
the hot path.

Consequently, the fast path has to jump over the inlined slow
path and jump again to the function epilogue after local_unlock().

Let's annotate the slow paths in consume_stock() and refill_stock()
with unlikely() so that the compiler keeps css_put() and
memcg_uncharge() out-of-line at the cold tail and lets local_unlock()
and the function epilogue fall through on the fast path:

Before (refill_stock):

  stock_pages = stock->nr_pages[i] + nr_pages;
   7ab2: 43 0f b6 44 26 01       movzbl  0x1(%r14,%r12), %eax
   7ab8: 01 c6                   addl    %eax, %esi
  if (stock_pages > MEMCG_STOCK_HIGH) {
   7aba: 83 fe 41                cmpl    $0x41, %esi
   7abd: 72 1d                   jb      0x7adc <refill_stock+0x21c>
  memcg_uncharge(memcg, stock_pages - MEMCG_STOCK_LOW);   # inlined
   7abf: 41 89 f7                movl    %esi, %r15d
   7ac2: 41 83 c7 e0             addl    $-0x20, %r15d
   7ac6: 48 8d bb 00 01 00 00    leaq    0x100(%rbx), %rdi
   7acd: 4c 89 fe                movq    %r15, %rsi
   7ad0: e8 00 00 00 00          callq   <page_counter_uncharge>
   7ad5: be 20 00 00 00          movl    $0x20, %esi
   7ada: eb 41                   jmp     0x7b1d <refill_stock+0x25d>
  WRITE_ONCE(stock->nr_pages[i], stock_pages);
   7adc: 43 88 74 26 01          movb    %sil, 0x1(%r14,%r12)
  local_unlock(&memcg_stock.lock);
   7ae1: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
   7ae9: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
   7af0: e9 03 fe ff ff          jmp     0x78f8 <refill_stock+0x38>

After (refill_stock):

  stock_pages = stock->nr_pages[i] + nr_pages;
   7b76: 42 0f b6 44 33 01       movzbl  0x1(%rbx,%r14), %eax
   7b7c: 01 c6                   addl    %eax, %esi
  if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
   7b7e: 83 fe 41                cmpl    $0x41, %esi
   7b81: 73 20                   jae     0x7ba3 <refill_stock+0x233>
  WRITE_ONCE(stock->nr_pages[i], stock_pages);
   7b83: 42 88 74 33 01          movb    %sil, 0x1(%rbx,%r14)
  local_unlock(&memcg_stock.lock);
   7b88: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
   7b90: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
  }
   7b97: 5b                      popq    %rbx
   7b98: 41 5e                   popq    %r14
   7b9a: 41 5f                   popq    %r15
   7b9c: 5d                      popq    %rbp
   7b9d: 2e e9 00 00 00 00       jmp     <__x86_return_thunk>
  memcg_uncharge(memcg, stock_pages - MEMCG_STOCK_LOW);
   7ba3: 83 c6 e0                addl    $-0x20, %esi
   7ba6: e8 15 f2 ff ff          callq   0x6dc0 <memcg_uncharge>
   7bab: be 20 00 00 00          movl    $0x20, %esi
   7bb0: eb d1                   jmp     0x7b83 <refill_stock+0x213>

Link: https://lore.kernel.org/20261029194452.3189365-4-kuniyu@google.com
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
---

 mm/memcontrol.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~memcg-annotate-slow-paths-in-consume_stock-and-refill_stock
+++ a/mm/memcontrol.c
@@ -2157,8 +2157,8 @@ static bool consume_stock(struct mem_cgr
 	bool ret = false;
 	int i;
 
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock))
+	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
+		     !local_trylock(&memcg_stock.lock)))
 		return ret;
 
 	stock = this_cpu_ptr(&memcg_stock);
@@ -2168,12 +2168,12 @@ static bool consume_stock(struct mem_cgr
 			continue;
 
 		stock_pages = stock->nr_pages[i];
-		if (stock_pages < nr_pages)
+		if (unlikely(stock_pages < nr_pages))
 			break;
 
 		stock_pages -= nr_pages;
 		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-		if (!stock_pages) {
+		if (unlikely(!stock_pages)) {
 			WRITE_ONCE(stock->cached[i], NULL);
 			css_put(&memcg->css);
 		}
@@ -2273,8 +2273,8 @@ static void refill_stock(struct mem_cgro
 
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock)) {
+	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
+		     !local_trylock(&memcg_stock.lock))) {
 		/*
 		 * In case of larger than batch refill or unlikely failure to
 		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
@@ -2293,7 +2293,7 @@ static void refill_stock(struct mem_cgro
 			continue;
 
 		stock_pages = stock->nr_pages[i] + nr_pages;
-		if (stock_pages > MEMCG_STOCK_HIGH) {
+		if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
 			memcg_uncharge(memcg,
 				       stock_pages - MEMCG_STOCK_LOW);
 			stock_pages = MEMCG_STOCK_LOW;
_

Patches currently in -mm which might be from kuniyu@google.com are

mm-kasan-detect-double-free-involving-kfree_rcu_sheaf.patch
mm-kasan-kunit-add-double-free-tests-involving-kfree_rcu_sheaf.patch
memcg-remove-unnecessary-read_once-under-memcg_stocklock.patch
memcg-reduce-nesting-in-consume_stock-and-refill_stock.patch
memcg-annotate-slow-paths-in-consume_stock-and-refill_stock.patch
memcg-uncharge-pages-outside-memcg_stocklock-in-refill_stock.patch

