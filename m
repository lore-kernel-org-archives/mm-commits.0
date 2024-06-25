Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AE313D624
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291546; cv=none; b=N8ABX8lNDabDJKXNkz1FuNVvBXHciA2Ea9cx+rkQ6wSwE3WP9MlKBcnnJV/TZwjO9/ncfuZDDnvJL61/xl3V90nyrKKB60SLK7XaJBtyl85gtT7Jjx9JT7G7FK+PWaDERTDQED/WMdEqSGn7JtjvmnqXak/lz0vCdr+byz5w8s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291546; c=relaxed/simple;
	bh=FhhlmObWTFpiWk7EOUV61YgDhWXOcZmRQ3y8GFvilpc=;
	h=Date:To:From:Subject:Message-Id; b=suVyZVXAaOYRMt6G2P5rv5tMQGfK5SSzxqa5LgPCGDdVW6UtnTQiPVUn8BV/mTOQoRFOH751aKR2G1aSE0piTAEFVYw4DmnDbMwMSDiypJPj1x5kyn28JV8zKZTKJwNU82H+BkOxHX/d0LpM/RFfflUYl7010Kg42N1z2KeFb+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gqtZG4X1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gqtZG4X1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7CCC32782;
	Tue, 25 Jun 2024 04:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291546;
	bh=FhhlmObWTFpiWk7EOUV61YgDhWXOcZmRQ3y8GFvilpc=;
	h=Date:To:From:Subject:From;
	b=gqtZG4X1WoDRRknS4nGxkhASLNfsAJal7S1K1wFWdOLUlwD9piB+vEBAaqhkbkc0b
	 bywu4HTj+Q5lGSryYKTUPgKW9iwajhnpoupCMe3j1nidXU6k5uh6sjrq/f1H+n6YGG
	 JULAXxDPNo89PhSNPJ/pVpN+M06O4NJKJdeZ9tno=
Date: Mon, 24 Jun 2024 21:59:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-factor-out-balance_wb_limits-to-remove-repeated-code.patch removed from -mm tree
Message-Id: <20240625045906.AA7CCC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: factor out balance_wb_limits to remove repeated code
has been removed from the -mm tree.  Its filename was
     writeback-factor-out-balance_wb_limits-to-remove-repeated-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: writeback: factor out balance_wb_limits to remove repeated code
Date: Tue, 14 May 2024 20:52:54 +0800

Factor out balance_wb_limits to remove repeated code

[shikemeng@huaweicloud.com: add comment]
  Link: https://lkml.kernel.org/r/20240606033547.344376-1-shikemeng@huaweicloud.com
[akpm@linux-foundation.org: s/fileds/fields/ in comment]
Link: https://lkml.kernel.org/r/20240514125254.142203-9-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/mm/page-writeback.c~writeback-factor-out-balance_wb_limits-to-remove-repeated-code
+++ a/mm/page-writeback.c
@@ -1784,6 +1784,21 @@ static inline void wb_dirty_exceeded(str
 }
 
 /*
+ * The limits fields dirty_exceeded and pos_ratio won't be updated if wb is
+ * in freerun state. Please don't use these invalid fields in freerun case.
+ */
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
+/*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
  * the caller to wait once crossing the (background_thresh + dirty_thresh) / 2.
@@ -1869,12 +1884,9 @@ free_running:
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
@@ -1884,12 +1896,9 @@ free_running:
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


