Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC2622092
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725246416; cv=none; b=Fy3HO/sEJkGwRnaF3KXshlkzQGUQfX/asFJ1O+MdMPBrIfM3bq5V6MqPXo1ZVGVitM1ePEqd80iFUUvHg0DH59T6ZdCm+Kj+NNZN8mI486k8y7YjBPtqNfgucEZ0Q/qv5Po0EhJgoNqBJO1/1mRvbhJ/uqD2HKRtQPJVl9WHYlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725246416; c=relaxed/simple;
	bh=GMM1/J4DZh3h5WHGZ5ESDj2PSKQuKUBizo880B5yIvo=;
	h=Date:To:From:Subject:Message-Id; b=OCzEpZKleWAmk16KkCwSu+w4bFh3Qu/ek9458NjsErN82HroYKxS70xfN9xS5G0QYKCLTV1FcwWEX1VQIKupEdMIPXQ5wIvB3/gWFh8hX7p3CvaGJT2xSFLGVVWoKUPZNwOWLCSMh/yEpRJDIW3xbCaCFrpdpCwIL9MtDws/PKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qbgbmMtG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qbgbmMtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A2EC4CEC3;
	Mon,  2 Sep 2024 03:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725246416;
	bh=GMM1/J4DZh3h5WHGZ5ESDj2PSKQuKUBizo880B5yIvo=;
	h=Date:To:From:Subject:From;
	b=qbgbmMtGzy0cUGQAqSyQvVLSDr04PkeXkWb1FXsfqo0naE9xDqAH3v9Ah9XJ3JWxt
	 BaTfOExxGNTseICoHpIt1RWGyVrS4J7ooG+n0ZclWr8ANWlTcMMrdQk0NJ4aWmPgMU
	 9JoQLgl9yTVAmSr/N3xUVza1iXYU/pb/DWnybx1g=
Date: Sun, 01 Sep 2024 20:06:55 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-remove-boilerplate-fix.patch removed from -mm tree
Message-Id: <20240902030656.05A2EC4CEC3@smtp.kernel.org>
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
Date: Sun, 4 Aug 2024 15:36:31 -0600

handle zero-length local_lock_t

Link: https://lkml.kernel.org/r/Zq_0X04WsqgUnz30@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Hugh Dickins <hughd@google.com>
Tested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-swap-remove-boilerplate-fix
+++ a/mm/swap.c
@@ -254,7 +254,7 @@ static void __folio_batch_add_and_move(s
 		folio,										\
 		op,										\
 		on_lru,										\
-		offsetof(struct cpu_fbatches, op) > offsetof(struct cpu_fbatches, lock_irq)	\
+		offsetof(struct cpu_fbatches, op) >= offsetof(struct cpu_fbatches, lock_irq)	\
 	)
 
 static void lru_move_tail(struct lruvec *lruvec, struct folio *folio)
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch
mm-swap-reduce-indentation-level.patch
mm-swap-rename-cpu_fbatches-activate.patch
mm-swap-fold-lru_rotate-into-cpu_fbatches.patch
mm-swap-remove-remaining-_fn-suffix.patch
mm-swap-remove-boilerplate.patch
mm-hugetlb_vmemmap-batch-hvo-work-when-demoting.patch
mm-contig_alloc-support-__gfp_comp.patch
mm-cma-add-cma_allocfree_folio.patch
mm-cma-add-cma_allocfree_folio-fix.patch
mm-hugetlb-use-__gfp_comp-for-gigantic-folios.patch
mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch
mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch

