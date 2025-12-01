Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD32B3191A2;
	Mon,  1 Dec 2025 17:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764610893; cv=none; b=No4EhWrW3yaQO95QYvK4wg8E2IrWiSFwsprK96qKesSt/QE++8SSlnObeAbdGhEirqpwRzh4iANkzZ+7WjrPvT47yLhU9yxwUsOPia9w2DiUPvM+b6ZDVPbiJe81X+OWv6ipn+wf5RoNKhP9uBmzgXfUwE6+wzOiqOLs09aLrH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764610893; c=relaxed/simple;
	bh=ACTysoEHwztCPkOCIliLNO10BVmxqlVwbaF8x8hyCpY=;
	h=Date:To:From:Subject:Message-Id; b=TnQWXSVc4a3r2thVjHUcVXrUcHyc0nmqlSrnwnzhx1sF6/PmjAch+GXl2CvAvpTGCT78spT+xaiRqE1Ll2RPQ9UpLBsc5Rtk+xDb1hTLSNOpkKk6UvT0MZ8maXUVxBz11oWPu80eXqHC5U1i89LZdOHaAIFF07I1DLf6scWxoSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RF90PUg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RF90PUg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8714FC4CEF1;
	Mon,  1 Dec 2025 17:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764610893;
	bh=ACTysoEHwztCPkOCIliLNO10BVmxqlVwbaF8x8hyCpY=;
	h=Date:To:From:Subject:From;
	b=RF90PUg5K1vffHfKUPBq4HjLg+6IuXs/ZY36ZE4DgU6N/Q7aGTB/OCYH1LzIsea99
	 1x12TbxLY0i/CCb7wLE0L6MGS7QzBrvB0gpO+erWQjOCu6cZQYW7BnjSe98N4M0WAV
	 pphfdItMSWcOnMBq9ge6F7gTUxTsk35ohM9K3Uls=
Date: Mon, 01 Dec 2025 09:41:33 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,aboorvad@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free.patch added to mm-hotfixes-unstable branch
Message-Id: <20251201174133.8714FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: make percpu_pagelist_high_fraction reads lock-free
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free.patch

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
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: mm/page_alloc: make percpu_pagelist_high_fraction reads lock-free
Date: Mon, 1 Dec 2025 11:30:09 +0530

When page isolation loops indefinitely during memory offline, reading
/proc/sys/vm/percpu_pagelist_high_fraction blocks on pcp_batch_high_lock,
causing hung task warnings.

Make procfs reads lock-free since percpu_pagelist_high_fraction is a
simple integer with naturally atomic reads, writers still serialize via
the mutex.

This prevents hung task warnings when reading the procfs file during
long-running memory offline operations.

Link: https://lkml.kernel.org/r/20251201060009.1420792-1-aboorvad@linux.ibm.com
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free
+++ a/mm/page_alloc.c
@@ -6611,11 +6611,14 @@ static int percpu_pagelist_high_fraction
 	int old_percpu_pagelist_high_fraction;
 	int ret;
 
+	if (!write)
+		return proc_dointvec_minmax(table, write, buffer, length, ppos);
+
 	mutex_lock(&pcp_batch_high_lock);
 	old_percpu_pagelist_high_fraction = percpu_pagelist_high_fraction;
 
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (!write || ret < 0)
+	if (ret < 0)
 		goto out;
 
 	/* Sanity checking to avoid pcp imbalance */
_

Patches currently in -mm which might be from aboorvad@linux.ibm.com are

mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free.patch

