Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FDE25779
	for <mm-commits@vger.kernel.org>; Sun,  4 Aug 2024 11:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722772032; cv=none; b=MQrW3g+Q4y471V1FPVxPiztNAw9ZV0GLZ7d1eFDmGxb2xDEFEOIJVZVymf9yIHNgnp2rI/Yh5kzGNq/thXnNLWn8a0giiUud+9iDfafdQldNlvfP/sLoYiaLYTkWZBDoFweR3nxGNz4XcfbJDx8TLkOUTpl7spBH5HRAr1t+z4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722772032; c=relaxed/simple;
	bh=f0MdTP7ypkW1nNqXU1w4yVeIGVO2DfdiJ82y0aJW3Pg=;
	h=Date:To:From:Subject:Message-Id; b=uPwZYCm3kw78vusnmBj0AP09gnrnbJTxxBZcFoQOmTceTiLTQRYErd+/VsWrQxXIEW/aApXt7w157xTs6E33/lgkj/HrgBNUL4UBTdtabliuiI/RJomZK7y/Qc29SaUTiosVD2EtQbFhDhUuX5+psUlk/8POelbxGTh7AanjyYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gmh5xchE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gmh5xchE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CCAC32786;
	Sun,  4 Aug 2024 11:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722772031;
	bh=f0MdTP7ypkW1nNqXU1w4yVeIGVO2DfdiJ82y0aJW3Pg=;
	h=Date:To:From:Subject:From;
	b=gmh5xchEiblIRKjrCQaliqHY/ijpkGYJxoxf7/Mrg2cM5l48dhE39y4IXHe4Pxwg9
	 ctkkvZlgIX3fftG2sdrEoT6kumGuXI+RzO2clsy0W66wxXqQywjOnyw0DrE0zVjywx
	 XaNSn01WeGOiOLnJ7Vjj2gCqSZLXte+tjdE5Ioh0=
Date: Sun, 04 Aug 2024 04:47:10 -0700
To: mm-commits@vger.kernel.org,21cnbao@gmail.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-remove-boilerplate-fix.patch removed from -mm tree
Message-Id: <20240804114711.76CCAC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-remove-boilerplate-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-boilerplate-fix.patch

This patch was dropped because it was folded into mm-swap-remove-boilerplate.patch

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm-swap-remove-boilerplate-fix
Date: Fri, 26 Jul 2024 00:50:04 -0600

fix "BUG: using smp_processor_id() in preemptible"

Link: https://lkml.kernel.org/r/ZqNHHMiHn-9vy_II@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/swap.c~mm-swap-remove-boilerplate-fix
+++ a/mm/swap.c
@@ -220,7 +220,7 @@ static void folio_batch_move_lru(struct
 	folios_put(fbatch);
 }
 
-static void __folio_batch_add_and_move(struct folio_batch *fbatch,
+static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		struct folio *folio, move_fn_t move_fn,
 		bool on_lru, bool disable_irq)
 {
@@ -233,16 +233,14 @@ static void __folio_batch_add_and_move(s
 		return;
 	}
 
-	if (folio_batch_add(fbatch, folio) && !folio_test_large(folio) &&
-	    !lru_cache_disabled())
-		return;
-
 	if (disable_irq)
 		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
 	else
 		local_lock(&cpu_fbatches.lock);
 
-	folio_batch_move_lru(fbatch, move_fn);
+	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) || folio_test_large(folio) ||
+	    lru_cache_disabled())
+		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
 	if (disable_irq)
 		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
@@ -252,7 +250,7 @@ static void __folio_batch_add_and_move(s
 
 #define folio_batch_add_and_move(folio, op, on_lru)						\
 	__folio_batch_add_and_move(								\
-		this_cpu_ptr(&cpu_fbatches.op),							\
+		&cpu_fbatches.op,								\
 		folio,										\
 		op,										\
 		on_lru,										\
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch
mm-swap-reduce-indentation-level.patch
mm-swap-rename-cpu_fbatches-activate.patch
mm-swap-fold-lru_rotate-into-cpu_fbatches.patch
mm-swap-remove-remaining-_fn-suffix.patch
mm-swap-remove-boilerplate.patch

