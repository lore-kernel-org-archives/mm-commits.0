Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F7717A30F
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977381; cv=none; b=rKAH0NkVbYnIt9QZI46InesE/4lfTulmwv48YpjK9t9ngEp6k6Cm4MSCpdQxDhoqT+JKREVy9cOgXoSP1Hb1WsMGtoh57bemFHehN09iQmkZNSoENZ6SzldsF/1URe618OmuTlasqZZ4px5Cmki6DB+9d/SEOU5QDikg9M/T1Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977381; c=relaxed/simple;
	bh=qEenCtpE0XUvhAVNuPbrm+o7QvO0T9ih6yBKk5SqmLY=;
	h=Date:To:From:Subject:Message-Id; b=E72EJzV8Y4X0vgkmnfXibODx3vZW9VGWFLLX9KKsbyy3cNPHe69fcrfF3oy4y9o3C4bqrq2QQ4OV+x+z7rHX3azG8eIJgW1i1vYT776jfPei1McUygU7VIm+8mm9vyPbDYWWgSukRb4Ixihsa+cxj4PlIA80UAPg2YgVXkeK0rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VSEXTsRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VSEXTsRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4AAC4CEE3;
	Sun, 20 Jul 2025 02:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977381;
	bh=qEenCtpE0XUvhAVNuPbrm+o7QvO0T9ih6yBKk5SqmLY=;
	h=Date:To:From:Subject:From;
	b=VSEXTsRLOeNY3YGNROsliBV+CCn8VWVBFeOesPfy3plZJ2BDtFssTS2kOmQHAfliZ
	 Tnfep9Qz4stT7dC43SrJ06ipNqw05IUfmjg8ydGnxUujrn/SC6k6f8L61REVSb+vz9
	 j3aq7yfc6sGu5qJCAlsRitWCpI/e5h41ZqSCizTY=
Date: Sat, 19 Jul 2025 19:09:41 -0700
To: mm-commits@vger.kernel.org,yukuai3@huawei.com,song@kernel.org,klarasmodin@gmail.com,herbert@gondor.apana.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-raid6-replace-custom-zero-page-with-zero_page-v3.patch removed from -mm tree
Message-Id: <20250720020941.9D4AAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/raid6: update recov_rvv.c zero page usage
has been removed from the -mm tree.  Its filename was
     lib-raid6-replace-custom-zero-page-with-zero_page-v3.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


