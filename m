Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE7521D3E9
	for <mm-commits@vger.kernel.org>; Sun,  6 Apr 2025 23:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743981821; cv=none; b=JYjA5zPnIy8ZSpsAfYzyNw+ST0I/eP7NjRmA7Hvin20UZyvzHPYwNRlqpP+lbM/cnUa8qap8OMgk219VAYFcH0bBghOj79MwpwfyjAuMJmQ4lKCb92cbPEs6HkhIXju0ud5v9pJGWvapjSGSo2qiJ8QowA2vtGfQCAPr13te2QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743981821; c=relaxed/simple;
	bh=nFhP45PjTEZJkt6ay4FdrpNnfNer5mR8xia7NXSyQi8=;
	h=Date:To:From:Subject:Message-Id; b=sGqnU0EUtUeSx9A2Qe5t0IFmRg2mHOW6daaUs+qvzFJySztYk7NbOBeYaZ1DPoLM+2W+lsjBjRTxp23sGS7LljClYJTnOxzVyih1FW7KST6kGb91q+s4m0Xvjsyf5QTyiDSya4Je8TjWcTiFP1qYLZiRxVMvsGbFmzWlKCt2yBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lJG2xy/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lJG2xy/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78337C4CEE3;
	Sun,  6 Apr 2025 23:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743981819;
	bh=nFhP45PjTEZJkt6ay4FdrpNnfNer5mR8xia7NXSyQi8=;
	h=Date:To:From:Subject:From;
	b=lJG2xy/U4A0an4HYcNoh225N9aVw37FhqQ1eafg3E+wdbRQbMM5JHqWYWWcwqdYCK
	 cCBefSSuPq383Xb5PljvslXeIAuhL9SWQhifjuNvnTsDbkb/q1cZh1AI7AhKuoAeWE
	 YPR+S9qmiQ/5YgnIelOKv69cptJJlqmuIzSjmtyM=
Date: Sun, 06 Apr 2025 16:23:38 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,mclapinski@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-reduce-the-difference-between-low-and-high-watermarks.patch added to mm-new branch
Message-Id: <20250406232339.78337C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: reduce the difference between low and high watermarks
has been added to the -mm mm-new branch.  Its filename is
     mm-compaction-reduce-the-difference-between-low-and-high-watermarks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-reduce-the-difference-between-low-and-high-watermarks.patch

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
Subject: mm/compaction: reduce the difference between low and high watermarks
Date: Fri, 4 Apr 2025 13:11:03 +0200

Reduce the diff between low and high watermarks when compaction
proactiveness is set to high.  This allows users who set the proactiveness
really high to have more stable fragmentation score over time.

Link: https://lkml.kernel.org/r/20250404111103.1994507-3-mclapinski@google.com
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    6 ++++++
 mm/compaction.c                         |    5 +++--
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-compaction-reduce-the-difference-between-low-and-high-watermarks
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -131,6 +131,12 @@ to latency spikes in unsuspecting applic
 various heuristics to avoid wasting CPU cycles if it detects that
 proactive compaction is not being effective.
 
+Setting the value above 80 will, in addition to lowering the acceptable level
+of fragmentation, make the compaction code more sensitive to increases in
+fragmentation, i.e. compaction will trigger more often, but reduce
+fragmentation by a smaller amount.
+This makes the fragmentation level more stable over time.
+
 Be careful when setting it to extreme values like 100, as that may
 cause excessive background compaction activity.
 
--- a/mm/compaction.c~mm-compaction-reduce-the-difference-between-low-and-high-watermarks
+++ a/mm/compaction.c
@@ -2249,10 +2249,11 @@ static unsigned int fragmentation_score_
 
 static unsigned int fragmentation_score_wmark(bool low)
 {
-	unsigned int wmark_low;
+	unsigned int wmark_low, leeway;
 
 	wmark_low = 100U - sysctl_compaction_proactiveness;
-	return low ? wmark_low : min(wmark_low + 10, 100U);
+	leeway = min(10U, wmark_low / 2);
+	return low ? wmark_low : min(wmark_low + leeway, 100U);
 }
 
 static bool should_proactive_compact_node(pg_data_t *pgdat)
_

Patches currently in -mm which might be from mclapinski@google.com are

mm-compaction-remove-low-watermark-cap-for-proactive-compaction.patch
mm-compaction-reduce-the-difference-between-low-and-high-watermarks.patch

