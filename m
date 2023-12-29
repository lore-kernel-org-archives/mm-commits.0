Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1597912E46
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tnLuMeCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3C3C433C7;
	Fri, 29 Dec 2023 19:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703876842;
	bh=7GQ+gNxYbJbxH+Qs0UqggSyizuXAQeBsUBsdMhzPWyE=;
	h=Date:To:From:Subject:From;
	b=tnLuMeCylkEMixiWSMnV/FijfChX8fnGt4f+XNgyWKkStUPYTAfKWjimawUayYhDW
	 okBZUZ6MCWY/qmW3bFOjBl82Uw8GmQLx1k/yYjs4t5eIQsvexRplS/AkhHgsPHJA04
	 gLiJE1ruUNw4sYc0emBVxILrksWjcwUsjXPHTpqM=
Date: Fri, 29 Dec 2023 11:07:22 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shr@devkernel.io,joseph.qi@linux.alibaba.com,jefflexu@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-arithmetic-for-max_prop_frac-when-setting-max_ratio.patch removed from -mm tree
Message-Id: <20231229190722.CD3C3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix arithmetic for max_prop_frac when setting max_ratio
has been removed from the -mm tree.  Its filename was
     mm-fix-arithmetic-for-max_prop_frac-when-setting-max_ratio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jingbo Xu <jefflexu@linux.alibaba.com>
Subject: mm: fix arithmetic for max_prop_frac when setting max_ratio
Date: Tue, 19 Dec 2023 22:25:08 +0800

Since now bdi->max_ratio is part per million, fix the wrong arithmetic for
max_prop_frac when setting max_ratio.  Otherwise the miscalculated
max_prop_frac will affect the incrementing of writeout completion count
when max_ratio is not 100%.

Link: https://lkml.kernel.org/r/20231219142508.86265-3-jefflexu@linux.alibaba.com
Fixes: efc3e6ad53ea ("mm: split off __bdi_set_max_ratio() function")
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-fix-arithmetic-for-max_prop_frac-when-setting-max_ratio
+++ a/mm/page-writeback.c
@@ -728,7 +728,8 @@ static int __bdi_set_max_ratio(struct ba
 		ret = -EINVAL;
 	} else {
 		bdi->max_ratio = max_ratio;
-		bdi->max_prop_frac = (FPROP_FRAC_BASE * max_ratio) / 100;
+		bdi->max_prop_frac = (FPROP_FRAC_BASE * max_ratio) /
+						(100 * BDI_RATIO_SCALE);
 	}
 	spin_unlock_bh(&bdi_lock);
 
_

Patches currently in -mm which might be from jefflexu@linux.alibaba.com are


