Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B48184C
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 00:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wCDXvl4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABF7C433C8;
	Thu, 21 Dec 2023 00:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703120397;
	bh=0fB0NHX5TNty62DEJz2ZbpJnoY1AXc5tIw2FJkGs1LM=;
	h=Date:To:From:Subject:From;
	b=wCDXvl4bPlskjuool5+lUxLEaJjMihjioDmAtk/C7jl7RZOnEyQCrnpLImPDRsSm3
	 mHz3OqGJIfQfpzjWu4843NtLyOX8remBUtcvuHOcBm5EJqvaOZC4Q5iUsHV8rRpkS9
	 uHSfQJNDzNghXD5I9S2Fv4Ast9SFn1o2ezVn+7l8=
Date: Wed, 20 Dec 2023 16:59:56 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-memcontrol-implement-zswap-writeback-disabling-fix.patch added to mm-unstable branch
Message-Id: <20231221005957.8ABF7C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zswap: memcontrol: implement zswap writeback disabling (fix)
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-memcontrol-implement-zswap-writeback-disabling-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-memcontrol-implement-zswap-writeback-disabling-fix.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: memcontrol: implement zswap writeback disabling (fix)
Date: Wed, 20 Dec 2023 16:57:25 -0800

Add a caveat about recurring zswap store failures leading to reclaim
inefficiency.

Link: https://lkml.kernel.org/r/20231221005725.3446672-1-nphamcs@gmail.com
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    5 ++++-
 Documentation/admin-guide/mm/zswap.rst  |    4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~zswap-memcontrol-implement-zswap-writeback-disabling-fix
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1686,7 +1686,10 @@ PAGE_SIZE multiple when read back.
 
 	When this is set to 0, all swapping attempts to swapping devices
 	are disabled. This included both zswap writebacks, and swapping due
-	to zswap store failure.
+	to zswap store failures. If the zswap store failures are recurring
+	(for e.g if the pages are incompressible), users can observe
+	reclaim inefficiency after disabling writeback (because the same
+	pages might be rejected again and again).
 
 	Note that this is subtly different from setting memory.swap.max to
 	0, as it still allows for pages to be written to the zswap pool.
--- a/Documentation/admin-guide/mm/zswap.rst~zswap-memcontrol-implement-zswap-writeback-disabling-fix
+++ a/Documentation/admin-guide/mm/zswap.rst
@@ -159,6 +159,10 @@ zswap itself) on a cgroup-basis as follo
 
 	echo 0 > /sys/fs/cgroup/<cgroup-name>/memory.zswap.writeback
 
+Note that if the store failures are recurring (for e.g if the pages are
+incompressible), users can observe reclaim inefficiency after disabling
+writeback (because the same pages might be rejected again and again).
+
 When there is a sizable amount of cold memory residing in the zswap pool, it
 can be advantageous to proactively write these cold pages to swap and reclaim
 the memory for other use cases. By default, the zswap shrinker is disabled.
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zswap-memcontrol-implement-zswap-writeback-disabling.patch
zswap-memcontrol-implement-zswap-writeback-disabling-fix.patch

