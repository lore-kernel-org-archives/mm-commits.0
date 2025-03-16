Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0B43FE4
	for <mm-commits@vger.kernel.org>; Sun, 16 Mar 2025 04:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742099855; cv=none; b=eU98QEh4KLgIyzyEA3YCR3sE5kw6t4xVpZmDQN76QfP9jnIOxSuDIIoaqLpNP+fY2ADUSTNuJ8Sl7vN8NHYt1A+GSSVdOlx3kggHj3avJAVLSVOReXdhfddP+fE+HWP1/RB7qPJrILVMEZvGLCcf7Q9bM/TrpCue+fXcRbtGao4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742099855; c=relaxed/simple;
	bh=o7UcerWzN4Q3KIfDfLE7ZAvx2c//7gyOGgcIsKotdpM=;
	h=Date:To:From:Subject:Message-Id; b=oo7BId7iJVodqpVqs7MyeYxHcCzF/7INzx3RdUUV6Tn/jJc1+PoVR0A/dDlxUPQGX8eV9BaQGsUDg0TQ9zVxc5QUJhK5z4tf/aEEXKMS2c0+aBb1cSQKU4crSqYTyl6ZY5L/OBR7wtTu6nb4ieRiX1rVifSo4xXYMBsISyyrEqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y6zep53l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y6zep53l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A838CC4CEDD;
	Sun, 16 Mar 2025 04:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742099854;
	bh=o7UcerWzN4Q3KIfDfLE7ZAvx2c//7gyOGgcIsKotdpM=;
	h=Date:To:From:Subject:From;
	b=Y6zep53l/lpQPBHz4rLyvuDTT9h0VoylHVq40fJww4AVtsnGqKP4YaSVBgB4+5Vas
	 d5Y+mKCtDluwwjghkE19fnOESQct4ojxcCZ8y4YyMIi2KgP0NpWjcSvZudq8JvLVCR
	 1EHiHq6t8wAf08MNHhrsuK5iDl+njJcy8MIDgnew=
Date: Sat, 15 Mar 2025 21:37:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,mgorman@techsingularity.net,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-push-watermark-into-compaction_suitable-callers-fix.patch added to mm-unstable branch
Message-Id: <20250316043734.A838CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: compaction: push watermark into compaction_suitable() callers fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-push-watermark-into-compaction_suitable-callers-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-push-watermark-into-compaction_suitable-callers-fix.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm: compaction: push watermark into compaction_suitable() callers fix
Date: Sat, 15 Mar 2025 21:28:16 -0700 (PDT)

Stop oops on out-of-range highest_zoneidx: compaction_suitable() pass
args to __compaction_suitable() in the order which it is expecting.

Link: https://lkml.kernel.org/r/005ace8b-07fa-01d4-b54b-394a3e029c07@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-push-watermark-into-compaction_suitable-callers-fix
+++ a/mm/compaction.c
@@ -2417,7 +2417,7 @@ bool compaction_suitable(struct zone *zo
 	enum compact_result compact_result;
 	bool suitable;
 
-	suitable = __compaction_suitable(zone, order, highest_zoneidx, watermark,
+	suitable = __compaction_suitable(zone, order, watermark, highest_zoneidx,
 					 zone_page_state(zone, NR_FREE_PAGES));
 	/*
 	 * fragmentation index determines if allocation failures are due to
_

Patches currently in -mm which might be from hughd@google.com are

mm-compaction-push-watermark-into-compaction_suitable-callers-fix.patch

