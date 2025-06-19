Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5D020E711
	for <mm-commits@vger.kernel.org>; Thu, 19 Jun 2025 23:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750374946; cv=none; b=DjyM2BDh2ivm+9y0goyhztCWx/eBL31tbtZ1OJVfAMlKDzYbczhFtU69WCiy5SrFS/TBods/+CvvoMS3OGfH8lUv+mEAbCNuOHbYHPaypPXBJ3CWHZENF30/mGsbElZJgjGoPUgs5mJPeaNB3TYeWHR8f1C5i9bV2V7UZK0pJEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750374946; c=relaxed/simple;
	bh=YRQ3O4vCd+k1BMkH8Q08kl7e1XOa4F/GRC9YSHg0G9c=;
	h=Date:To:From:Subject:Message-Id; b=B8ThkcXYPulIdNgFMW6WyltxMm4jCjAVU3rItqLp+pn1ll01HnsnxLIsGyYNjamttf6D8cYgcF3Iy+fhUWrRZ4v6dVxOs81rKcdtJs4za0kNzOOJZbc0mJTicGFAT12bQ0ueuCpFKYUEOJNo4FoCzvZTVkjhfeaXqYqsVkeL1/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zXsICBaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zXsICBaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E67C4CEEA;
	Thu, 19 Jun 2025 23:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750374944;
	bh=YRQ3O4vCd+k1BMkH8Q08kl7e1XOa4F/GRC9YSHg0G9c=;
	h=Date:To:From:Subject:From;
	b=zXsICBaCmD84hC73oakGiivZOhMpCTSwxoYETNabRddy7DJpyaFjl3t20k2wYjl53
	 yChSPpWAHJQeZfpclQFg5vON4DyyhOH/XaN7eH3VnNeYDV4jJeTa3iGLkgt9exfCRi
	 MqCOOZhoUw4RyI3dllNk2lXs4sjdulVPGTXoiPt0=
Date: Thu, 19 Jun 2025 16:15:43 -0700
To: mm-commits@vger.kernel.org,yukuai3@huawei.com,song@kernel.org,herbert@gondor.apana.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-raid6-replace-custom-zero-page-with-zero_page.patch added to mm-nonmm-unstable branch
Message-Id: <20250619231544.83E67C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/raid6: replace custom zero page with ZERO_PAGE
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-raid6-replace-custom-zero-page-with-zero_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-raid6-replace-custom-zero-page-with-zero_page.patch

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
Subject: lib/raid6: replace custom zero page with ZERO_PAGE
Date: Mon, 17 Mar 2025 17:02:28 +0800

Use the system-wide zero page instead of a custom zero page.

Link: https://lkml.kernel.org/r/Z9flJNkWQICx0PXk@gondor.apana.org.au
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/async_tx/async_pq.c          |    2 +-
 crypto/async_tx/async_raid6_recov.c |    4 ++--
 include/linux/raid/pq.h             |   12 +++++++++++-
 lib/raid6/algos.c                   |    3 ---
 lib/raid6/recov.c                   |    6 +++---
 lib/raid6/recov_avx2.c              |    6 +++---
 lib/raid6/recov_avx512.c            |    6 +++---
 lib/raid6/recov_loongarch_simd.c    |   12 ++++++------
 lib/raid6/recov_neon.c              |    6 +++---
 lib/raid6/recov_s390xc.c            |    6 +++---
 lib/raid6/recov_ssse3.c             |    6 +++---
 11 files changed, 38 insertions(+), 31 deletions(-)

