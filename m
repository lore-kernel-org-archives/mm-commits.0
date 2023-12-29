Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B7912B99
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jGE/Ij6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB254C433C8;
	Fri, 29 Dec 2023 19:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703876841;
	bh=XkE7oRTmBrwi1P6hVtpRpDzB8hUhb/NSxiY5QgThkUI=;
	h=Date:To:From:Subject:From;
	b=jGE/Ij6jtI3sSLlDgf74xMi4WfBXxQrpwG7IFyGtGJPWvWJK6GALHjPvH6eBmyhuw
	 tpF7FRA90zuSs8lLe7Gwga8JFkSqpe/H8gcGca3+Psgsy+Ozk+Mxd2tvrPN6lMx34G
	 AIAj2KnXjWRTwr3wMV9BKsrTKztGErylCvxoMoHY=
Date: Fri, 29 Dec 2023 11:07:21 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shr@devkernel.io,joseph.qi@linux.alibaba.com,jefflexu@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-arithmetic-for-bdi-min_ratio.patch removed from -mm tree
Message-Id: <20231229190721.AB254C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix arithmetic for bdi min_ratio
has been removed from the -mm tree.  Its filename was
     mm-fix-arithmetic-for-bdi-min_ratio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jingbo Xu <jefflexu@linux.alibaba.com>
Subject: mm: fix arithmetic for bdi min_ratio
Date: Tue, 19 Dec 2023 22:25:07 +0800

Since now bdi->min_ratio is part per million, fix the wrong arithmetic. 
Otherwise it will fail with -EINVAL when setting a reasonable min_ratio,
as it tries to set min_ratio to (min_ratio * BDI_RATIO_SCALE) in
percentage unit, which exceeds 100% anyway.

    # cat /sys/class/bdi/253\:0/min_ratio
    0
    # cat /sys/class/bdi/253\:0/max_ratio
    100
    # echo 1 > /sys/class/bdi/253\:0/min_ratio
    -bash: echo: write error: Invalid argument

Link: https://lkml.kernel.org/r/20231219142508.86265-2-jefflexu@linux.alibaba.com
Fixes: 8021fb3232f2 ("mm: split off __bdi_set_min_ratio() function")
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page-writeback.c~mm-fix-arithmetic-for-bdi-min_ratio
+++ a/mm/page-writeback.c
@@ -692,7 +692,6 @@ static int __bdi_set_min_ratio(struct ba
 
 	if (min_ratio > 100 * BDI_RATIO_SCALE)
 		return -EINVAL;
-	min_ratio *= BDI_RATIO_SCALE;
 
 	spin_lock_bh(&bdi_lock);
 	if (min_ratio > bdi->max_ratio) {
_

Patches currently in -mm which might be from jefflexu@linux.alibaba.com are


