Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9093613C9A2
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291539; cv=none; b=U+sz38INRWFVMx49MXKR9un5O63QDaQ6CXv/2BY7K05HjAs2A8IMuuR+PfZ/EAFInwDPpkT7lRCCvD0r+7Eh/riZCP7Wd+Y4fJgXPofCWdVWO9msFm8GpUECogvIeYthkSZN8l18U1ezXTfAc5sjqICUXEdIjaJPAO92szlzJb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291539; c=relaxed/simple;
	bh=OyVOWLLUmQLKj2kQkXLP+bqUxsi8kabLO2ct8/SYShw=;
	h=Date:To:From:Subject:Message-Id; b=fKYYYNhZcRQATCfbe8I5OY2gw/0GLdoiC3oLZtH2j12gEWieJSJbeCUoCNxn5XYuR1NN/3d/ehTQOQbD6bZBRUYdkjsXpjjOzBkp6GncF0zDpV4Jz9QdEsNY/2LJwOjuhtorISSsCIdUSBJ8AhNXOM3IyOVf2chuAwu5v79/Hdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DCjTRka3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DCjTRka3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FB9C32782;
	Tue, 25 Jun 2024 04:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291539;
	bh=OyVOWLLUmQLKj2kQkXLP+bqUxsi8kabLO2ct8/SYShw=;
	h=Date:To:From:Subject:From;
	b=DCjTRka3tVVcRtXGM6YFGNx9eEsfeJiEeG0soBfb9NZh2Olc0oh3NYiHm2hkihbQs
	 MoDEBr3sT1uWySxbG7tU6xjlFQNurnSWfcGBBSRRlefN6ZR+eRYHERJbezTBlm8vOv
	 UzcOC31djO9X8TcGJqoFhEGhxYtwozQBxYOr0EqQ=
Date: Mon, 24 Jun 2024 21:58:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-factor-out-domain_over_bg_thresh-to-remove-repeated-code.patch removed from -mm tree
Message-Id: <20240625045859.62FB9C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: factor out domain_over_bg_thresh to remove repeated code
has been removed from the -mm tree.  Its filename was
     writeback-factor-out-domain_over_bg_thresh-to-remove-repeated-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


