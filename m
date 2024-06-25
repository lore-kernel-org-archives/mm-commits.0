Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F2813D243
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291544; cv=none; b=pC61ic7wqNs21oLWrEbC8nP1X6zoYv6bo5nA90VX3caCDbN8df47YKRfDF0CjJFBy/8TEWzM4JEbgVXGSMXdgNZltQ65Qwn7hj5y8fFQH4Mrmmei6Iu3m4EBtodrIDr2hnm/iL2zJrnGjNBhtSvAnOpi0U1lQ+I12a0CiU9NA88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291544; c=relaxed/simple;
	bh=Jh9O0JLBhB6oWew43dhn5jcQ6+c24RZpcHDOEyoVpso=;
	h=Date:To:From:Subject:Message-Id; b=SrI3nl+5dqq8mgFWSkanoOpWlVr1FlAY8Ic2VADopjsh4KaCTap3h5bn3gQE195NTq1Yd9BoFcxUNPk3o6+rkRxvJPfA0NMvzIra4fB+CIAzwjD4Vw6R+9lJo+t3vCoqMEpO5aLoIJWRXT/jAWBgn20sxjRI7arvR5+F41dEmns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EJKvcDLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EJKvcDLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4095C32782;
	Tue, 25 Jun 2024 04:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291543;
	bh=Jh9O0JLBhB6oWew43dhn5jcQ6+c24RZpcHDOEyoVpso=;
	h=Date:To:From:Subject:From;
	b=EJKvcDLsiEP0innJymVLI6XwB0wpsD6iaZC7dsi0r3Oh4qOFT1p4IpS1PnGYLQI6i
	 fN901znMTC7mpg8IXNl7QRx06rM6ERMYZVkjgqdh1VONpTeI8+TSVIqrb46n6w0kjO
	 xJSyjPfOfcbcbWvqS0LZYlwz6OWNlpW/vXHmdLbs=
Date: Mon, 24 Jun 2024 21:59:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-factor-out-balance_domain_limits-to-remove-repeated-code.patch removed from -mm tree
Message-Id: <20240625045903.C4095C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: factor out balance_domain_limits to remove repeated code
has been removed from the -mm tree.  Its filename was
     writeback-factor-out-balance_domain_limits-to-remove-repeated-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


