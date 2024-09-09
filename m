Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B5D18C901
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 22:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725920548; cv=none; b=H+x2bb0ZzQ1/SCGj+TGi3F6udDUsYL4I56RXa2Qr2NEiR0B59n4rdoUznx1Iq7a3uCbUdcexqDMezhqskVRBavLidnxKU/RpAapCpChP76NfB85nDDAi9ML8ZrqFIw1nzLBM6zzA14BWTQvBwBaSXI4IdL1iC/J/LGVwrZ4FH5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725920548; c=relaxed/simple;
	bh=0CiJeqbnWJC4ZbGDI696MFZZ0F5w4wiMx0MVy1IEjFU=;
	h=Date:To:From:Subject:Message-Id; b=AnFMTjddS9VaCVnaG+DkfB3c8D9hvljPb5lSIgWwT9GWjCMHP6cHeKCS8aqV9KzFAmDjM3JvcgeBVVyxaz2vyqq++MijDsItjJLHqh4dUmpBxfCF3AMV0Kc39Ffps7XAstinB4E0yD7w51Us4+MEmaVmwtC+w4tiC2UPAM6BbEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qXxsuyMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qXxsuyMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529FEC4CEC5;
	Mon,  9 Sep 2024 22:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725920548;
	bh=0CiJeqbnWJC4ZbGDI696MFZZ0F5w4wiMx0MVy1IEjFU=;
	h=Date:To:From:Subject:From;
	b=qXxsuyMuBVDAuHQEkOdmuzqxLLkPWd+NrEWTP0d0tAza2q/TRDreAwRB2dKhsfRFu
	 Wza7xx/gDIh6DGzvgortS7WB+38IoocYY+4b9kON8rOcdzcQGKFcl1e4qCtx+fNUkR
	 oT5INJd6NzrxIKMiHeq3XqMTlSggBA9sQa0ZnXbo=
Date: Mon, 09 Sep 2024 15:22:27 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,shli@fb.com,lokeshgidra@google.com,kaleshsingh@google.com,david@redhat.com,gaoxu2@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-add-lazyfree-folio-to-lru-tail.patch removed from -mm tree
Message-Id: <20240909222228.529FEC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add lazyfree folio to lru tail
has been removed from the -mm tree.  Its filename was
     mm-add-lazyfree-folio-to-lru-tail.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: gaoxu <gaoxu2@honor.com>
Subject: mm: add lazyfree folio to lru tail
Date: Fri, 16 Aug 2024 07:48:01 +0000

Replace lruvec_add_folio with lruvec_add_folio_tail in the lru_lazyfree_fn:

1. The lazy-free folio is added to the LRU_INACTIVE_FILE list.  If
   it's moved to the LRU tail, it allows for faster release lazy-free
   folio and reduces the impact on file refault.

2. When mglru is enabled, the lazy-free folio is reclaimabled and
   should be added using lru_gen_add_folio(lruvec, folio, true) instead of
   lru_gen_add_folio(lruvec, folio, false) for adding to gen.

With the change in place, workingset_refault_file is reduced by 33% in the
continuous startup testing of the applications in the Android system.

Link: https://lkml.kernel.org/r/f29f64e29c08427b95e3df30a5770056@honor.com
Signed-off-by: gaoxu <gaoxu2@honor.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-add-lazyfree-folio-to-lru-tail
+++ a/mm/swap.c
@@ -641,7 +641,7 @@ static void lru_lazyfree(struct lruvec *
 	 * anonymous folios
 	 */
 	folio_clear_swapbacked(folio);
-	lruvec_add_folio(lruvec, folio);
+	lruvec_add_folio_tail(lruvec, folio);
 
 	__count_vm_events(PGLAZYFREE, nr_pages);
 	__count_memcg_events(lruvec_memcg(lruvec), PGLAZYFREE, nr_pages);
_

Patches currently in -mm which might be from gaoxu2@honor.com are


