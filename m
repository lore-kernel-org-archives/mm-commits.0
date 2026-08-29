Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CCE187346
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 22:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788042017; cv=none; b=kixye5Pjg8HTbvWK/u7GdJ+++6PPIoFvlwmq3nZmvGndNrLqjvOLzWFXG4BoUW5dWqr3eFgKtQGV7/SRh8UYXceflWcyAAoUa3RvJ63pZStox1MRrUwe0JYwkO2wYTA94rbxks9hGOFBNlpJ3p8Mb6gxTu/W1qUpk0uIZgBAIuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788042017; c=relaxed/simple;
	bh=27lYlJPODHrkeGpSEry1n0Tv8tm174gm5GIXWYw1eSc=;
	h=Date:To:From:Subject:Message-Id; b=I0+su/9JlfBbKov5r9Od4ggkQ4kU23ha+ANAYlLqwXyimy2xkbHj6Wdx8Nc7amfUnaHJT9lCz8DuPbg613gerjtW2OKvDwKu39L+7nRmf8q1a6fwqLDTRMtdNwWqPl6NeYaO0TpQsEDCA8VP+6ZvH7nZag4yIBklaS7H8iF2GQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sxS69u2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sxS69u2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1410A1F000E9;
	Sat, 29 Aug 2026 22:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788042015;
	bh=BJrdJM4XssvhASuGrDnPxn0d3QfIkroxVtFb9FE+OTc=;
	h=Date:To:From:Subject;
	b=sxS69u2WmfNcQwWqQ3D9xqiRX6c1FtWv3UnrM04P18mkB2FkASQQ+m5EE+tMTv0Ng
	 UPC7HOPvZck2g4YHG5J4o0PbigVxI8NCiK8FeNjykP8GMG4gqGtT+9YKN5fRjmkS91
	 dSYVA+DBg+jJH5Mcden7cg4CPNQ5KpT0PTe5G7iM=
Date: Sat, 29 Aug 2026 15:20:14 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chenridong@xiaomi.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-make-retry-logic-explicit-in-isolate_folios.patch added to mm-new branch
Message-Id: <20260829222015.1410A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: make retry logic explicit in isolate_folios()
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-make-retry-logic-explicit-in-isolate_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-make-retry-logic-explicit-in-isolate_folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: make retry logic explicit in isolate_folios()
Date: Sat, 29 Aug 2026 15:42:04 +0800

The existing mainline code retries the same type once in a rather subtle
way.  `for_each_evictable_type()` may provide one more iteration, allowing
the same type to be retried if we scanned some folios but failed to
isolate any due to protections, promotions, or races.  This patch makes
the retry behavior explicit.

Link: https://lore.kernel.org/20260829074204.45304-3-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ridong Chen <chenridong@xiaomi.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/vmscan.c~mm-mglru-make-retry-logic-explicit-in-isolate_folios
+++ a/mm/vmscan.c
@@ -4843,6 +4843,7 @@ static int isolate_folios(unsigned long
 	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
 	int type = get_type_to_scan(lruvec, swappiness);
 	int total_scanned = 0, scanned, tier;
+	bool tried = false;
 
 retry:
 	tier = get_tier_idx(lruvec, type);
@@ -4862,9 +4863,18 @@ retry:
 	 */
 	if (!scanned && type_fallback_allowed) {
 		type = !type;
+		tried = true;
 		type_fallback_allowed = false;
 		goto retry;
 	}
+	/*
+	 * We scanned some folios but failed to isolate any due to promotions,
+	 * protections, or races. Retry once to avoid a larger loop.
+	 */
+	if (scanned && !tried) {
+		tried = true;
+		goto retry;
+	}
 
 	return total_scanned;
 }
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-make-retry-logic-explicit-in-isolate_folios.patch

