Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7827F3A1AD
	for <mm-commits@vger.kernel.org>; Tue, 19 Dec 2023 20:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2W2G+JwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F4EC433C8;
	Tue, 19 Dec 2023 20:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703019077;
	bh=jqu//i63yzu14YXHWaw+wLfgyRHKQeHiWOfkghTser0=;
	h=Date:To:From:Subject:From;
	b=2W2G+JwNx1bAUq2tCAL50n8dK/KwFkd88cCI3lukcjGgyVT0XjDcL5sNJAO3SST+Z
	 6Ka0s4RP3nY9zArLbnWHFmhZm8Vx32JLZOWiyHzgOIPDPJtmxstxjkkwFwUVJk1RB/
	 VC2zISxHvfpGtKzfII1EkIoCuGzIS0LjT6ZDgvWA=
Date: Tue, 19 Dec 2023 12:51:16 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shr@devkernel.io,joseph.qi@linux.alibaba.com,jefflexu@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-arithmetic-for-bdi-min_ratio.patch added to mm-hotfixes-unstable branch
Message-Id: <20231219205117.B6F4EC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix arithmetic for bdi min_ratio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-arithmetic-for-bdi-min_ratio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-arithmetic-for-bdi-min_ratio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-fix-arithmetic-for-bdi-min_ratio.patch
mm-fix-arithmetic-for-max_prop_frac-when-setting-max_ratio.patch

