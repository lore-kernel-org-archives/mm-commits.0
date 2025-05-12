Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1631E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011016; cv=none; b=sxLzFW20Q0O+Qpewl5NIAqCJovQ1PGIRdzPuwZWFMy78DsMEyW+QNQ4S7k7ZzRvVCB3AdrpMREP2te0JNql3Bvd1gaS/KEKYy0uQoQvip6l+4j+tpbwPxZQ0cVMFTbU0eWZDI72aO19/Krioh/cmnM64uk/sjBmY1Gi7uxkplGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011016; c=relaxed/simple;
	bh=Ue1pqmkACxdmBlIgiBZFizZJPw+Uvrd70zsD0QmWHXg=;
	h=Date:To:From:Subject:Message-Id; b=M9FoK4HEwAcL/jApUtc2uirhLhfu8LULdRxCJe8WPXwp4kgOZv4IwC5H6koSFTb9z38tfB/4w5ndvwW2zm2vsps/Ih0K5lH19ucAXhLGmkwKwDocYVfrKRi+ugZERQtgDY1s2hF2uQfSOPfRbCw9kBXX/lxmBVsuOhCjh7GR21g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0YgOJEDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0YgOJEDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6215BC4CEE4;
	Mon, 12 May 2025 00:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011016;
	bh=Ue1pqmkACxdmBlIgiBZFizZJPw+Uvrd70zsD0QmWHXg=;
	h=Date:To:From:Subject:From;
	b=0YgOJEDJGSjbUeAvDO+wn4D40EJ0HnOZlw/U1Mx88tNLexGofVlHvp1HwrycDkXcm
	 ednehZsZyoOr7fCkFc8RucDXZLoGcj4/CiXdsMlcSRf315pSsMD8UOUWcE+kU0Kujl
	 LLV9n8ci+3WtJUevTNVWWCamqnTCk//KEkHrSEro=
Date: Sun, 11 May 2025 17:50:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,mclapinski@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-reduce-the-difference-between-low-and-high-watermarks.patch removed from -mm tree
Message-Id: <20250512005016.6215BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/compaction: reduce the difference between low and high watermarks
has been removed from the -mm tree.  Its filename was
     mm-compaction-reduce-the-difference-between-low-and-high-watermarks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


