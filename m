Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF933610D
	for <mm-commits@vger.kernel.org>; Sat, 12 Oct 2024 22:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728771376; cv=none; b=IZgvsc0Z7TXnesriw7Stf0vi7cJwcz5otQeWQUHNG7/zE7e5dmpP4jXLjFnfxdh7jU2UAT1yz6nEe1FuBp4/kkv4v3spZFrLA6qb+2US8TVh859ueeLfqsOMt217nnpzTUuqDPOimHUSUrMzZ6jsMC4uj6j865xa1Y5UK0NYFZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728771376; c=relaxed/simple;
	bh=lO2M06REcATaK4FgRsRD0fKakz6M34LmNCI0WqE7jL8=;
	h=Date:To:From:Subject:Message-Id; b=RwnXb3gkxh4cosuXlUGD39tnaQBit4Xy2IazJH1lmjNWKmweV1Ru3HcQ5DMqJ0YUFWsU4Deic1y3Mq4Jt7zAhtrdqpV1nXXupWVQkPuWEhOXIy8+1hAMh4TldluOBYy41se5jsb84iLwd59bFLfobKqBRXeCyMnSkIoyDBnazkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2CM0a6ba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2CM0a6ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754D8C4CEC6;
	Sat, 12 Oct 2024 22:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728771375;
	bh=lO2M06REcATaK4FgRsRD0fKakz6M34LmNCI0WqE7jL8=;
	h=Date:To:From:Subject:From;
	b=2CM0a6babfJaLNLY2k2/koL6iR79iAWTwHcVECX5EPmv9T0fFpBUftgRUMAJTDdRU
	 zkkfzdQ+rzfz9FATQMF6OkKDM2sEetBldETisvDmGcAeb/iEwsCb0Ul7qrE1b9ZeDa
	 2MNXcgYKr6u7brdVUWxfquR1Xp+aUm4TTrpNqa4Y=
Date: Sat, 12 Oct 2024 15:16:14 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,v-songbaohua@oppo.com,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,chengming.zhou@linux.dev,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-avoid-touching-xarray-for-unnecessary-invalidation.patch added to mm-unstable branch
Message-Id: <20241012221615.754D8C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: avoid touching XArray for unnecessary invalidation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-avoid-touching-xarray-for-unnecessary-invalidation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-avoid-touching-xarray-for-unnecessary-invalidation.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/zswap: avoid touching XArray for unnecessary invalidation
Date: Sat, 12 Oct 2024 01:19:50 +0800

zswap_invalidation simply calls xa_erase, which acquires the Xarray lock
first, then does a look up.  This has a higher overhead even if zswap is
not used or the tree is empty.

So instead, do a very lightweight xa_empty check first, if there is
nothing to erase, don't touch the lock or the tree.

Using xa_empty rather than zswap_never_enabled is more helpful as it cover
both case where zswap wes never used or the particular range doesn't have
any zswap entry.  And it's safe as the swap slot should be currently
pinned by caller with HAS_CACHE.

Sequential SWAP in/out tests with zswap disabled showed a minor
performance gain, SWAP in of zero page with zswap enabled also showed a
performance gain.  (swapout is basically unchanged so only test one case):

Swapout of 2G zero page using brd as SWAP, zswap disabled
(total time, 4 testrun, +0.1%):
Before: 1705013 us 1703119 us 1704335 us 1705848 us.
After:  1703579 us 1710640 us 1703625 us 1708699 us.

Swapin of 2G zero page using brd as SWAP, zswap disabled
(total time, 4 testrun, -3.5%):
Before: 1912312 us 1915692 us 1905837 us 1912706 us.
After:  1845354 us 1849691 us 1845868 us 1841828 us.

Swapin of 2G zero page using brd as SWAP, zswap enabled
(total time, 4 testrun, -3.3%):
Before: 1897994 us 1894681 us 1899982 us 1898333 us
After:  1835894 us 1834113 us 1832047 us 1833125 us

Swapin of 2G random page using brd as SWAP, zswap enabled
(total time, 4 testrun, -0.1%):
Before: 4519747 us 4431078 us 4430185 us 4439999 us
After:  4492176 us 4437796 us 4434612 us 4434289 us

And the performance is very slightly better or unchanged for
build kernel test with zswap enabled or disabled.

Build Linux Kernel with defconfig and -j32 in 1G memory cgroup,
using brd SWAP, zswap disabled (sys time in seconds, 6 testrun, -0.1%):
Before: 1648.83 1653.52 1666.34 1665.95 1663.06 1656.67
After:  1651.36 1661.89 1645.70 1657.45 1662.07 1652.83

Build Linux Kernel with defconfig and -j32 in 2G memory cgroup,
using brd SWAP zswap enabled (sys time in seconds, 6 testrun, -0.3%):
Before: 1240.25 1254.06 1246.77 1265.92 1244.23 1227.74
After:  1226.41 1218.21 1249.12 1249.13 1244.39 1233.01

Link: https://lkml.kernel.org/r/20241011171950.62684-1-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/zswap.c~mm-zswap-avoid-touching-xarray-for-unnecessary-invalidation
+++ a/mm/zswap.c
@@ -1641,6 +1641,9 @@ void zswap_invalidate(swp_entry_t swp)
 	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
 
+	if (xa_empty(tree))
+		return;
+
 	entry = xa_erase(tree, offset);
 	if (entry)
 		zswap_entry_free(entry);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-dont-pass-unnecessary-key-parameters.patch
mm-list_lru-dont-export-list_lru_add.patch
mm-list_lru-code-clean-up-for-reparenting.patch
mm-list_lru-simplify-reparenting-and-initial-allocation.patch
mm-list_lru-split-the-lock-to-per-cgroup-scope.patch
mm-list_lru-simplify-the-list_lru-walk-callback-function.patch
mm-zswap-avoid-touching-xarray-for-unnecessary-invalidation.patch

