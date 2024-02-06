Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C086717551
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 19:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707248477; cv=none; b=Iftm/IsAZZQiUJJ2mYk/pkc3BS/ezPQfNt9necWF8Yz0SVmvNK7NnRerQPZi6KuhCBn10bUrXwEgUxKvUAowuYDD7La6O3DSet/zRKGb8ChKitAyUcZJzWWZi3mbmSZ1T49N/1gLjM1ngfa//ozgMPAB9juQpDXeQQwphn0cpuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707248477; c=relaxed/simple;
	bh=tYtpYRW6BeMIoRJ82QYbEr9h0SECl9juhSCjNxqMBAs=;
	h=Date:To:From:Subject:Message-Id; b=l4kp3azEgIpwuonCIXsGn3MigltRqtZKck8DTV2QSN4vkrnyvr+tbBBYsic6V+TBx47LelU1prZaMHyelDxcnu2aHFqkJh9KJV5vR9Pm0NK1q1rZsbcSnLfZEzhb+YS4nr0B7InSBbA7l3vkBcIPP9nMtTmbj7F/NfqAzrNt/ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=03ppBwLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="03ppBwLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AFBC433F1;
	Tue,  6 Feb 2024 19:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707248477;
	bh=tYtpYRW6BeMIoRJ82QYbEr9h0SECl9juhSCjNxqMBAs=;
	h=Date:To:From:Subject:From;
	b=03ppBwLxrXKL4DX7ieW3av+yg7736QYEpLap7s/SVwAvbzDT+08Fmsx/CgDQ3a0YV
	 xbNRfQy6Yl8snq6nObByvJpsi2c3vLdjLleNdv1z/ccesxSF9GWTAb4aL0RbN2sxFD
	 2056WotIsW7skH6q4mgxlDv3jF0XxOWIIAM61bTU=
Date: Tue, 06 Feb 2024 11:41:16 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240206194117.39AFBC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap_state: update zswap LRU's protection range with the folio locked (fix)
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-fix.patch

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
Subject: mm/swap_state: update zswap LRU's protection range with the folio locked (fix)
Date: Tue, 6 Feb 2024 11:13:55 -0800

The if (folio) checks inside zswap_folio_swapin() is no longer needed.

Link: https://lkml.kernel.org/r/20240206191355.83755-1-nphamcs@gmail.com
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/zswap.c~mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-fix
+++ a/mm/zswap.c
@@ -377,11 +377,9 @@ void zswap_folio_swapin(struct folio *fo
 {
 	struct lruvec *lruvec;
 
-	if (folio) {
-		VM_WARN_ON_ONCE(!folio_test_locked(folio));
-		lruvec = folio_lruvec(folio);
-		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_zswap_protected);
-	}
+	VM_WARN_ON_ONCE(!folio_test_locked(folio));
+	lruvec = folio_lruvec(folio);
+	atomic_long_inc(&lruvec->zswap_lruvec_state.nr_zswap_protected);
 }
 
 /*********************************
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked.patch
mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-v2.patch
mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-fix.patch
selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch
selftests-fix-the-zswap-invasive-shrink-test.patch
selftests-add-zswapin-and-no-zswap-tests.patch

