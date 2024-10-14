Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B461717BD3
	for <mm-commits@vger.kernel.org>; Mon, 14 Oct 2024 23:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728948415; cv=none; b=hFGp+FvHnQSoLe9eKid6r8800Dy0Tq10LzAkge2z6dunHZRESC8lXasU4oeraQFAkzrBatnauZQj3RpV5tcRPk0UvTjdbWMcJWD44OiL8aU8s6qKKS3TtdjqYozCJfjaWt48IBpgprET6SSqFTVRJm3XrsdnJSC1DqplQB52LCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728948415; c=relaxed/simple;
	bh=Rjad/p8sP6aUi4htnVJeH6+5BJwzHq5MJW9eXy/ztbw=;
	h=Date:To:From:Subject:Message-Id; b=Cu5n8liG5cK5IKDtuszZqqOH/2md0JeXSWALpiHh1cyfLYC5Yv/UksQYs4aAwqQZDI1QDQ98Rs2MfCZV8bi1uGHvDMrRozD5liFqbH20CjMRZThRNPgFgJxGxsr/Qok7FX1LeY43AjVBZLVh2Q5Iq+eneDH3Q9K7QvrX+MCFXrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZOWCi0mk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZOWCi0mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668A5C4CEC3;
	Mon, 14 Oct 2024 23:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728948415;
	bh=Rjad/p8sP6aUi4htnVJeH6+5BJwzHq5MJW9eXy/ztbw=;
	h=Date:To:From:Subject:From;
	b=ZOWCi0mkpwQm09VVZC+ukzSf4Rh8i+QXQfBpP6IUjDnuWdXftR+N30WfGz5/yfTwv
	 6W2lLerFnjfDNlM03ZW0O+I+Ax47OshlDPIpOJdl5owT2W5tqh4LEz2q4JdYZCWKSq
	 RsHqzP1VgVtQ9jW9LVz0kRgN8eO3453ICcKe/3yw=
Date: Mon, 14 Oct 2024 16:26:54 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,suleiman@google.com,heftig@archlinux.org,bgeffon@google.com,axelrasmussen@google.com,weixugc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-only-clear-kswapd_failures-if-reclaimable.patch added to mm-unstable branch
Message-Id: <20241014232655.668A5C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: only clear kswapd_failures if reclaimable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-only-clear-kswapd_failures-if-reclaimable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-only-clear-kswapd_failures-if-reclaimable.patch

This patch will later appear in the mm-unstable branch at
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
From: Wei Xu <weixugc@google.com>
Subject: mm/mglru: only clear kswapd_failures if reclaimable
Date: Mon, 14 Oct 2024 22:12:11 +0000

lru_gen_shrink_node() unconditionally clears kswapd_failures, which can
prevent kswapd from sleeping and cause 100% kswapd cpu usage even when
kswapd repeatedly fails to make progress in reclaim.

Only clear kswap_failures in lru_gen_shrink_node() if reclaim makes some
progress, similar to shrink_node().

Link: https://lkml.kernel.org/r/20241014221211.832591-1-weixugc@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Wei Xu <weixugc@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jan Alexander Steffens <heftig@archlinux.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-mglru-only-clear-kswapd_failures-if-reclaimable
+++ a/mm/vmscan.c
@@ -4976,8 +4976,8 @@ static void lru_gen_shrink_node(struct p
 
 	blk_finish_plug(&plug);
 done:
-	/* kswapd should never fail */
-	pgdat->kswapd_failures = 0;
+	if (sc->nr_reclaimed > reclaimed)
+		pgdat->kswapd_failures = 0;
 }
 
 /******************************************************************************
_

Patches currently in -mm which might be from weixugc@google.com are

mm-mglru-only-clear-kswapd_failures-if-reclaimable.patch
mm-mglru-reset-page-lru-tier-bits-when-activating.patch

