Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470784A1D
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752360572; cv=none; b=ImZcnI8SebNdYpZZv1xDMtSY9hvn5SMyN62bEvQpUgsWQtl2KFJgtUWIh6iGrgJLCmkWkBmOsATMptowDsAGcl06mPn3EZisY3vP9GGDMoaG9HPHB9L3T1CghR7d8nzcjOGcBKAijrtlndpDqE0jHx/0fseLvuJ/jKoe3McUU8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752360572; c=relaxed/simple;
	bh=E+ZaICawhfh9XIDPEy4IXVAXuuAjMVXEKMxE6OcgoBA=;
	h=Date:To:From:Subject:Message-Id; b=AEefbE5HSBljS6luoZjGNvFdoAS5x+29fkxqssXVX++ClDvBYNuXY4GrQUb2uSAMDYkOtIn1FQw3VHH9ajRFOfff6uAFUDSKAD7UwVdKCJKy8C1ORQhUDIVpz9i+cB1DHLrP754O7lm2d2ptFYqf8J6E9S6VE/zTDKw+ksCHKGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IKQ2yVcx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IKQ2yVcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316A8C4CEEF;
	Sat, 12 Jul 2025 22:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752360571;
	bh=E+ZaICawhfh9XIDPEy4IXVAXuuAjMVXEKMxE6OcgoBA=;
	h=Date:To:From:Subject:From;
	b=IKQ2yVcxlt6Khb/naQb8rHv4mX5eJaPlz4UI/nYIDeq1MUhLkIWa0pbh4cAMJUyQt
	 DxJEnOtorppPjXUswmMbGyVwAxl33YCFXDKMw4ifZo6rSF0vRuMFo9KNdHmX4jqiKd
	 AVjytNUJ91wIi/IX11NoGnWEGXwCOEgt11Jt6WPc=
Date: Sat, 12 Jul 2025 15:49:30 -0700
To: mm-commits@vger.kernel.org,yukuai3@huawei.com,song@kernel.org,klarasmodin@gmail.com,herbert@gondor.apana.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-raid6-replace-custom-zero-page-with-zero_page-v3.patch added to mm-nonmm-unstable branch
Message-Id: <20250712224931.316A8C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/raid6: update recov_rvv.c zero page usage
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-raid6-replace-custom-zero-page-with-zero_page-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-raid6-replace-custom-zero-page-with-zero_page-v3.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: lib/raid6: update recov_rvv.c zero page usage
Date: Mon, 23 Jun 2025 16:47:25 +0800

Update lib/raid6/recov_rvv.c, for 1857fcc84744 ("lib/raid6: replace custom
zero page with ZERO_PAGE"), per Klara.

Link: https://lkml.kernel.org/r/aFkUnXWtxcgOTVkw@gondor.apana.org.au
Fixes: 1857fcc84744 ("lib/raid6: replace custom zero page with ZERO_PAGE")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid6/recov_rvv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/raid6/recov_rvv.c~lib-raid6-replace-custom-zero-page-with-zero_page-v3
+++ a/lib/raid6/recov_rvv.c
@@ -165,10 +165,10 @@ static void raid6_2data_recov_rvv(int di
 	 * delta p and delta q
 	 */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -203,7 +203,7 @@ static void raid6_datap_recov_rvv(int di
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

lib-raid6-replace-custom-zero-page-with-zero_page-v3.patch

