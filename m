Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C0139AE3
	for <mm-commits@vger.kernel.org>; Tue, 19 Dec 2023 20:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A0IHFEsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959DBC433C8;
	Tue, 19 Dec 2023 20:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703019080;
	bh=q3sT46PAl/5gH3Y8zmkxmLGW22mJjwgnJMxDAcWx6UM=;
	h=Date:To:From:Subject:From;
	b=A0IHFEsXoRtmxfLjrPjYASAFkfjXTyEEoybG9fFQp5ju7SY2wDJhsWuJyEoSkuu0u
	 RGtoVPqZVChkT9ZHZxpBb+FI4XrYqV8uiJE2guA2lWYfbUnUa+SIigrrJ0fMQ1S5Od
	 2uiHdJOvQnlURRCvg31tM/Isp+yEKaOETcUhHvQk=
Date: Tue, 19 Dec 2023 12:51:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shr@devkernel.io,joseph.qi@linux.alibaba.com,jefflexu@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-arithmetic-for-max_prop_frac-when-setting-max_ratio.patch added to mm-hotfixes-unstable branch
Message-Id: <20231219205120.959DBC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix arithmetic for max_prop_frac when setting max_ratio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-arithmetic-for-max_prop_frac-when-setting-max_ratio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-arithmetic-for-max_prop_frac-when-setting-max_ratio.patch

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

mm-fix-arithmetic-for-bdi-min_ratio.patch
mm-fix-arithmetic-for-max_prop_frac-when-setting-max_ratio.patch

