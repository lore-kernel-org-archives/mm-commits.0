Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3306728F3
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716164611; cv=none; b=d8w0ayIZw8TNy6Y7hDMGzLC2ErTSNrAxLZtv7gsBIvzFiC4dsz+eqFNIn17W+n3HkguJg/uBapQub7rdLMQwtLti/TFuTYsmwGCAc6wzEqB/fc+tzbqMY+kE/b07xqF4mWLIQvPsp2PpmCm8sz/1JpMghp7q7YcgzpOd9203UMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716164611; c=relaxed/simple;
	bh=07ZqnyO+58MyOTvDuDv5+TC5MUk1OEolllB9E+1DqpU=;
	h=Date:To:From:Subject:Message-Id; b=bOmUz34Fbo6gIq1GJbiMX6DbqEKvqrcLw5KEachSJ8SD/JRpvZLPxcXM+Dl5NXVknfTQbqbLTD1+9IR0wvoxZE1e4pJKmYR9us9A20VzXKIEZSAiKbXrV5q3NPJDOUGrZJpRmQz6aWvSh3I+iZylxLYXZ6kFa3ha1DCR5S+Y7KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iR6yAYZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iR6yAYZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF663C32781;
	Mon, 20 May 2024 00:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716164610;
	bh=07ZqnyO+58MyOTvDuDv5+TC5MUk1OEolllB9E+1DqpU=;
	h=Date:To:From:Subject:From;
	b=iR6yAYZGwk9X8wJqtJXg82nV84c36SN72Pze3zlilGLXRky8VNq1piTg+YYjEYTPL
	 UxKpBP154oichdIdzkx+mS7dVt5402Q/DozzN0PxFwOosMvJzRXeYe/jmDEjryn3V4
	 BLHLUK8QMGTM/9j/bn/z/73bb0G/ZIgKLXQNypX0=
Date: Sun, 19 May 2024 17:23:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-factor-out-domain_over_bg_thresh-to-remove-repeated-code.patch added to mm-unstable branch
Message-Id: <20240520002330.AF663C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: factor out domain_over_bg_thresh to remove repeated code
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-factor-out-domain_over_bg_thresh-to-remove-repeated-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-factor-out-domain_over_bg_thresh-to-remove-repeated-code.patch

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
Subject: writeback: factor out domain_over_bg_thresh to remove repeated code
Date: Tue, 14 May 2024 20:52:49 +0800

Factor out domain_over_bg_thresh from wb_over_bg_thresh to remove repeated
code.

Link: https://lkml.kernel.org/r/20240514125254.142203-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

--- a/mm/page-writeback.c~writeback-factor-out-domain_over_bg_thresh-to-remove-repeated-code
+++ a/mm/page-writeback.c
@@ -2116,6 +2116,20 @@ static void wb_bg_dirty_limits(struct di
 		dtc->wb_dirty = wb_stat(wb, WB_RECLAIMABLE);
 }
 
+static bool domain_over_bg_thresh(struct dirty_throttle_control *dtc)
+{
+	domain_dirty_avail(dtc, false);
+	domain_dirty_limits(dtc);
+	if (dtc->dirty > dtc->bg_thresh)
+		return true;
+
+	wb_bg_dirty_limits(dtc);
+	if (dtc->wb_dirty > dtc->wb_bg_thresh)
+		return true;
+
+	return false;
+}
+
 /**
  * wb_over_bg_thresh - does @wb need to be written back?
  * @wb: bdi_writeback of interest
@@ -2127,31 +2141,14 @@ static void wb_bg_dirty_limits(struct di
  */
 bool wb_over_bg_thresh(struct bdi_writeback *wb)
 {
-	struct dirty_throttle_control gdtc_stor = { GDTC_INIT(wb) };
-	struct dirty_throttle_control mdtc_stor = { MDTC_INIT(wb, &gdtc_stor) };
-	struct dirty_throttle_control * const gdtc = &gdtc_stor;
-	struct dirty_throttle_control * const mdtc = mdtc_valid(&mdtc_stor) ?
-						     &mdtc_stor : NULL;
-
-	domain_dirty_avail(gdtc, false);
-	domain_dirty_limits(gdtc);
-	if (gdtc->dirty > gdtc->bg_thresh)
-		return true;
+	struct dirty_throttle_control gdtc = { GDTC_INIT(wb) };
+	struct dirty_throttle_control mdtc = { MDTC_INIT(wb, &gdtc) };
 
-	wb_bg_dirty_limits(gdtc);
-	if (gdtc->wb_dirty > gdtc->wb_bg_thresh)
+	if (domain_over_bg_thresh(&gdtc))
 		return true;
 
-	if (mdtc) {
-		domain_dirty_avail(mdtc, false);
-		domain_dirty_limits(mdtc);	/* ditto, ignore writeback */
-		if (mdtc->dirty > mdtc->bg_thresh)
-			return true;
-
-		wb_bg_dirty_limits(mdtc);
-		if (mdtc->wb_dirty > mdtc->wb_bg_thresh)
-			return true;
-	}
+	if (mdtc_valid(&mdtc))
+		return domain_over_bg_thresh(&mdtc);
 
 	return false;
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

