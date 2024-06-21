Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C6759155;
	Fri, 21 Jun 2024 17:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989960; cv=none; b=UST9Rs11fK6X/IDIFDV97ZIqqs75tFxz97IqTq7Cn0WlWVXoSkkYqj2h1WW9jWPAx0NAxVUJ7KCONbxw4EWgJdkNwoml4cgU9ufvzhnwuzIuBJLpMdrwPwikBqbhXvln4fjo2A3E0TPgtaQndV3ymyEepBz3R1bxN83/B8s8U9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989960; c=relaxed/simple;
	bh=Jghk4pyl4Z34T16vjHf0Gw1TzdKKIPp1S6KPJorLW9E=;
	h=Date:To:From:Subject:Message-Id; b=B9eum4Wps0tYPV/RSwTMm7kdYNjpyLtCKKPe7ZnuwUGtZNVXyGWsUZPfC7ASxTtcBN4j3mszDJkKvaS4UsuGyzEYCswMGALtugsjrOgvY5dQnPDlTUFoG3LgtUAQ1XAbUmF+Ykuaw4JjsBYxmPFz2xrdWCUUpbN4p0i+FOAG9Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VvwU4TVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VvwU4TVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53536C2BBFC;
	Fri, 21 Jun 2024 17:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718989958;
	bh=Jghk4pyl4Z34T16vjHf0Gw1TzdKKIPp1S6KPJorLW9E=;
	h=Date:To:From:Subject:From;
	b=VvwU4TVHz0zLW7SBP8izpyCh7Mb40rul7ByQ4AGlki9Xn5DTBnbvRlZ/+Xw2p6pAJ
	 mtDimIW+m31yqlR8Eh1yS6V4yaCBbAb+X1Ouh0N7yu02CDMrPJDwVQZqzjekod1VOT
	 d9fObQVg1p01d79ITneo6iYYb6txhg0ZGHw0lJg4=
Date: Fri, 21 Jun 2024 10:12:37 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,stable@vger.kernel.org,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch added to mm-unstable branch
Message-Id: <20240621171238.53536C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again"
has been added to the -mm mm-unstable branch.  Its filename is
     revert-mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch

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
From: Jan Kara <jack@suse.cz>
Subject: Revert "mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again"
Date: Fri, 21 Jun 2024 16:42:37 +0200

Patch series "mm: Avoid possible overflows in dirty throttling".

Dirty throttling logic assumes dirty limits in page units fit into
32-bits.  This patch series makes sure this is true (see patch 2/2 for
more details).


This patch (of 2):

This reverts commit 9319b647902cbd5cc884ac08a8a6d54ce111fc78.

The commit is broken in several ways.  Firstly, the removed (u64) cast
from the multiplication will introduce a multiplication overflow on 32-bit
archs if wb_thresh * bg_thresh >= 1<<32 (which is actually common - the
default settings with 4GB of RAM will trigger this).  Secondly, the
div64_u64() is unnecessarily expensive on 32-bit archs.  We have
div64_ul() in case we want to be safe & cheap.  Thirdly, if dirty
thresholds are larger than 1<<32 pages, then dirty balancing is going to
blow up in many other spectacular ways anyway so trying to fix one
possible overflow is just moot.

Link: https://lkml.kernel.org/r/20240621144017.30993-1-jack@suse.cz
Link: https://lkml.kernel.org/r/20240621144246.11148-1-jack@suse.cz
Fixes: 9319b647902c ("mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again")
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~revert-mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again
+++ a/mm/page-writeback.c
@@ -1683,7 +1683,7 @@ static inline void wb_dirty_limits(struc
 	 */
 	dtc->wb_thresh = __wb_calc_thresh(dtc, dtc->thresh);
 	dtc->wb_bg_thresh = dtc->thresh ?
-		div64_u64(dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
+		div_u64((u64)dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
 
 	/*
 	 * In order to avoid the stacked BDI deadlock we need
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-fix-dio-failure-due-to-insufficient-transaction-credits.patch
revert-mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch
mm-avoid-overflows-in-dirty-throttling-logic.patch

