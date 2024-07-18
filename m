Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B5AEEAA;
	Thu, 18 Jul 2024 04:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721275765; cv=none; b=oWef3AS42095KsNKASXeuYfLpgx2yv+LFTIuoST4+v338pDQbR205jDpvEFk2UpDCK9iDenFRYdgfwBhBQPBlGD1vUz2gllHc49AKoOGvzpxDDj4J2L10ExMxJpKf2iTmJysYCwOU3S8JkOcZMMeqQguCS/RgxKOhKHSmJQWF7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721275765; c=relaxed/simple;
	bh=Z3mSEPzA6oPOyt/clEoJzunfTGq0erof77HuJzqiCXs=;
	h=Date:To:From:Subject:Message-Id; b=nHY+zjUyOHeKQ/lyJcdL6lfMNwJ70CVgN0jdkejot7xfdWg7UqTOQYBrbP3Bb6/NEXtapygU+zDNGLHwARmTaMsGilBRLiVlHB+E00UIopJ2lgv/taz6bLK7VOIGbT9LNmrWUasfceZ9hsKZrb/LVMhBDrgqDXDy83Xuszr7Q9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=retV6P1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="retV6P1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3850DC116B1;
	Thu, 18 Jul 2024 04:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721275764;
	bh=Z3mSEPzA6oPOyt/clEoJzunfTGq0erof77HuJzqiCXs=;
	h=Date:To:From:Subject:From;
	b=retV6P1Erf+cmxbeRgwLPkoVpwdvfLAzBzuuWs9il/Frvv09LKY2VJ7oN1a5jJK2U
	 aeMqLb+3+fx0U+QPsOcmPs2UVvpG0ECsA9+MaOku4hu2L3svHyeTc8EYJad5NQ/CEr
	 AszFefFPgkMme2Rma6UQUECcILsCkj998C200NJM=
Date: Wed, 17 Jul 2024 21:09:23 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,stable@vger.kernel.org,rientjes@google.com,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,hannes@cmpxchg.org,dave.hansen@intel.com,ak@linux.intel.com,tvrtko.ursulin@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-numa_balancing-teach-mpol_to_str-about-the-balancing-mode.patch removed from -mm tree
Message-Id: <20240718040924.3850DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/numa_balancing: teach mpol_to_str about the balancing mode
has been removed from the -mm tree.  Its filename was
     mm-numa_balancing-teach-mpol_to_str-about-the-balancing-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Subject: mm/numa_balancing: teach mpol_to_str about the balancing mode
Date: Mon, 8 Jul 2024 08:56:32 +0100

Since balancing mode was added in bda420b98505 ("numa balancing: migrate
on fault among multiple bound nodes"), it was possible to set this mode
but it wouldn't be shown in /proc/<pid>/numa_maps since there was no
support for it in the mpol_to_str() helper.

Furthermore, because the balancing mode sets the MPOL_F_MORON flag, it
would be displayed as 'default' due a workaround introduced a few years
earlier in 8790c71a18e5 ("mm/mempolicy.c: fix mempolicy printing in
numa_maps").

To tidy this up we implement two changes:

Replace the MPOL_F_MORON check by pointer comparison against the
preferred_node_policy array.  By doing this we generalise the current
special casing and replace the incorrect 'default' with the correct 'bind'
for the mode.

Secondly, we add a string representation and corresponding handling for
the MPOL_F_NUMA_BALANCING flag.

With the two changes together we start showing the balancing flag when it
is set and therefore complete the fix.

Representation format chosen is to separate multiple flags with vertical
bars, following what existed long time ago in kernel 2.6.25.  But as
between then and now there wasn't a way to display multiple flags, this
patch does not change the format in practice.

Some /proc/<pid>/numa_maps output examples:

 555559580000 bind=balancing:0-1,3 file=...
 555585800000 bind=balancing|static:0,2 file=...
 555635240000 prefer=relative:0 file=

Link: https://lkml.kernel.org/r/20240708075632.95857-1-tursulin@igalia.com
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
References: 8790c71a18e5 ("mm/mempolicy.c: fix mempolicy printing in numa_maps")
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
Cc: <stable@vger.kernel.org>	[5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/mm/mempolicy.c~mm-numa_balancing-teach-mpol_to_str-about-the-balancing-mode
+++ a/mm/mempolicy.c
@@ -3297,8 +3297,9 @@ out:
  * @pol:  pointer to mempolicy to be formatted
  *
  * Convert @pol into a string.  If @buffer is too short, truncate the string.
- * Recommend a @maxlen of at least 32 for the longest mode, "interleave", the
- * longest flag, "relative", and to display at least a few node ids.
+ * Recommend a @maxlen of at least 51 for the longest mode, "weighted
+ * interleave", plus the longest flag flags, "relative|balancing", and to
+ * display at least a few node ids.
  */
 void mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 {
@@ -3307,7 +3308,10 @@ void mpol_to_str(char *buffer, int maxle
 	unsigned short mode = MPOL_DEFAULT;
 	unsigned short flags = 0;
 
-	if (pol && pol != &default_policy && !(pol->flags & MPOL_F_MORON)) {
+	if (pol &&
+	    pol != &default_policy &&
+	    !(pol >= &preferred_node_policy[0] &&
+	      pol <= &preferred_node_policy[ARRAY_SIZE(preferred_node_policy) - 1])) {
 		mode = pol->mode;
 		flags = pol->flags;
 	}
@@ -3335,12 +3339,18 @@ void mpol_to_str(char *buffer, int maxle
 		p += snprintf(p, buffer + maxlen - p, "=");
 
 		/*
-		 * Currently, the only defined flags are mutually exclusive
+		 * Static and relative are mutually exclusive.
 		 */
 		if (flags & MPOL_F_STATIC_NODES)
 			p += snprintf(p, buffer + maxlen - p, "static");
 		else if (flags & MPOL_F_RELATIVE_NODES)
 			p += snprintf(p, buffer + maxlen - p, "relative");
+
+		if (flags & MPOL_F_NUMA_BALANCING) {
+			if (!is_power_of_2(flags & MPOL_MODE_FLAGS))
+				p += snprintf(p, buffer + maxlen - p, "|");
+			p += snprintf(p, buffer + maxlen - p, "balancing");
+		}
 	}
 
 	if (!nodes_empty(nodes))
_

Patches currently in -mm which might be from tvrtko.ursulin@igalia.com are


