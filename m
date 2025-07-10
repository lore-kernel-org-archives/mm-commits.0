Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC67A2857FF
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126942; cv=none; b=D5m3THYBFojcv76NwKFD79luofIZw5oYH2df53TWvt35bKCdeDJO504fJQBnvn4zmYifmRJER82gMpXg/8DHMLnMvWwXl7Sj1xaxJRWhOwLxzu74E7kCGux9TQ5dykRTpjNtxS4f0RAdVof6KygRvgH/gdAS3VSylhWjDVj7lS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126942; c=relaxed/simple;
	bh=rMEPX8WWlIG9o4enNF6c2a75aQaNccE47wdF8rSAqNs=;
	h=Date:To:From:Subject:Message-Id; b=KqS4yjgJ5FRZaRqxDY+eutRzZL7AjGyiLnFRulg3vP7xVMZ3RIOhZ8QAEFAOYnV4TI0GCDN0QkJTNLCBvLXEfemHiVRhKP2u5grgSsHt/hrr4EAgHqRcoGLc4qKSCS5TVFUgvbGUPrsGCNtoQboWlcQqAhhvqwxkcDKjlRk3CgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=090thj7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="090thj7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C57FC4CEE3;
	Thu, 10 Jul 2025 05:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126941;
	bh=rMEPX8WWlIG9o4enNF6c2a75aQaNccE47wdF8rSAqNs=;
	h=Date:To:From:Subject:From;
	b=090thj7f6mGsoEc/6PWMpzXDn+OxtJORWCqa8JA82bqdohIfex7d7W8DfhxqSIuot
	 eQcvMoF0p2siqWaxj/+OZVqJrFHpd6y+sMznGfexoDbfqNzlicp25tCwlRyAdUVFwF
	 2DTlPLWV1orLruqx31tI+vSy26kESZ9g4BzanI3Q=
Date: Wed, 09 Jul 2025 22:55:40 -0700
To: mm-commits@vger.kernel.org,yukuai3@huawei.com,song@kernel.org,klarasmodin@gmail.com,herbert@gondor.apana.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-raid6-replace-custom-zero-page-with-zero_page-v3.patch removed from -mm tree
Message-Id: <20250710055541.6C57FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-raid6-replace-custom-zero-page-with-zero_page-v3
has been removed from the -mm tree.  Its filename was
     lib-raid6-replace-custom-zero-page-with-zero_page-v3.patch

This patch was dropped because it was folded into lib-raid6-replace-custom-zero-page-with-zero_page.patch

------------------------------------------------------
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: lib-raid6-replace-custom-zero-page-with-zero_page-v3
Date: Mon, 23 Jun 2025 16:47:25 +0800

update lib/raid6/recov_rvv.c, per Klara

Link: https://lkml.kernel.org/r/aFkUnXWtxcgOTVkw@gondor.apana.org.au
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

lib-raid6-replace-custom-zero-page-with-zero_page.patch