--- a/crypto/async_tx/async_pq.c~lib-raid6-replace-custom-zero-page-with-zero_page
+++ a/crypto/async_tx/async_pq.c
@@ -119,7 +119,7 @@ do_sync_gen_syndrome(struct page **block
 	for (i = 0; i < disks; i++) {
 		if (blocks[i] == NULL) {
 			BUG_ON(i > disks - 3); /* P or Q can't be zero */
-			srcs[i] = (void*)raid6_empty_zero_page;
+			srcs[i] = raid6_get_zero_page();
 		} else {
 			srcs[i] = page_address(blocks[i]) + offsets[i];
 
--- a/crypto/async_tx/async_raid6_recov.c~lib-raid6-replace-custom-zero-page-with-zero_page
+++ a/crypto/async_tx/async_raid6_recov.c
@@ -414,7 +414,7 @@ async_raid6_2data_recov(int disks, size_
 		async_tx_quiesce(&submit->depend_tx);
 		for (i = 0; i < disks; i++)
 			if (blocks[i] == NULL)
-				ptrs[i] = (void *) raid6_empty_zero_page;
+				ptrs[i] = raid6_get_zero_page();
 			else
 				ptrs[i] = page_address(blocks[i]) + offs[i];
 
@@ -497,7 +497,7 @@ async_raid6_datap_recov(int disks, size_
 		async_tx_quiesce(&submit->depend_tx);
 		for (i = 0; i < disks; i++)
 			if (blocks[i] == NULL)
-				ptrs[i] = (void*)raid6_empty_zero_page;
+				ptrs[i] = raid6_get_zero_page();
 			else
 				ptrs[i] = page_address(blocks[i]) + offs[i];
 
--- a/include/linux/raid/pq.h~lib-raid6-replace-custom-zero-page-with-zero_page
+++ a/include/linux/raid/pq.h
@@ -11,8 +11,13 @@
 #ifdef __KERNEL__
 
 #include <linux/blkdev.h>
+#include <linux/mm.h>
 
-extern const char raid6_empty_zero_page[PAGE_SIZE];
+/* This should be const but the raid6 code is too convoluted for that. */
+static inline void *raid6_get_zero_page(void)
+{
+	return page_address(ZERO_PAGE(0));
+}
 
 #else /* ! __KERNEL__ */
 /* Used for testing in user space */
@@ -191,6 +196,11 @@ static inline uint32_t raid6_jiffies(voi
 	return tv.tv_sec*1000 + tv.tv_usec/1000;
 }
 
+static inline void *raid6_get_zero_page(void)
+{
+	return raid6_empty_zero_page;
+}
+
 #endif /* ! __KERNEL__ */
 
 #endif /* LINUX_RAID_RAID6_H */
--- a/lib/raid6/algos.c~lib-raid6-replace-custom-zero-page-with-zero_page
+++ a/lib/raid6/algos.c
@@ -18,9 +18,6 @@
 #else
 #include <linux/module.h>
 #include <linux/gfp.h>
-/* In .bss so it's zeroed */
-const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(256)));
-EXPORT_SYMBOL(raid6_empty_zero_page);
 #endif
 
 struct raid6_calls raid6_call;
--- a/lib/raid6/recov_avx2.c~lib-raid6-replace-custom-zero-page-with-zero_page
+++ a/lib/raid6/recov_avx2.c
@@ -28,10 +28,10 @@ static void raid6_2data_recov_avx2(int d
 	   Use the dead data pages as temporary storage for
 	   delta p and delta q */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -196,7 +196,7 @@ static void raid6_datap_recov_avx2(int d
 	/* Compute syndrome with zero for the missing data page
 	   Use the dead data page as temporary storage for delta q */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
--- a/lib/raid6/recov_avx512.c~lib-raid6-replace-custom-zero-page-with-zero_page
+++ a/lib/raid6/recov_avx512.c
@@ -37,10 +37,10 @@ static void raid6_2data_recov_avx512(int
 	 */
 
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -238,7 +238,7 @@ static void raid6_datap_recov_avx512(int
 	 */
 
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
--- a/lib/raid6/recov.c~lib-raid6-replace-custom-zero-page-with-zero_page
+++ a/lib/raid6/recov.c
@@ -31,10 +31,10 @@ static void raid6_2data_recov_intx1(int
 	   Use the dead data pages as temporary storage for
 	   delta p and delta q */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -72,7 +72,7 @@ static void raid6_datap_recov_intx1(int
 	/* Compute syndrome with zero for the missing data page
 	   Use the dead data page as temporary storage for delta q */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
--- a/lib/raid6/recov_loongarch_simd.c~lib-raid6-replace-custom-zero-page-with-zero_page
+++ a/lib/raid6/recov_loongarch_simd.c
@@ -42,10 +42,10 @@ static void raid6_2data_recov_lsx(int di
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
@@ -197,7 +197,7 @@ static void raid6_datap_recov_lsx(int di
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -316,10 +316,10 @@ static void raid6_2data_recov_lasx(int d
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
@@ -436,7 +436,7 @@ static void raid6_datap_recov_lasx(int d
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
--- a/lib/raid6/recov_neon.c~lib-raid6-replace-custom-zero-page-with-zero_page
+++ a/lib/raid6/recov_neon.c
@@ -36,10 +36,10 @@ static void raid6_2data_recov_neon(int d
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
@@ -74,7 +74,7 @@ static void raid6_datap_recov_neon(int d
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
--- a/lib/raid6/recov_s390xc.c~lib-raid6-replace-custom-zero-page-with-zero_page
+++ a/lib/raid6/recov_s390xc.c
@@ -35,10 +35,10 @@ static void raid6_2data_recov_s390xc(int
 	   Use the dead data pages as temporary storage for
 	   delta p and delta q */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -82,7 +82,7 @@ static void raid6_datap_recov_s390xc(int
 	/* Compute syndrome with zero for the missing data page
 	   Use the dead data page as temporary storage for delta q */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
--- a/lib/raid6/recov_ssse3.c~lib-raid6-replace-custom-zero-page-with-zero_page
+++ a/lib/raid6/recov_ssse3.c
@@ -30,10 +30,10 @@ static void raid6_2data_recov_ssse3(int
 	   Use the dead data pages as temporary storage for
 	   delta p and delta q */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -203,7 +203,7 @@ static void raid6_datap_recov_ssse3(int
 	/* Compute syndrome with zero for the missing data page
 	   Use the dead data page as temporary storage for delta q */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

lib-raid6-replace-custom-zero-page-with-zero_page.patch

