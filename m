Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EDA3C4B6F;
	Fri,  7 Aug 2026 02:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068082; cv=none; b=l/h31qmy1xCKt6yCIAaFTMltHaaS/pUzF2WAQrw00TB6fAjUDawlsRrrBjTfgue6Gl2PSjs79IimxV511oyLkAGA7N3KxxQ9qD4D3D62RbQqoVvPxEu44JKPiYkjF6OqIB2YpDZ3FsmbT3oVM5hHUhdhV8+cx1c1snPHscJiANo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068082; c=relaxed/simple;
	bh=Nk3Qr7IjanjqzcNZipwGNN5hpo2VWqNZJoQNmD32sQ4=;
	h=Date:To:From:Subject:Message-Id; b=tytYBaqkd+MclRl9cbj4psPR4bf/Y4/Tvab0GoO2M6mCWl/9LXoOUOZgzM1Xtz+lnJXEDtf0b3Rs8pgpfpcDUpsAxpnIrSn+hGpcgHjgs9Jsn3BP7pQKkBMgDmbXpce7F/fi9fSKbeiXwuC183uUmOnMBHIX/Y+i7Rn5jWftG0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tLVJw/ib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tLVJw/ib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080C31F00A3D;
	Fri,  7 Aug 2026 02:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068079;
	bh=uMauMZYl7Y/0RV83rZoq03DbON0gYqcDLrEFPhFtK0Q=;
	h=Date:To:From:Subject;
	b=tLVJw/ibQ5hzYfSNyGBNyujQxhYP3tKU75yAj2BzoI2FSYshrs53I8geuQfAQQ4Y+
	 5aCxGJMferzArMrs9IIZ7N6j3n3z6Fyb3ZdfcznKOMNFuijBY+dkkNk+8OIrY7CnJE
	 K/ucx7iK79g/GmD+AZPnOncHSyT575TlNM/OKdoY=
Date: Thu, 06 Aug 2026 19:01:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-read-addr_unit-only-once-in-damon_sysfs_apply_inputs.patch removed from -mm tree
Message-Id: <20260807020119.080C31F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: read addr_unit only once in damon_sysfs_apply_inputs()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-read-addr_unit-only-once-in-damon_sysfs_apply_inputs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs: read addr_unit only once in damon_sysfs_apply_inputs()
Date: Tue, 14 Jul 2026 20:10:00 -0700

damon_sysfs_apply_inputs() reads addr_unit twice.  It could race with
addr_unit_store().  As a result, the min_region_sz could wrongly be set
up.  Read it once.

The user impact is trivial.  Sane users ain't update the parameter in
parallel.  Even if it happens, the DAMON core layer handles the wrong
min_region_sz (!is_power_of_2()).  Even if somehow the race ended up
making a min_region_sz that is different from the user's intention but
still valid, only monitoring itself runs differently than expected.  No
critical consequences like kernel panic or memory corruption happen.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-6-sj@kernel.org
Link: https://lore.kernel.org/20260714142950.100711-1-sj@kernel.org [1]
Fixes: 540a2aebc657 ("mm/damon/sysfs: implement addr_unit file under context dir")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-read-addr_unit-only-once-in-damon_sysfs_apply_inputs
+++ a/mm/damon/sysfs.c
@@ -2099,11 +2099,11 @@ static int damon_sysfs_apply_inputs(stru
 	err = damon_select_ops(ctx, sys_ctx->ops_id);
 	if (err)
 		return err;
-	ctx->addr_unit = sys_ctx->addr_unit;
+	ctx->addr_unit = READ_ONCE(sys_ctx->addr_unit);
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
 	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
 		ctx->min_region_sz = max(
-				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
+				DAMON_MIN_REGION_SZ / ctx->addr_unit, 1);
 	ctx->pause = sys_ctx->pause;
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
_

Patches currently in -mm which might be from sj@kernel.org are


