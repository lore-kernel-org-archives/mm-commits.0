Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561673C585C;
	Fri,  7 Aug 2026 02:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068083; cv=none; b=BuAd1rtyhp8hoRe9HrGyGT4NuceSI29Gj/AuFSwaV+YFj9jqJaDkBp48OWhjH865FZyYcfjmx9+IUg/F8Z0pK6Eeg/Z36DRUALm1a7VsKinMW3ouUCZS+k1uhCdFP6MhGusd74/yrfYmhjFzcSC2ftQaV1jIxWrPQVe9g6cK1u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068083; c=relaxed/simple;
	bh=DUjyitusKjrwHbwx7st2hxBxT80cQiI9N1yDn/UgBU4=;
	h=Date:To:From:Subject:Message-Id; b=fn36gODfVFGhSEs+Kgy52ST7Mgg7UthwLXusogRofjWNjqoSaXNLKz91jSqXmgvj1gHANYWVriAsBDN5Y4fAPQKECHMxXmaXfCBhEmjAGXQn/Mvqs2mtxbL5qcmyvorME6bYQbo0RE9WMioLU1EHTdCMbj0ebyxoz+24VMGSn0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l2KeO4Mq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l2KeO4Mq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADA71F000E9;
	Fri,  7 Aug 2026 02:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068080;
	bh=hMyuloR6ZunhlHXO2bkv/Td+9zGSOw4jky+84o5oGyk=;
	h=Date:To:From:Subject;
	b=l2KeO4MqpWwjAfkEwmSjqL8S99rWvDchmhCy0fs2ytbboJmv0+l9CxCq72qNcD1cO
	 sDCEU2B7ZbLvsMTLJvHFUrro3S8lTGizdYYFXtYP7SwJptSA009umnibE/wtYD/9H3
	 E2C5tEpfhTykxe3qDulr8x1LjAith/cBhHr8QObU=
Date: Thu, 06 Aug 2026 19:01:19 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-read-ops_id-only-once-in-damon_sysfs_apply_inputs.patch removed from -mm tree
Message-Id: <20260807020120.2ADA71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: read ops_id only once in damon_sysfs_apply_inputs()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-read-ops_id-only-once-in-damon_sysfs_apply_inputs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs: read ops_id only once in damon_sysfs_apply_inputs()
Date: Tue, 14 Jul 2026 20:10:01 -0700

damon_sysfs_apply_inputs() reads ops_id twice.  It could race with
ops_id_store().  As a result, the min_region_sz could wrongly be set up. 
Read it once.

The user impact is trivial.  Sane users ain't update the parameter in
parallel.  Even if it happens, the DAMON core layer handles the wrong
min_region_sz (!is_power_of_2()).  Even if somehow the race ended up
making a min_region_sz that is different from the user's intention but
still valid, only monitoring itself runs differently than expected.  No
critical consequences like kernel panic or memory corruption happen

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-7-sj@kernel.org
Link: https://lore.kernel.org/20260703172417.95426-1-sj@kernel.org [1]
Fixes: 8d009da32f13 ("mm/damon/sysfs: set damon_ctx->min_sz_region only for paddr use case")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-read-ops_id-only-once-in-damon_sysfs_apply_inputs
+++ a/mm/damon/sysfs.c
@@ -2094,14 +2094,16 @@ static inline bool damon_sysfs_kdamond_r
 static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 		struct damon_sysfs_context *sys_ctx)
 {
+	enum damon_ops_id ops_id;
 	int err;
 
-	err = damon_select_ops(ctx, sys_ctx->ops_id);
+	ops_id = READ_ONCE(sys_ctx->ops_id);
+	err = damon_select_ops(ctx, ops_id);
 	if (err)
 		return err;
 	ctx->addr_unit = READ_ONCE(sys_ctx->addr_unit);
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
-	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
+	if (ops_id == DAMON_OPS_PADDR)
 		ctx->min_region_sz = max(
 				DAMON_MIN_REGION_SZ / ctx->addr_unit, 1);
 	ctx->pause = sys_ctx->pause;
_

Patches currently in -mm which might be from sj@kernel.org are


