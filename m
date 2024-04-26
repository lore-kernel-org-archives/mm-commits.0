Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA667E785
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104033; cv=none; b=PpRNo+0xhW4Dg9N95DRKEysgrM5NGH+m7Qf4be+PfqYhUo8AkXmf5MdJlVolqpOXoMSCPa5IG59tbL1gvHOFzLL4TCbKmnVsqhoX6Cg12eokCGMkz+qIhCsXy7Z/F0B1O5QIpZXmbX12kkoIYKze1i9gqDHTXx6IaVUjHG5Us1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104033; c=relaxed/simple;
	bh=eIJ0rfGefmrtvQNGDodxHbOCl2f7H5j+GvTVAIUbZs4=;
	h=Date:To:From:Subject:Message-Id; b=cGMfa11Xvb36RvD9EmBIE8QaluEAojNr9CJ3wG1A0rBBK9t/SUiKyFiDKWcu8BoA/HddjDC9zrMKBo7bI0i5C+b3VDTrFK3H3cweo4r20o6GI6EO1wrBXxr0/3IQVImNdsclOgvg5Tyx0qnEGkucOj0T/XSIYu5UWmuqvRwGbKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qZ0q/vtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qZ0q/vtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643E2C2BD11;
	Fri, 26 Apr 2024 04:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104033;
	bh=eIJ0rfGefmrtvQNGDodxHbOCl2f7H5j+GvTVAIUbZs4=;
	h=Date:To:From:Subject:From;
	b=qZ0q/vtAQSI3iXT4BF993dT0JXNv0gR9lei21bSNFpkWXR8exYojubu480pP3nEwe
	 BiWXuocCsTButLoyI/FawgWygct+4NjARS9I7tQcYHLpNABdcpZjlrfFOoxdjh18sN
	 8b+UDV4TnVcQ0vh4zPM4GFOXxSrd5cDDfw2BZ2sU=
Date: Thu, 25 Apr 2024 21:00:32 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch removed from -mm tree
Message-Id: <20240426040033.643E2C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc.c: remove unneeded codes in !NUMA version of build_zonelists()
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/page_alloc.c: remove unneeded codes in !NUMA version of build_zonelists()
Date: Tue, 26 Mar 2024 14:11:30 +0800

When CONFIG_NUMA=n, MAX_NUMNODES is always 1 because Kconfig item
NODES_SHIFT depends on NUMA.  So in !NUMA version of build_zonelists(), no
need to bother with the two for loop because code execution won't enter
them ever.

Here, remove those unneeded codes in !NUMA version of build_zonelists().

[bhe@redhat.com: remove unused locals]
  Link: https://lkml.kernel.org/r/ZgQL1WOf9K88nLpQ@MiWiFi-R3L-srv
Link: https://lkml.kernel.org/r/20240326061134.1055295-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 ------------------------
 1 file changed, 24 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists
+++ a/mm/page_alloc.c
@@ -5280,37 +5280,13 @@ static void setup_min_slab_ratio(void);
 
 static void build_zonelists(pg_data_t *pgdat)
 {
-	int node, local_node;
 	struct zoneref *zonerefs;
 	int nr_zones;
 
-	local_node = pgdat->node_id;
-
 	zonerefs = pgdat->node_zonelists[ZONELIST_FALLBACK]._zonerefs;
 	nr_zones = build_zonerefs_node(pgdat, zonerefs);
 	zonerefs += nr_zones;
 
-	/*
-	 * Now we build the zonelist so that it contains the zones
-	 * of all the other nodes.
-	 * We don't want to pressure a particular node, so when
-	 * building the zones for node N, we make sure that the
-	 * zones coming right after the local ones are those from
-	 * node N+1 (modulo N)
-	 */
-	for (node = local_node + 1; node < MAX_NUMNODES; node++) {
-		if (!node_online(node))
-			continue;
-		nr_zones = build_zonerefs_node(NODE_DATA(node), zonerefs);
-		zonerefs += nr_zones;
-	}
-	for (node = 0; node < local_node; node++) {
-		if (!node_online(node))
-			continue;
-		nr_zones = build_zonerefs_node(NODE_DATA(node), zonerefs);
-		zonerefs += nr_zones;
-	}
-
 	zonerefs->zone = NULL;
 	zonerefs->zone_idx = 0;
 }
_

Patches currently in -mm which might be from bhe@redhat.com are

documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

