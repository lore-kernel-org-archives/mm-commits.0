Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672143;
	b=vsZXsucLcw75wlxvf9tqOtE4oXoCYPY+9iUE6WnZyFlE5Ntl7ApqZcDmkuFsMBtpdsD4
	 8W4G8u0wn1VFeBLdkneuhQ89fnPdwwt2h6XPssRdOSTeTVooOTz9m3w3sGPbB+Z1OQz3Y
	 U1HlkdKtEEr2EEJ7/QQ10xomgLCYZmp2D1cv26tezrKNN2gnuENSpAbmpcgC0WHF8/lLT
	 y12YsOOorTd5WoYTYudALQnD2K2VKeyGinCRslIobMdLxn+fRma9pLzY07sHlZTqY8+NQ
	 KtMAN3E7kU8ZvF+ihWYO6SaILgH8IiHHQvb3L8Qm7+pasqLTJPVXwuAhPsh4VJze+dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672143;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=IpI1BzqKiQgOZ7afEg8tuyBpcmYbesxz81yxw2DLlyk=;
	b=QxzgNg3AFl9EuwaqcgefNMUPpOTuN8nbKiExLwrH/LTaCttJ49aGuhVE2w0BJ5ROW1U1
	 um5A7qV2+T7LnzWmWzphnLGJg83ZmfXDqlVu4GU8k12hw18h3JPXhkbkKEK9LvRx8o5Bc
	 x65UV1/3HRuYkTTBHDaNQQVUD/efC29HDvQpr+hxrDSE2fEsQTeDCRNSBS0ZSDf9p9Oyt
	 BtS2TNPtUgSqBZacAubWNOEFA4PkgsZzD+Tmr5UAOHFPf4lVGH2woZnbhjXkd2Ca38bJV
	 8CTB7ueJXQ3siulgEBpdObLsTtSe1gfV+VXatiqOag0vySqILCnSglVtavjj3IccGTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UsYQzj2f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3B0606A329;
	Tue,  3 Nov 2026 02:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UsYQzj2f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B8E1F000C1;
	Tue,  3 Nov 2026 02:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672143;
	bh=IpI1BzqKiQgOZ7afEg8tuyBpcmYbesxz81yxw2DLlyk=;
	h=Date:To:From:Subject;
	b=UsYQzj2fipvP8ZPMO/NCJP0AlssHwz4DvyKkWTnJf/QAS90Bpil/WglFYtNfkw34D
	 UB0FHxXYrj8l6p9JDiNm6zt+ufG6P0WxLh/2zglSp2gPe3lREIGKGhyddqle0BYCOF
	 ynfmfCqRsgxQxjnN20mbE8K0wzGjEwULGbbm0a6E=
Date: Mon, 02 Nov 2026 18:15:42 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jiayuan.chen@shopee.com,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-move-static-variable-rotation-to-damon_ctx.patch removed from -mm tree
Message-Id: <20261103021542.E6B8E1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/core: move static variable rotation to damon_ctx
has been removed from the -mm tree.  Its filename was
     mm-damon-core-move-static-variable-rotation-to-damon_ctx.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: move static variable rotation to damon_ctx
Date: Sun, 25 Oct 2026 09:48:06 -0700

damon_split_some_reigons() uses a static variable, rotation, to remember
how many times it was called.  It is again used to determine fair
selection of regions to split.  Since it is a static variable, it can be
indeterministic and therefore less fair.

The user impact is not critical.  No crash, no leak.  DAMON's
best-effort and indeterministic monitoring accuracy could be slightly
more indeterministic when multiple kdamonds are used in parallel.

Fix the problem by moving the static variable into the damon_ctx struct.

Link: https://lore.kernel.org/20261025164808.152048-4-sj@kernel.org
Fixes: 1a582e6e0174 ("mm/damon/core: split a fraction of regions when nr_regions exceeds max/2")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-eebfcdde-2881-48ef-8df1-e2019d2a47f2
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>
Cc: <stable@vger.kernel.org> # 7.3.x
---

 include/linux/damon.h |    5 +++++
 mm/damon/core.c       |    5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-move-static-variable-rotation-to-damon_ctx
+++ a/include/linux/damon.h
@@ -963,6 +963,11 @@ struct damon_ctx {
 	 * for more details.
 	 */
 	unsigned long last_nr_regions;
+	/*
+	 * number of damon_split_some_regions() invocations for this context.
+	 * Read damon_split_some_regions() for more details.
+	 */
+	unsigned long region_split_rotation;
 };
 
 /* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
--- a/mm/damon/core.c~mm-damon-core-move-static-variable-rotation-to-damon_ctx
+++ a/mm/damon/core.c
@@ -3753,12 +3753,13 @@ static void damon_split_regions_of(struc
 static void damon_split_some_regions(struct damon_ctx *ctx,
 				     unsigned long split_step)
 {
-	static unsigned long rotation;
 	struct damon_target *t;
 	struct damon_region *r, *next;
-	unsigned long offset = rotation++ % split_step;
+	unsigned long offset;
 	unsigned long idx = 0;
 
+	offset = ctx->region_split_rotation++ % split_step;
+
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region_safe(r, next, t) {
 			unsigned long sz_region, sz_sub;
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch
mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch

