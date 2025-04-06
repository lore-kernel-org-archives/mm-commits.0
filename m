Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CA220DF4
	for <mm-commits@vger.kernel.org>; Sun,  6 Apr 2025 23:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743981818; cv=none; b=i/Ni77hEEtG8Kb87OquUJWQ5FhYWZFxdV+UjXT4k4QigWh1rlbdGLeWLHtKiAJbjyOF+yF15TnxeRZtCOERTcVzGhASVk6GxACyBXM/ipUHfivZjHs+GJNr+4ufSR/7fhpxyvZ8AzOrbOP0EcDjv+lB0T+XF5sQUMnapjdF84xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743981818; c=relaxed/simple;
	bh=ZlNAcF/JkVEHquL4NviWfFuEtnd8ETFr57+ILk8d18k=;
	h=Date:To:From:Subject:Message-Id; b=jfigdC9PQgq2/qFgkKh2aj3eGVq0VRprliRvw/PI7kzpFZbS/gp+L3W7mZk3uHl0SPXIFUUd9UEmQYfWLLnYtHZE0XFBotBNNiYwfx4J3vZ0NuIquXp1E/xY3ZvNkAmlkQxFcey95+hdReNvfJC1kg4f7K0zrubHKRb4bNTVG3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2LriXIA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2LriXIA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A466C4CEE3;
	Sun,  6 Apr 2025 23:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743981817;
	bh=ZlNAcF/JkVEHquL4NviWfFuEtnd8ETFr57+ILk8d18k=;
	h=Date:To:From:Subject:From;
	b=2LriXIA0rVu6MMCCj8Ulc3t2MwYkIFmsKcMZYv2hMABOtQOsRbOJ4fwpO10ugzQyr
	 HkS4Lxt8LVTJ4IHltDw43+R8+IeeO0x9k7S05/Z8gjfV4OE+21I7nLLLo1jqCblakG
	 Ytr7ibVOJpIAv6WAQ2h+V6ABnYJ11QCyZBXnCPPc=
Date: Sun, 06 Apr 2025 16:23:36 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,mclapinski@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-remove-low-watermark-cap-for-proactive-compaction.patch added to mm-new branch
Message-Id: <20250406232337.7A466C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: remove low watermark cap for proactive compaction
has been added to the -mm mm-new branch.  Its filename is
     mm-compaction-remove-low-watermark-cap-for-proactive-compaction.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-remove-low-watermark-cap-for-proactive-compaction.patch

This patch will later appear in the mm-new branch at
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

mm-compaction-remove-low-watermark-cap-for-proactive-compaction.patch
mm-compaction-reduce-the-difference-between-low-and-high-watermarks.patch

