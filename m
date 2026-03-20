Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FD233C1AD;
	Fri, 20 Mar 2026 19:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774034310; cv=none; b=m6Il32Ubs+HCYCLeGShcvxOg1COEzU0AZBeXIveJ3e8W4PzvB1d6ubsa8ubcYauBi0mbb8KCzPbKRHhYWnQ8cTT1apblhp30n5z5IyLgtl+Oelga2PzFLAuR7e53K2f7rOpTMfjGCFp4uFUEv8c453wQcbwQhiACZOH3Y6E3x1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774034310; c=relaxed/simple;
	bh=FXAUvl2mgFDs1DUh0JZrB5wp+9dH7cNGL8fPZrohgNA=;
	h=Date:To:From:Subject:Message-Id; b=awS5NUK5apnkllrgCoTyoY8WW+5LKj4jF78G1u+9NMuD1fP/9Nl1Ft5E+mbv3kZCsQPxfeGQfKWsk266Mca0GgVyFNHFMNw5CzgFlEKuoYVI/sitPdw18ix/Herd8l/xBAlxcCnpneXung9hh7TiafuxLySZMbZgdmiDZ1q94Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m4uYofSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m4uYofSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319D4C4CEF7;
	Fri, 20 Mar 2026 19:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774034310;
	bh=FXAUvl2mgFDs1DUh0JZrB5wp+9dH7cNGL8fPZrohgNA=;
	h=Date:To:From:Subject:From;
	b=m4uYofSg8rI54V6QAqIzlIiNOPss9HnrPQPV6+xjsW/3Wre+E1BDqLimVZkPLSfdL
	 vJ4I+2ArV3N4B0szpOTLNxso1tyQZMiDTnn0bm+dB2+1ZSCIJT8AuVzbv1q96Z88ci
	 jbO+CriYjT9zjnEH2Cf0CM2C00hANZ6ssjbf7THY=
Date: Fri, 20 Mar 2026 12:18:29 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-swap-cache-memcg-accounting.patch added to mm-hotfixes-unstable branch
Message-Id: <20260320191830.319D4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: fix swap cache memcg accounting
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-fix-swap-cache-memcg-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-swap-cache-memcg-accounting.patch

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
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: mm/swap: fix swap cache memcg accounting
Date: Fri, 20 Mar 2026 06:05:59 +0100

The swap readahead path was recently refactored and while doing this, the
order between the charging of the folio in the memcg and the addition of
the folio in the swap cache was inverted.

Since the accounting of the folio is done while adding the folio to the
swap cache and the folio is not charged in the memcg yet, the accounting
is then done at the node level, which is wrong.

Fix this by charging the folio in the memcg before adding it to the swap cache.

Link: https://lkml.kernel.org/r/20260320050601.1833108-1-alex@ghiti.fr
Fixes: 2732acda82c9 ("mm, swap: use swap cache as the swap in synchronize layer")
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/swap_state.c~mm-swap-fix-swap-cache-memcg-accounting
+++ a/mm/swap_state.c
@@ -494,6 +494,10 @@ static struct folio *__swap_cache_prepar
 
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
+
+	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry))
+		goto failed;
+
 	for (;;) {
 		ret = swap_cache_add_folio(folio, entry, &shadow);
 		if (!ret)
@@ -514,11 +518,6 @@ static struct folio *__swap_cache_prepar
 			goto failed;
 	}
 
-	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry)) {
-		swap_cache_del_folio(folio);
-		goto failed;
-	}
-
 	memcg1_swapin(entry, folio_nr_pages(folio));
 	if (shadow)
 		workingset_refault(folio, shadow);
_

Patches currently in -mm which might be from alex@ghiti.fr are

mm-swap-fix-swap-cache-memcg-accounting.patch

