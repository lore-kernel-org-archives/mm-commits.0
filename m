Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FE2249F9
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 21:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719524264; cv=none; b=SKM+ZVp2YAx/iXM6kiKgvx7xc5i/62Djdm8o98T29HMzo923T7AQClWMr8hsEhGJTgyhj7/tKWco3sPnXqauh8O3Rv7m2tfd4SHSLEIHzgE/eNKRVcUG6T2v5YtSwjFtkJxACJ5jrH37QcOEjL1xTiLSzb5c26NXcKbrorUFLy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719524264; c=relaxed/simple;
	bh=j3UGaFidfgWakplbIj9sjnBXtm0q3YnHaL5UsKcwdCQ=;
	h=Date:To:From:Subject:Message-Id; b=ozuJZTt2qgcSw/6celelFFOuWqua/Xts1vYu8W+xPruGxciK5jBF7fNsLcvfxwS6LmHzZKcNSHhwallljvINbLD4tfRbstK+rfCXfSCTSMhOvB53jLpeMp1S2WKc8zXznxXyCoHQ21L1oFcgryyPUixtZLFNTEbvnDM6HYr5ego=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tqrrrhIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tqrrrhIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097AFC2BBFC;
	Thu, 27 Jun 2024 21:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719524264;
	bh=j3UGaFidfgWakplbIj9sjnBXtm0q3YnHaL5UsKcwdCQ=;
	h=Date:To:From:Subject:From;
	b=tqrrrhICdsk6iP8kWH5voBRhK6OHGOo7hKkGdb/oG/CRpmJwN35JssT2MVoOb9+At
	 +l/3x/scoB9mdDHhlABLR3I/ftYm6COFARuQ8bZs5PAW7IpY6I+pbMpvRni7dDwc6P
	 nxcs35xa+NxiB03i1tvJwQg3N6cditkw9TIc1Ss4=
Date: Thu, 27 Jun 2024 14:37:43 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,rientjes@google.com,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,hannes@cmpxchg.org,dave.hansen@intel.com,ak@linux.intel.com,tvrtko.ursulin@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-numa_balancing-teach-mpol_to_str-about-the-balancing-mode.patch added to mm-unstable branch
Message-Id: <20240627213744.097AFC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/numa_balancing: teach mpol_to_str about the balancing mode
has been added to the -mm mm-unstable branch.  Its filename is
     mm-numa_balancing-teach-mpol_to_str-about-the-balancing-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-numa_balancing-teach-mpol_to_str-about-the-balancing-mode.patch

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

mm-numa_balancing-teach-mpol_to_str-about-the-balancing-mode.patch

