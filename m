Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72524E2F34;
	Wed, 16 Sep 2026 23:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789601455; cv=none; b=Gfc/tQopgAoxA8YcfsLCTZBL5cHdMdRV/uBEh5+fwFmMY4Guj7EN3BGWMmV7ftqTUzxTj/HtUOte9cBDqSwk11j0+b/SzYZZMQHNaVz0LkdI0KZzIMu7E6gjtrIe7h0ul8ibqwsMjwg96MhnOqX9hhlylyau+kE69F6522y4NPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789601455; c=relaxed/simple;
	bh=9AxbLDevJrGiwfcOvJZLUy54lMxteaDV8emCm/SPYz8=;
	h=Date:To:From:Subject:Message-Id; b=r/wEdDYkeZa+/IkWczKXVI2hXnPaLjwSDF9msBgQDgS7RZN7iJSCl8Nv3as6LaevE6C+sn1QRIK4hQ3FxQeoCCDzFoZoQy8g70WohBrW4xNGtsYaa8kyayAzi7yOVrCDuAxbYHiDeQtQEW0q7LvUS3ovomQwRh35TzLWhAgCjY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aiaOcKZX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aiaOcKZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5092F1F000FF;
	Wed, 16 Sep 2026 23:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789601453;
	bh=medF6QiKoAjc56gVi4ShMciMQcY7liVwqRF8W3Q5Jc0=;
	h=Date:To:From:Subject;
	b=aiaOcKZXfFI46r8SpmIEak332RST0T89DKJ8N4lFtNBixLSPWqCuxKQHc0+Wbfh88
	 L7ckuDPIdfa8b8N6mZdcV1ezyzlgzHC5hSS8EdXy1uolbD2x2NAEmjKtxsDoufgcF8
	 5hMJ/hQID6NFEaOoJbENShmRZeIMWynduzgLivLQ=
Date: Wed, 16 Sep 2026 16:30:52 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,arnd@arndb.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscanc-fix-min-signedness-mismatch.patch added to mm-hotfixes-unstable branch
Message-Id: <20260916233053.5092F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan.c: fix min() signedness mismatch
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscanc-fix-min-signedness-mismatch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscanc-fix-min-signedness-mismatch.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/vmscan.c: fix min() signedness mismatch
Date: Wed Sep 16 04:21:22 PM PDT 2026

A __noipa conversion from Arnd [1] somehow revealed a longstanding min()
error in read_ctrl_pos().  Plug it with min_t().

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscanc-fix-min-signedness-mismatch
+++ a/mm/vmscan.c
@@ -3205,7 +3205,7 @@ static void read_ctrl_pos(struct lruvec
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier % MAX_NR_TIERS; i <= min_t(unsigned int, tier, MAX_NR_TIERS - 1); i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscanc-fix-min-signedness-mismatch.patch
mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

