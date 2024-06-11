Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2933A8E4
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 21:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718142817; cv=none; b=tUNw92meIuERD4pIpY7er2SgEefO2ZbNDTJ568D11dsHuNL8EFSaxFokz1drLQifGEE/wI3DgqEbZSI+NegUr0LDyBLUk73mUwsbvan2bqX0ziacMW1WChULshz34JKaxqHNA7UxMwVuP1hH0QzC45uiTXimjN1t3QuucJA57rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718142817; c=relaxed/simple;
	bh=CZBKseW3OsN/L6ZXL//d/X73+KWDQDjQMw6cKbVgBEY=;
	h=Date:To:From:Subject:Message-Id; b=YlLkBhmwk/Iu30pMY3D+AGYmzFJq3D13UBAhH5YI+YCS6OZxH4XiY5APcpNB17sYT1l1vLshGOH1Wb6sCTHuzGqbBO8Q6XYOlcJIpWSPFUqjVA7pdIrDOvFNK+K0EtnWAXmBNh3NYgTYLbzR9L2QvGF4niimsbGhj5HBxAC8y8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G2WmEv+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G2WmEv+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA09C2BD10;
	Tue, 11 Jun 2024 21:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718142816;
	bh=CZBKseW3OsN/L6ZXL//d/X73+KWDQDjQMw6cKbVgBEY=;
	h=Date:To:From:Subject:From;
	b=G2WmEv+UhGtFHgEXyIyJqCFCamTwL16myj6b8rEltK0oxDO+d6qBx6sxZ4vHaBHeo
	 0Kj26AIFqMAZ4w6mYvnXOnu1LoteSAriLldmHKdtFaj9vtqBOox4AoPVtu/7n8dEU9
	 /SgjscR69c+AMliz4g5sLh51tkydtgYaiFHKMKRo=
Date: Tue, 11 Jun 2024 14:53:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3.patch added to mm-unstable branch
Message-Id: <20240611215336.5FA09C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3.patch

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
@@ -1783,6 +1783,10 @@ static inline void wb_dirty_exceeded(str
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
writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3.patch

