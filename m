Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0647175AA
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 19:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707248476; cv=none; b=ASmKjZTXKpMLM8dva6EaZVngZ9Ncw2CPVzUyI2h+PXdMwvezfBl4DW8sZXUGjoyCJbA1KuXLqS0eejWqmlysniSK4ypprfV7PVDPd5480E+xTIdlcie7LdvINpIbsceSnUhPEuZu5Pxo3q0crkvwLkCB7DDff7GClhONy8geyjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707248476; c=relaxed/simple;
	bh=qYUDc/t5AkQZl/4Cs210wyY/eOPS7x70e91RkAk3bnI=;
	h=Date:To:From:Subject:Message-Id; b=RR1+Z/WK3cV7/TB/tz4t681vKLPWFLCmrxZDUEIeWFcdUlqdCNd2Y/VGq5AOB8IMsfQodPsWcaTBVaA7xXPSg9HlOGf0lx9x42rjCnboO5uKLMFwfPO3vQb+HjK7Wk/VM8G2l+5QsNoOWqnDPd8sjIiezNpTdAI9Z2UiZt488qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZmPv4jD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZmPv4jD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A0AC433F1;
	Tue,  6 Feb 2024 19:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707248475;
	bh=qYUDc/t5AkQZl/4Cs210wyY/eOPS7x70e91RkAk3bnI=;
	h=Date:To:From:Subject:From;
	b=ZmPv4jD//VP2V7jC/Z+w6U7HjFmAgPIObsyVRTfkYjvP87Oa8nLNmwN4k64tl/Puk
	 j1sGJV5ofICUIeIuN9Tw9i8SP83QHQAl5LSAkyrAeVvOjz1ZOzIzL3zSF5dfeiETjF
	 iKhD72t73GxRM2vG+XkxbWXovR8fJWKay+0QPfrU=
Date: Tue, 06 Feb 2024 11:41:14 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20240206194115.56A0AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap_state: update zswap LRU's protection range with the folio locked
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-v2.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm/swap_state: update zswap LRU's protection range with the folio locked
Date: Tue, 6 Feb 2024 10:08:55 -0800

add VM_WARN_ON_ONCE() to zswap_folio_swapin()

Link: https://lkml.kernel.org/r/20240206180855.3987204-1-nphamcs@gmail.com
Reported-by: syzbot+17a611d10af7d18a7092@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000ae47f90610803260@google.com/
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zswap.c~mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-v2
+++ a/mm/zswap.c
@@ -378,6 +378,7 @@ void zswap_folio_swapin(struct folio *fo
 	struct lruvec *lruvec;
 
 	if (folio) {
+		VM_WARN_ON_ONCE(!folio_test_locked(folio));
 		lruvec = folio_lruvec(folio);
 		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_zswap_protected);
 	}
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked.patch
mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-v2.patch
mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-fix.patch
selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch
selftests-fix-the-zswap-invasive-shrink-test.patch
selftests-add-zswapin-and-no-zswap-tests.patch

