Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3145618C02A
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 22:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725920196; cv=none; b=QzMynstNykPLmAXhceRQVIihWYZKEoz+5shjXV/3Z3xqI9N/Noc19jVOWhOOipT7suwFnQ2KuPMMsphb+nQdeASvcBJNJ9lOjBhh7dH0qKFkcLg0CSqUectyeYEUhgvCOffcKRbh1OWQ6RQDGrbR2HpcUVAw6TU0sPNHKp0Qltg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725920196; c=relaxed/simple;
	bh=6wEETWelK/vguK7mkzsyqfLCY8JcAUWfEvbSLT4MWSY=;
	h=Date:To:From:Subject:Message-Id; b=h7904fspGdYQX6lA3g4ucvb4CHJxQaAEIK7/eK9rPRILzjcVw2lRl26IuyPr3pSixipx6fetwQvH57cGftEAkPsYFIP/j/K2fBqqIRjjT2Qy/ShhClTyIrkIjibCXVRxNYCqhb0judZrFBy6luJoNDaLQSsAR/PppzdX1PaHXWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YjNMgSgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YjNMgSgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9CAC4CEC5;
	Mon,  9 Sep 2024 22:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725920195;
	bh=6wEETWelK/vguK7mkzsyqfLCY8JcAUWfEvbSLT4MWSY=;
	h=Date:To:From:Subject:From;
	b=YjNMgSgtGryiCNRzSigLLTYWTKtp1ncDm+uuchAtA2gn0QGrNFgp5ZBPTCKQ1wABC
	 L6n/rRhQHWQ3zR0piNiOfxVm4HiI4fQ8DsWpzVmOFQG9cJZJUWfAzTdFdwMVwQxSJ4
	 qje1eTNnTCno7h+eW/6s3BY8Svl9jUQq+HNT0ymE=
Date: Mon, 09 Sep 2024 15:16:35 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,hughd@google.com,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmscanc-fix-oom-on-swap-stress-test.patch removed from -mm tree
Message-Id: <20240909221635.9F9CAC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan.c: fix OOM on swap stress test
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-fix-oom-on-swap-stress-test.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chris Li <chrisl@kernel.org>
Subject: mm: vmscan.c: fix OOM on swap stress test
Date: Thu, 05 Sep 2024 01:08:17 -0700

I found a regression on mm-unstable during my swap stress test, using
tmpfs to compile linux.  The test OOM very soon after the make spawns many
cc processes.

It bisects down to this change: 33dfe9204f29b415bbc0abb1a50642d1ba94f5e9
(mm/gup: clear the LRU flag of a page before adding to LRU batch)

Yu Zhao propose the fix: "I think this is one of the potential side
effects -- Huge mentioned earlier about isolate_lru_folios():"

I test that with it the swap stress test no longer OOM.

Link: https://lore.kernel.org/r/CAOUHufYi9h0kz5uW3LHHS3ZrVwEq-kKp8S6N-MZUmErNAXoXmw@mail.gmail.com/
Link: https://lkml.kernel.org/r/20240905-lru-flag-v2-1-8a2d9046c594@kernel.org
Fixes: 33dfe9204f29 ("mm/gup: clear the LRU flag of a page before adding to LRU batch")
Signed-off-by: Chris Li <chrisl@kernel.org>
Suggested-by: Yu Zhao <yuzhao@google.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Closes: https://lore.kernel.org/all/CAF8kJuNP5iTj2p07QgHSGOJsiUfYpJ2f4R1Q5-3BN9JiD9W_KA@mail.gmail.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscanc-fix-oom-on-swap-stress-test
+++ a/mm/vmscan.c
@@ -4300,7 +4300,7 @@ static bool sort_folio(struct lruvec *lr
 	}
 
 	/* ineligible */
-	if (zone > sc->reclaim_idx) {
+	if (!folio_test_lru(folio) || zone > sc->reclaim_idx) {
 		gen = folio_inc_gen(lruvec, folio, false);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
_

Patches currently in -mm which might be from chrisl@kernel.org are


