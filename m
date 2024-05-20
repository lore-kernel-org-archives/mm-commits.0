Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6D72581
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716164616; cv=none; b=dKZSYsJMf4vLWBiaGxYOmhblntrv/DHMvFyIXapSBQFBC7Wy3oHSKf1qCWVfbzhK1KtUZeAaTcSTlWFXrvGy0IpTc1oavcGRfrRWX3S9G3eXoEAUyqIfKpiWjvm2l4nOnAhLjrzGH4AmBuhiOh+3we29urbj54eA+jeEZ1vZaHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716164616; c=relaxed/simple;
	bh=QjFdMQGQNaWvA94+62mz4RQ/ba4LHTVBli/X0XzB1Ic=;
	h=Date:To:From:Subject:Message-Id; b=gB0yQY08gisnQskP8KYGvzA9wOwOKq+HEre5n79BMLFPZkZ1CRpR5UlWWrbYNbD3HMfuDj6smkEnxCs6tjtVkxTfERzbPHBvcp2cxJPtGEqSMKGwmGCn3fbSq30a8+icPmgtZ9Kc1H/PHOfY6+FYkybvSnCtAM0D0oR+aWHSFWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iCaW2mTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iCaW2mTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7B2C32781;
	Mon, 20 May 2024 00:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716164616;
	bh=QjFdMQGQNaWvA94+62mz4RQ/ba4LHTVBli/X0XzB1Ic=;
	h=Date:To:From:Subject:From;
	b=iCaW2mTP0c4GY//GqnCO0uxBScaM4ZtpCFIGvKndu+a3kqmoFb2842a7zzl5np8P9
	 LxKzFzO5s2i+Mv/bjGa0topQ5JWnRnQnNtPT0uGwtab5k0+cdHCPTQauVRsEVeqY8X
	 /QpwkNJnzWWm4Drjn6O/AyTN9oZqBKk0GilUO1lQ=
Date: Sun, 19 May 2024 17:23:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-factor-out-balance_domain_limits-to-remove-repeated-code.patch added to mm-unstable branch
Message-Id: <20240520002336.2C7B2C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: factor out balance_domain_limits to remove repeated code
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-factor-out-balance_domain_limits-to-remove-repeated-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-factor-out-balance_domain_limits-to-remove-repeated-code.patch

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
Subject: writeback: factor out balance_domain_limits to remove repeated code
Date: Tue, 14 May 2024 20:52:52 +0800

Factor out balance_domain_limits to remove repeated code.

Link: https://lkml.kernel.org/r/20240514125254.142203-7-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/page-writeback.c~writeback-factor-out-balance_domain_limits-to-remove-repeated-code
+++ a/mm/page-writeback.c
@@ -1746,6 +1746,14 @@ static void domain_dirty_freerun(struct
 	dtc->freerun = dirty <= dirty_freerun_ceiling(thresh, bg_thresh);
 }
 
+static void balance_domain_limits(struct dirty_throttle_control *dtc,
+				  bool strictlimit)
+{
+	domain_dirty_avail(dtc, true);
+	domain_dirty_limits(dtc);
+	domain_dirty_freerun(dtc, strictlimit);
+}
+
 static void wb_dirty_freerun(struct dirty_throttle_control *dtc,
 			     bool strictlimit)
 {
@@ -1802,18 +1810,13 @@ static int balance_dirty_pages(struct bd
 
 		nr_dirty = global_node_page_state(NR_FILE_DIRTY);
 
-		domain_dirty_avail(gdtc, true);
-		domain_dirty_limits(gdtc);
-		domain_dirty_freerun(gdtc, strictlimit);
-
+		balance_domain_limits(gdtc, strictlimit);
 		if (mdtc) {
 			/*
 			 * If @wb belongs to !root memcg, repeat the same
 			 * basic calculations for the memcg domain.
 			 */
-			domain_dirty_avail(mdtc, true);
-			domain_dirty_limits(mdtc);
-			domain_dirty_freerun(mdtc, strictlimit);
+			balance_domain_limits(mdtc, strictlimit);
 		}
 
 		/*
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

