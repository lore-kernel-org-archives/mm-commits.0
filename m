Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EF21A8412
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161345; cv=none; b=kH/I1QnDbWTt3F4SJp5Bm3+kZHa5WbBVhrhk+lCuRstS62M11SckQ91WalwF3fK9zS1I6XUX5IwCHOEaKTilO52hRA/pcejAe0n9PyC8XxIlG5jhXIcdmEY/fodk1njkc8sn9xarbbfKCej3cpEsFxg9UwR6Bjyz7Z1F57PN7v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161345; c=relaxed/simple;
	bh=506Ko5eF5qqwg9c51rQocSg2ps6RPFmbsFsvkqtQ8Cs=;
	h=Date:To:From:Subject:Message-Id; b=lUcgljXFggna0tVkM+GxeMGL+AnIEvHtwd9axUZKqGK55ecifiPWh6j3nMCJFA5K6q2XABfN3D4bnA2Mtgbftc886g92v+7YX0SZL+L+wxCgswY1LkT78tnfktYkDSS1WtYgxkvcZGI19H19AvLx7AHOVak9QFfwlwj45Ro9UZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VDCWXEYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VDCWXEYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E61C4CEF6;
	Sat,  2 Aug 2025 19:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161344;
	bh=506Ko5eF5qqwg9c51rQocSg2ps6RPFmbsFsvkqtQ8Cs=;
	h=Date:To:From:Subject:From;
	b=VDCWXEYDsxZKbrQjytuE4VmGyVXPts2IX6EY48/G15EAgl1aQOFIWTtAcCwt99yoy
	 nZt7X+/WL0EJKm34VJ4QbhnexwykpfxrIyUKNFgtZElnJmH9bTPX1IlOIXwTqjHB+d
	 7A9WPTHkcaqwvQAS+GaKIQbeYEZzNvghLdrKYMGM=
Date: Sat, 02 Aug 2025 12:02:24 -0700
To: mm-commits@vger.kernel.org,jonathan.cameron@huawei.com,dave.jiang@intel.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] cxl-mce-fix-typo-notifer.patch removed from -mm tree
Message-Id: <20250802190224.B5E61C4CEF6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cxl: mce: fix typo "notifer"
has been removed from the -mm tree.  Its filename was
     cxl-mce-fix-typo-notifer.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: cxl: mce: fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:25 +0800

According to the context, "mce_notifer" should be "mce_notifier".

Link: https://lkml.kernel.org/r/E1EB1BA9FDF07D53+20250722073431.21983-2-wangyuli@uniontech.com
Fixes: 516e5bd0b6bf ("cxl: Add mce notifier to emit aliased address for extended linear cache")
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cxl/core/mce.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cxl/core/mce.h~cxl-mce-fix-typo-notifer
+++ a/drivers/cxl/core/mce.h
@@ -7,7 +7,7 @@
 
 #ifdef CONFIG_CXL_MCE
 int devm_cxl_register_mce_notifier(struct device *dev,
-				   struct notifier_block *mce_notifer);
+				   struct notifier_block *mce_notifier);
 #else
 static inline int
 devm_cxl_register_mce_notifier(struct device *dev,
_

Patches currently in -mm which might be from wangyuli@uniontech.com are


