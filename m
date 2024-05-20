Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E519B367
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716164620; cv=none; b=pequ2kV/q9ds4LeEyJBK5lna7XnJRF3LCtY7F6e6daA/IfMUjUFAubIpyzgw0iz1jcq6PFOOTLFHTKUnHIq64mRZ1vLKBDYbKT4BxufED2oxh1ljfBUEoXFGdGurNzneLxomn22rZvFqKzvPRCvhUqo7pwyu6ohK7STNHnZfrPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716164620; c=relaxed/simple;
	bh=thjGQOcJ7yj0xttCMD+CBy60f3RK3KYFQodj9sIXnKg=;
	h=Date:To:From:Subject:Message-Id; b=gtVpbrijYupiGZI5ybM+8pdaXl5hSnqSPF42vmce26wGnq/6tyt2CQDm24kiwKrsHDfF3QMHv8Dt6IQ3TBjfaiioXgVsTlB3fHHeifqXUDYEAUsgxVY+3OtNdaFppQrYAI4j/FICBqXlMQF8eANOy81B3+nHFMWQDWge4bRKbtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bf6IVRZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bf6IVRZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA0CC32781;
	Mon, 20 May 2024 00:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716164619;
	bh=thjGQOcJ7yj0xttCMD+CBy60f3RK3KYFQodj9sIXnKg=;
	h=Date:To:From:Subject:From;
	b=Bf6IVRZcY1+7JZ7FvUoQBjGJ38638YpAlU+YcfTr87g5wjouMj5WAMMiliiCDqbfH
	 1+EphRV0DP9WWFZqbcjxrNeRjn7xNRwkrrHFj0nXzl1/FTL6tUlppxuzwhaTd2NVRQ
	 1zlFBac/J7YYDFLiqgcA0tDPB3QIIjRJ5xeJvuzM=
Date: Sun, 19 May 2024 17:23:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-factor-out-balance_wb_limits-to-remove-repeated-code.patch added to mm-unstable branch
Message-Id: <20240520002339.AFA0CC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: factor out balance_wb_limits to remove repeated code
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-factor-out-balance_wb_limits-to-remove-repeated-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-factor-out-balance_wb_limits-to-remove-repeated-code.patch

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
Subject: writeback: factor out balance_wb_limits to remove repeated code
Date: Tue, 14 May 2024 20:52:54 +0800

Factor out balance_wb_limits to remove repeated code

Link: https://lkml.kernel.org/r/20240514125254.142203-9-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/page-writeback.c~writeback-factor-out-balance_wb_limits-to-remove-repeated-code
+++ a/mm/page-writeback.c
@@ -1783,6 +1783,17 @@ static inline void wb_dirty_exceeded(str
 		((dtc->dirty > dtc->thresh) || strictlimit);
 }
 
+static void balance_wb_limits(struct dirty_throttle_control *dtc,
+			      bool strictlimit)
+{
+	wb_dirty_freerun(dtc, strictlimit);
+	if (dtc->freerun)
+		return;
+
+	wb_dirty_exceeded(dtc, strictlimit);
+	wb_position_ratio(dtc);
+}
+
 /*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
@@ -1869,12 +1880,9 @@ free_running:
 		 * Calculate global domain's pos_ratio and select the
 		 * global dtc by default.
 		 */
-		wb_dirty_freerun(gdtc, strictlimit);
+		balance_wb_limits(gdtc, strictlimit);
 		if (gdtc->freerun)
 			goto free_running;
-
-		wb_dirty_exceeded(gdtc, strictlimit);
-		wb_position_ratio(gdtc);
 		sdtc = gdtc;
 
 		if (mdtc) {
@@ -1884,12 +1892,9 @@ free_running:
 			 * both global and memcg domains.  Choose the one
 			 * w/ lower pos_ratio.
 			 */
-			wb_dirty_freerun(mdtc, strictlimit);
+			balance_wb_limits(mdtc, strictlimit);
 			if (mdtc->freerun)
 				goto free_running;
-
-			wb_dirty_exceeded(mdtc, strictlimit);
-			wb_position_ratio(mdtc);
 			if (mdtc->pos_ratio < gdtc->pos_ratio)
 				sdtc = mdtc;
 		}
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

