Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33CB3126DD;
	Sun, 12 Apr 2026 18:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776017065; cv=none; b=Un4FASCDQlDhutg/VbdEZUsJX9t1S8Kvq+mvJFGqstTkf/+3LvJt21o+Jf5k+28RWe3nRMTrYWiGWbvGGoVXss7BWC+tnhfkzZxJoGtAWvpIbXWsre3FBsn2Mqp/VIjTddiMk/JvNyivJVQwolkGqIpNtBYn5nUVgoz35SVz+HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776017065; c=relaxed/simple;
	bh=aLdgOQAfkrBrSvxflLil3kfDz3PtawHxAG0TMS4EbWU=;
	h=Date:To:From:Subject:Message-Id; b=ESCrzXoBY9tbkrdrS+9ojqzEUC3slrOYPnm+DlNYjQdMOyHOpffzdWwtbN/gBj7u/W0sCMgctILGpQ/HGquiYVM8T+bl0v9cVY6s4ZAY9JmeKWEK9rRBr2H/XQrecFDaYbnL+LKOgoAy9KJ990VbISQv/ihfKK0dYudaFRJ435c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lCNWNRZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lCNWNRZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21E7C19424;
	Sun, 12 Apr 2026 18:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776017065;
	bh=aLdgOQAfkrBrSvxflLil3kfDz3PtawHxAG0TMS4EbWU=;
	h=Date:To:From:Subject:From;
	b=lCNWNRZHRY4qlcts/ScB95Wx3u9YCjD9Af8i6adCQkpXEtN7vocy/2I1Ht9Vs3Ur1
	 bvxicrbkYGgIfshG1bmkAR/rEU2me49CCUIpEQ2p0VrDyr7hNAwKAAQQAUksx2lqnE
	 2puphGwd+vow3w3vqEMGw0itwQQIsLoxpuj6PT1Y=
Date: Sun, 12 Apr 2026 11:04:21 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,stable@vger.kernel.org,osalvador@suse.de,david@kernel.org,balbirs@nvidia.com,matthew.brost@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zone_device-do-not-touch-device-folio-after-calling-folio_free.patch added to mm-hotfixes-unstable branch
Message-Id: <20260412180424.C21E7C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zone_device: do not touch device folio after calling ->folio_free()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zone_device-do-not-touch-device-folio-after-calling-folio_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zone_device-do-not-touch-device-folio-after-calling-folio_free.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Matthew Brost <matthew.brost@intel.com>
Subject: mm/zone_device: do not touch device folio after calling ->folio_free()
Date: Fri, 10 Apr 2026 16:03:46 -0700

The contents of a device folio can immediately change after calling
->folio_free(), as the folio may be reallocated by a driver with a
different order.  Instead of touching the folio again to extract the
pgmap, use the local stack variable when calling percpu_ref_put_many().

Link: https://lkml.kernel.org/r/20260410230346.4009855-1-matthew.brost@intel.com
Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memremap.c~mm-zone_device-do-not-touch-device-folio-after-calling-folio_free
+++ a/mm/memremap.c
@@ -454,7 +454,7 @@ void free_zone_device_folio(struct folio
 		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
 			break;
 		pgmap->ops->folio_free(folio);
-		percpu_ref_put_many(&folio->pgmap->ref, nr);
+		percpu_ref_put_many(&pgmap->ref, nr);
 		break;
 
 	case MEMORY_DEVICE_GENERIC:
_

Patches currently in -mm which might be from matthew.brost@intel.com are

mm-zone_device-do-not-touch-device-folio-after-calling-folio_free.patch

