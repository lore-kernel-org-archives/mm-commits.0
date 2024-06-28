Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C8F1E4A4
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 19:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719602880; cv=none; b=IGOl24BTvlEvN/8G6D9Okx8/+K8eqQ/XS13sDI6uYN0oNB0GFvIXYBIM3KpS3PbRTQqkw+kvXD2VNHDjAPF7/E9EZD+NMkezRQVja+CDa3RMxrjdt3Ne+X23hevp/R89IDpGx0/kFsYqgFma21htoaXiLzcSrdXnPQEW8xxqtgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719602880; c=relaxed/simple;
	bh=amKrIzDXYyuEa35l9ZA/b+de5E9+YYKfm3DY6GkKCwQ=;
	h=Date:To:From:Subject:Message-Id; b=kzZb6tmA4EyCUHA8tVvUyVfhmOQLpy8KbZ3ZrM7BdPAYzwQC7CcakpIyBMbLMkt3EO3PYJ9waeN2nrHekzDzeDXiV7QjD3wttgzfKCURikncj89zkcfoSRzAmwKlcJA99kEi74/dpqwb8Q1ApategG89UFEjBZMbaTZOYNBfy7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zMvEuCqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zMvEuCqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F18C116B1;
	Fri, 28 Jun 2024 19:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719602879;
	bh=amKrIzDXYyuEa35l9ZA/b+de5E9+YYKfm3DY6GkKCwQ=;
	h=Date:To:From:Subject:From;
	b=zMvEuCqpIa3rjDmkG9IrK9hmjV1P3UNEKMZy/UZU4dGoTFJCJvqYAqtNnKS3DlOj7
	 ihFo8/caxTv77La9HO27XaFCuUjHM26byvTTBjX/f2IGWHA5KGOTqN8CBi9t0/6w/g
	 ZXyCd/9uQt3S2PQzyPrl+LX5dcnB4MrOgf1hM9R0=
Date: Fri, 28 Jun 2024 12:27:59 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,rientjes@google.com,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,hannes@cmpxchg.org,dave.hansen@intel.com,ak@linux.intel.com,tvrtko.ursulin@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-numa_balancing-teach-mpol_to_str-about-the-balancing-mode.patch removed from -mm tree
Message-Id: <20240628192759.A2F18C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/numa_balancing: teach mpol_to_str about the balancing mode
has been removed from the -mm tree.  Its filename was
     mm-numa_balancing-teach-mpol_to_str-about-the-balancing-mode.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Subject: mm/numa_balancing: teach mpol_to_str about the balancing mode
Date: Tue, 25 Jun 2024 14:26:05 +0100

If a task has had MPOL_F_NUMA_BALANCING set it is useful to show that in
procfs.  Teach the mpol_to_str() helper about its existence and while at
it update the comment to account for "weighted interleave" when suggesting
a recommended buffer size.

Link: https://lkml.kernel.org/r/20240625132605.38428-1-tursulin@igalia.com
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-numa_balancing-teach-mpol_to_str-about-the-balancing-mode
+++ a/mm/mempolicy.c
@@ -3297,8 +3297,9 @@ out:
  * @pol:  pointer to mempolicy to be formatted
  *
  * Convert @pol into a string.  If @buffer is too short, truncate the string.
- * Recommend a @maxlen of at least 32 for the longest mode, "interleave", the
- * longest flag, "relative", and to display at least a few node ids.
+ * Recommend a @maxlen of at least 42 for the longest mode, "weighted
+ * interleave", the longest flag, "balancing", and to display at least a few
+ * node ids.
  */
 void mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 {
@@ -3335,12 +3336,15 @@ void mpol_to_str(char *buffer, int maxle
 		p += snprintf(p, buffer + maxlen - p, "=");
 
 		/*
-		 * Currently, the only defined flags are mutually exclusive
+		 * The below two flags are mutually exclusive:
 		 */
 		if (flags & MPOL_F_STATIC_NODES)
 			p += snprintf(p, buffer + maxlen - p, "static");
 		else if (flags & MPOL_F_RELATIVE_NODES)
 			p += snprintf(p, buffer + maxlen - p, "relative");
+
+		if (flags & MPOL_F_NUMA_BALANCING)
+			p += snprintf(p, buffer + maxlen - p, "balancing");
 	}
 
 	if (!nodes_empty(nodes))
_

Patches currently in -mm which might be from tvrtko.ursulin@igalia.com are


