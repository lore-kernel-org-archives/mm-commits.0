Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801CAA95E
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560192; cv=none; b=IQxBIrRGeUguxNU8vRY3PR1nVAMupKj+5Pl0YjiMVP8r9x+hLJwv+gvAjebHKwdrKoY/Sow5KVH5oamlYutYP1k9PD4Uy5y/ZyvKz3172brtpciqj0V8V3bOT2SYpWWdcrW2XexkoJpa//rwd39Uz8kTnh8AczORsd+1rmrdRR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560192; c=relaxed/simple;
	bh=IVKOOBLkTqQqmKizmmiTf3Xhapkvy0mRy598HZBwvGw=;
	h=Date:To:From:Subject:Message-Id; b=VcJzboVy+5uLVIW8ruM4JwZRie8jshznoAIT0kFXpY0u6FYnc0mS8/GmORvdBp08qE96pqv1DFVbH2dbeBXJW5RcSI6jZI+tKV9Xq2AEUlR4EqAWytS5c6/mYfwbTgUPCMqTJYDz3IllIi4DGhEdM/Xqgg+Orcomtfwg/4pbIiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=09q1ZYw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="09q1ZYw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B237C433C7;
	Thu, 22 Feb 2024 00:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560192;
	bh=IVKOOBLkTqQqmKizmmiTf3Xhapkvy0mRy598HZBwvGw=;
	h=Date:To:From:Subject:From;
	b=09q1ZYw9uJLnuVRdTdUZ1NMULDkxoC+ugO5i5jryRFvNUp5jLx3pHParMF+taeGrp
	 HoxuyVG9mxYnMIJSTGPUI7280zKrOVyxvXqVWTvph94O6Noqyk4Pwv6Rbf58C0Gsap
	 NRH3xEmuDYIS/rH1ot96JS1o+yDT6GP0LlwptUtk=
Date: Wed, 21 Feb 2024 16:03:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-make-too_many_isolated-return-bool.patch removed from -mm tree
Message-Id: <20240222000312.4B237C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: make too_many_isolated return bool
has been removed from the -mm tree.  Its filename was
     mm-vmscan-make-too_many_isolated-return-bool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/vmscan: make too_many_isolated return bool
Date: Mon, 5 Feb 2024 12:26:18 +0800

too_many_isolated() should return bool as does the similar
too_many_isolated() in mm/compaction.c.

Link: https://lkml.kernel.org/r/20240205042618.108140-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-make-too_many_isolated-return-bool
+++ a/mm/vmscan.c
@@ -1744,17 +1744,17 @@ bool folio_isolate_lru(struct folio *fol
  * the LRU list will go small and be scanned faster than necessary, leading to
  * unnecessary swapping, thrashing and OOM.
  */
-static int too_many_isolated(struct pglist_data *pgdat, int file,
+static bool too_many_isolated(struct pglist_data *pgdat, int file,
 		struct scan_control *sc)
 {
 	unsigned long inactive, isolated;
 	bool too_many;
 
 	if (current_is_kswapd())
-		return 0;
+		return false;
 
 	if (!writeback_throttling_sane(sc))
-		return 0;
+		return false;
 
 	if (file) {
 		inactive = node_page_state(pgdat, NR_INACTIVE_FILE);
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-page_alloc-make-bad_range-return-bool.patch

