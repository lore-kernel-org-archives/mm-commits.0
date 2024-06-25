Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CC81849
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719288985; cv=none; b=a+cVlTMO2OxPMpzWNduchV4SF9rvHfaAGiFgPwDdQhipBCKB6fn1wRfnCUaMZ3lnmujovjqHl2MZby1f9Q+A7jqTtefziMvXU//5BexQSpXMCLEAqTycrOaL7EFGe9jUsFTMzkjIxzDGIHZlqmqEqHvtmSlGtIkuKpGQofuGkUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719288985; c=relaxed/simple;
	bh=gFtYJoAy5Y0C8MVhY54qk2LAPHprCfhtge53LlrkXOs=;
	h=Date:To:From:Subject:Message-Id; b=ckILs/p4F4UeC3hs56SQPl+qCU/67gGTmx7yHOmdQL/+fSkFP0QVZfoBKP4ubjjwg+ngnx9qCXyjNFy2VYpZEjs/wRo1b4x+gB+jlRVTktlMQbf56ngBwML9qAA7FrKb7I8e80VuhjBnL7IF7DwoRE/CrbF9f5B4If/zzfAVruk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pzIhBU1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pzIhBU1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96729C32782;
	Tue, 25 Jun 2024 04:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719288984;
	bh=gFtYJoAy5Y0C8MVhY54qk2LAPHprCfhtge53LlrkXOs=;
	h=Date:To:From:Subject:From;
	b=pzIhBU1Pfsb8UimTnONJzmLcZtNo/38MqlG5INtrW48dz5jPM7dmlyeT8RVwOPyUV
	 3c4kGfUK8mb32jIsWLK1SnCryu8OSenUKySsxfYLVa1aKfjmQi6wF8W3uj6fe/qlzm
	 MWtv3+FnzzR3Jeb8qI1wPf5jZyR5mgcseLcLkf+8=
Date: Mon, 24 Jun 2024 21:16:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3.patch removed from -mm tree
Message-Id: <20240625041624.96729C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3
has been removed from the -mm tree.  Its filename was
     writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3.patch

This patch was dropped because it was folded into writeback-factor-out-balance_wb_limits-to-remove-repeated-code.patch

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3
Date: Thu, 6 Jun 2024 11:35:47 +0800

add comment

Link: https://lkml.kernel.org/r/20240606033547.344376-1-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page-writeback.c~writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3
+++ a/mm/page-writeback.c
@@ -1805,6 +1805,10 @@ static inline void wb_dirty_exceeded(str
 		((dtc->dirty > dtc->thresh) || strictlimit);
 }
 
+/*
+ * The limits fileds dirty_exceeded and pos_ratio won't be updated if wb is
+ * in freerun state. Please don't use these invalid fileds in freerun case.
+ */
 static void balance_wb_limits(struct dirty_throttle_control *dtc,
 			      bool strictlimit)
 {
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

writeback-factor-out-wb_bg_dirty_limits-to-remove-repeated-code.patch
writeback-add-general-function-domain_dirty_avail-to-calculate-dirty-and-avail-of-domain.patch
writeback-factor-out-domain_over_bg_thresh-to-remove-repeated-code.patch
writeback-factor-out-code-of-freerun-to-remove-repeated-code.patch
writeback-factor-out-wb_dirty_freerun-to-remove-more-repeated-freerun-code.patch
writeback-factor-out-balance_domain_limits-to-remove-repeated-code.patch
writeback-factor-out-wb_dirty_exceeded-to-remove-repeated-code.patch
writeback-factor-out-balance_wb_limits-to-remove-repeated-code.patch

