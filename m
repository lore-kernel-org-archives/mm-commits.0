Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004A122B8B0
	for <mm-commits@vger.kernel.org>; Mon, 23 Jun 2025 22:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717955; cv=none; b=Lv8ZOnoCki+W7w9AabgsRSQ6tqmQlc8pWXJm+dbp7kpUodMUIj/ml7G3XrjSSfS4NStEAaK4I9BCCXciR4wUQM3ETJ3APeVfRllYWcWBLbQuRrSlM8VNLmZ/CaiC75nuB6wbzuhVkRR5fGaK0f5YIy3nQ51aNBtLisnELqStSk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717955; c=relaxed/simple;
	bh=1zcbhjbDa0ZS7Ox7JrzJAETF9uvTeniSZ4kCYelmSCo=;
	h=Date:To:From:Subject:Message-Id; b=DF28QsQ1kBin/O6Vbx2OzE3dZQYy32zbGpOAbtWw902LuslSjpx62u9inbX7ia3iJnZeZw4QFrBzetBDoSQiacd0a/KPH3mE/wO4nbEpLhGFbZGW10mMKfpdsi4b2eQb+qIZcMmtX/raWsiG9pAFK6h7JNaBa62rgBN9UpzNxVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gOwvsGus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gOwvsGus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75786C4CEEA;
	Mon, 23 Jun 2025 22:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750717954;
	bh=1zcbhjbDa0ZS7Ox7JrzJAETF9uvTeniSZ4kCYelmSCo=;
	h=Date:To:From:Subject:From;
	b=gOwvsGus9p/ZBXROof1hhZpf97QQH4k8rU6rl/mIXcGnE6TRwPfrDlcKVFfmBB4Dw
	 5P28W9fl3fETp2BWQsr0oJztdQnMdCtPxFxN5AMBLsMfFmWee5/4r9/VdiTqHkHbeL
	 Dm0Gq1SnXefdX5+G+5Jg2IbVfcj5kL+vUwLkS84I=
Date: Mon, 23 Jun 2025 15:32:33 -0700
To: mm-commits@vger.kernel.org,yukuai3@huawei.com,song@kernel.org,klarasmodin@gmail.com,herbert@gondor.apana.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-raid6-replace-custom-zero-page-with-zero_page-v3.patch added to mm-nonmm-unstable branch
Message-Id: <20250623223234.75786C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-raid6-replace-custom-zero-page-with-zero_page-v3
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
lib-raid6-replace-custom-zero-page-with-zero_page-v3.patch

