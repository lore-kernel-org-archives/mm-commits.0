Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832421C6FEC
	for <mm-commits@vger.kernel.org>; Tue, 11 Nov 2025 23:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762904931; cv=none; b=ZttSBLMOpm/qnYeQfh1DTnEbu8fsk8JL7kPynoEUi+Glm3kC6+7uRgO6cRB5ED41Fo66MC4gCa1mMEONNXXGEVgESgkbLq1rQNaKn5PogdHjhNrt6K/ZMF2LU19hDYkJ9iR1k7vbi3HJvdmbm7XFZF7n2eSd8rlCF00hgdsJscQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762904931; c=relaxed/simple;
	bh=JfLLTGcVkZFuj38mOdG0pF+nTYM3KOjRhuzPEyzuYjU=;
	h=Date:To:From:Subject:Message-Id; b=hRvYQuFLRpnvygfsN0Mjao8Y8/0Qw5wReGEu11e/0M6v8MQrG09PxVG3Rn62cMtPKZ6MlPox92ZHdMDDeejAbOiDs71nXzAGeSk8UQmjOSLHbpvw+LF5Re5OOmwYRp2B2rroSwPaNaEeCe2qJyuZc5l4DutVfHZWtYbTW4p0VFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zU13BglA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zU13BglA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014D3C116B1;
	Tue, 11 Nov 2025 23:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762904930;
	bh=JfLLTGcVkZFuj38mOdG0pF+nTYM3KOjRhuzPEyzuYjU=;
	h=Date:To:From:Subject:From;
	b=zU13BglATHO3s1KbIg4as22MtQ1YtHo4RaWD+D/f3AXSaR98h8t3mA8LXIS5+MAup
	 CebOZ4Clnskv49F6GC8KqXxJ1DWhQ6knJGTKUULQmZ7M6EYjHNHItl/Vt9b4Zs2gGL
	 FcaTMGsDIYITpSLZ7vvjNrwbSgc2xjmbAOjKQDMI=
Date: Tue, 11 Nov 2025 15:48:49 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,manish1588@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-page_isolation-clarify-fixme-around-shrink_slab-in-memory-hotplug.patch removed from -mm tree
Message-Id: <20251111234850.014D3C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_isolation: clarify FIXME around shrink_slab() in memory hotplug
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-clarify-fixme-around-shrink_slab-in-memory-hotplug.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Manish Kumar <manish1588@gmail.com>
Subject: mm/page_isolation: clarify FIXME around shrink_slab() in memory hotplug
Date: Wed, 15 Oct 2025 23:20:41 +0530

The existing FIXME comment notes that memory hotplug doesn't invoke
shrink_slab() directly.  This patch adds context explaining that this is
an intentional design choice to avoid recursion or deadlocks in the memory
reclaim path, as slab shrinking is handled by vmscan.

Link: https://lkml.kernel.org/r/20251015175041.40408-1-manish1588@gmail.com
Signed-off-by: Manish Kumar <manish1588@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-clarify-fixme-around-shrink_slab-in-memory-hotplug
+++ a/mm/page_isolation.c
@@ -176,10 +176,16 @@ static int set_migratetype_isolate(struc
 
 	/*
 	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
-	 * We just check MOVABLE pages.
+	 *
+	 * This is an intentional limitation: invoking shrink_slab() from a
+	 * hotplug path can cause reclaim recursion or deadlock if the normal
+	 * memory reclaim (vmscan) path is already active. Slab shrinking is
+	 * handled by the vmscan reclaim code under normal operation, so hotplug
+	 * avoids direct calls into shrink_slab() to prevent reentrancy issues.
+	 *
+	 * We therefore only check MOVABLE pages here.
 	 *
 	 * Pass the intersection of [start_pfn, end_pfn) and the page's pageblock
-	 * to avoid redundant checks.
 	 */
 	check_unmovable_start = max(page_to_pfn(page), start_pfn);
 	check_unmovable_end = min(pageblock_end_pfn(page_to_pfn(page)),
_

Patches currently in -mm which might be from manish1588@gmail.com are


