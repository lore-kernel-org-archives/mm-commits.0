Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296621E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011015; cv=none; b=WHofSGFbcfGZUrr+Y10uLGgDwAyrmsTr+OdlR0NzWBrPcvFLRXMcgN5mAeDqgNrhpXqZ64tulF+WOmZ+5kY0WAREwMboWd4lS3FzZtKHcgdL7Iaa+ISYFDJzxYkZbxlkE9S55l0RtIYuk44Od3WiBsiZuo75y8GynypZyG3z66o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011015; c=relaxed/simple;
	bh=zEEo78ozulpZ5nN3xF3Wi2u2cvUyBbJlRq7+NwU03/4=;
	h=Date:To:From:Subject:Message-Id; b=HrMicLYNCXVvYK5U6ICHiPGD0t+EcLe9ri0NVs16uqwnOXOHcoBagL8ecn3FqzOxwBvymKpGTy9oOJ4t+IplXcsRGTQ0IY0je5k+5Ziqxm0Wu0iv3IFR+4NGdU9bzEKOBO0kRTJwBn0yDn4INtvyEPqddPbWKAwwZxwVPtkMspA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DhZx6g9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DhZx6g9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FCAC4CEE4;
	Mon, 12 May 2025 00:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011015;
	bh=zEEo78ozulpZ5nN3xF3Wi2u2cvUyBbJlRq7+NwU03/4=;
	h=Date:To:From:Subject:From;
	b=DhZx6g9tSqx8MFl6GmIEkPydZen0uZ74EwuLiOldoshuHU3ZI9bjL7bL0O3Fd1E6y
	 HYYTnBKdS2iKhwMRJROZs5NbMKv/ti6y7899A+xVT52p7a81bLnUlX+raE0WV3Fd/W
	 SeMkhL2JVoVnxVHeVsonBR8EnTz0Iqw0A07Rpg48=
Date: Sun, 11 May 2025 17:50:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,mclapinski@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-remove-low-watermark-cap-for-proactive-compaction.patch removed from -mm tree
Message-Id: <20250512005014.F3FCAC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/compaction: remove low watermark cap for proactive compaction
has been removed from the -mm tree.  Its filename was
     mm-compaction-remove-low-watermark-cap-for-proactive-compaction.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Clapinski <mclapinski@google.com>
Subject: mm/compaction: remove low watermark cap for proactive compaction
Date: Fri, 4 Apr 2025 13:11:02 +0200

Patch series "mm/compaction: allow more aggressive proactive compaction",
v4.

Our goal is to keep memory usage of a VM low on the host.  For that
reason, we use free page reporting which by default reports free pages of
order 9 and larger to the host to be freed.  The feature works well only
if the memory in the guest is not fragmented below pages of order 9. 
Proactive compaction can be reused to achieve defragmentation after some
parameter tweaking.

When the fragmentation score (lower is better) gets larger than the high
watermark, proactive compaction kicks in.  Compaction stops when the score
goes below the low watermark (or no progress is made and backoff kicks
in).  Let's define the difference between high and low watermarks as
leeway.  Before these changes, the minimum possible value for low
watermark was 5 and the leeway was hardcoded to 10 (so minimum possible
value for high watermark was 15).

To test this, I created a VM with 19GB of memory and free page reporting
enabled.  The VM was ~idle.  I meassured the memory usage from inside the
guest (/proc/meminfo) and from the host (provided by the hypervisor).

Before:
https://drive.google.com/file/d/1Xw23lRry_PgEH3f6QRnSGvoHh2u9UHyI/view?usp=sharing
After:
https://drive.google.com/file/d/1wMhpIzepx6t44F70yCPA50n1S5V2AT-a/view?usp=sharing


This patch (of 2):

Previously a min cap of 5 has been set in the commit introducing proactive
compaction.  This was to make sure users don't hurt themselves by setting
the proactiveness to 100 and making their system unresponsive.  But the
compaction mechanism has a backoff mechanism that will sleep for 30s if no
progress is made, so I don't see a significant risk here.  My system (19GB
of memory) has been perfectly fine with both watermarks hardcoded to 0.

Link: https://lkml.kernel.org/r/20250404111103.1994507-1-mclapinski@google.com
Link: https://lkml.kernel.org/r/20250404111103.1994507-2-mclapinski@google.com
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/compaction.c~mm-compaction-remove-low-watermark-cap-for-proactive-compaction
+++ a/mm/compaction.c
@@ -2251,12 +2251,7 @@ static unsigned int fragmentation_score_
 {
 	unsigned int wmark_low;
 
-	/*
-	 * Cap the low watermark to avoid excessive compaction
-	 * activity in case a user sets the proactiveness tunable
-	 * close to 100 (maximum).
-	 */
-	wmark_low = max(100U - sysctl_compaction_proactiveness, 5U);
+	wmark_low = 100U - sysctl_compaction_proactiveness;
 	return low ? wmark_low : min(wmark_low + 10, 100U);
 }
 
_

Patches currently in -mm which might be from mclapinski@google.com are


