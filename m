Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A65919409A
	for <mm-commits@vger.kernel.org>; Thu,  5 Sep 2024 21:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725572536; cv=none; b=iHImV61cSh5z1xa0IBF3plGZNlW+tnklTObSEoMolKtwgcGv397Og6Or4xwGh3VJCADzlXA4GCbPFoSz6kRH2tARXkN1aSC5uYQWHXP8soSjy2JALavbulak5zgaDRreXrNc3Be6LUMTjEHT8tIMDPe2jEvOX97CQJwhMo4ot5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725572536; c=relaxed/simple;
	bh=j6gFdH7+eBpfQZ3eltgpPvtjcUSzKmHENwztqTEz1pk=;
	h=Date:To:From:Subject:Message-Id; b=U7oQ+8R6bnMqYqgLfLVInYelEOF75sZ6xcKA4Y66XMYtl9/8yIzKO88huhkqaQky2hyBoffAzW1UBPxYQtERmjQCGLCAlGC62y2Pd/VyhxjnXqQ91YxwpS0k6bGJKfxgpjx7PU8ER8UZC/fiEUl2GAbyp7HIGNJQKHGr77h6GOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ViyLcVd6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ViyLcVd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2703BC4CEC3;
	Thu,  5 Sep 2024 21:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725572536;
	bh=j6gFdH7+eBpfQZ3eltgpPvtjcUSzKmHENwztqTEz1pk=;
	h=Date:To:From:Subject:From;
	b=ViyLcVd6EqmAsZ/+Df9ovPDcmAjcCy6KXNj+3lv3ytnGcAoRaugFyflEJ5OHXz1Dg
	 00bDFSR4/7hYJWNg79RPb/FDIpYpr92ZE6jtnaOAV/LpOQD/AZ5405WA7zaRh6tg1h
	 nc9dJWj+5xoqwEdmWnWieGppgbmfXXenqqZD7Kes=
Date: Thu, 05 Sep 2024 14:42:15 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,hughd@google.com,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscanc-fix-oom-on-swap-stress-test.patch added to mm-hotfixes-unstable branch
Message-Id: <20240905214216.2703BC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan.c: fix OOM on swap stress test
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscanc-fix-oom-on-swap-stress-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscanc-fix-oom-on-swap-stress-test.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-vmscanc-fix-oom-on-swap-stress-test.patch

