Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2721757FC
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 17:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720287302; cv=none; b=Nuzdaa9TLranUDRbVmFLs1sgzQR3vt5/8ZxYR1YCoaJpyPZqhOrlTw4LeIJ1adNCSl55a1UHaIwolSPF7HACiszJ/M86cm1xhbdmn9k/MI4e6c8ZTu2hamVhQR/D70dFJNhLDtFAKFLrsGvzAsseXE2uCR9P6HrrjFc4xmdkq2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720287302; c=relaxed/simple;
	bh=W4Wa1OShlvLCkDTeiqY+/oREFrDNlg5WODn3NM4qGwo=;
	h=Date:To:From:Subject:Message-Id; b=GtxHbl7vQqEyrcrN1RwUJJLQs1JfhX3Vtbi8+3p7Iz4g0QQmGb4yw7bAuajStVlcGfVNr4lcLdn4OdnYj4hEbwlUXJ5zc+twofcX4pC2mTv1K5NZOwv9xIwXrtzcvJJpiO6/HhcT/B0VEp7OLaVjI2YRj2Ha1tm7byA67lNgEXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=egXxaAsz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="egXxaAsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C335C2BD10;
	Sat,  6 Jul 2024 17:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720287301;
	bh=W4Wa1OShlvLCkDTeiqY+/oREFrDNlg5WODn3NM4qGwo=;
	h=Date:To:From:Subject:From;
	b=egXxaAszvFyJ+uv9OvaDTWUQJiluUex9V7cRPNBqu1P8TE9esBO114s+hKNHudit7
	 2FefTbCPYxOi/Qx+qxmVa4jAL7BCmj/YaMNQekMoinVXRUg9LdUh2VUUWGcb0EmGW6
	 5h8+fa7K43VFWR1Fd5FnlJ/974uSi2CSXJT4TuWc=
Date: Sat, 06 Jul 2024 10:35:00 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-zonelist_zone-to-get-zone.patch added to mm-unstable branch
Message-Id: <20240706173501.5C335C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use zonelist_zone() to get zone
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-zonelist_zone-to-get-zone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-zonelist_zone-to-get-zone.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm: use zonelist_zone() to get zone
Date: Sat, 6 Jul 2024 01:50:44 +0000

Instead of accessing zoneref->zone directly, use zonelist_zone() like
other places for consistency.

No functional change.

Link: https://lkml.kernel.org/r/20240706015044.27789-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-use-zonelist_zone-to-get-zone
+++ a/include/linux/mmzone.h
@@ -1690,7 +1690,7 @@ static inline struct zoneref *first_zone
 			zone = zonelist_zone(z))
 
 #define for_next_zone_zonelist_nodemask(zone, z, highidx, nodemask) \
-	for (zone = z->zone;	\
+	for (zone = zonelist_zone(z);	\
 		zone;							\
 		z = next_zones_zonelist(++z, highidx, nodemask),	\
 			zone = zonelist_zone(z))
@@ -1726,7 +1726,7 @@ static inline bool movable_only_nodes(no
 	nid = first_node(*nodes);
 	zonelist = &NODE_DATA(nid)->node_zonelists[ZONELIST_FALLBACK];
 	z = first_zones_zonelist(zonelist, ZONE_NORMAL,	nodes);
-	return (!z->zone) ? true : false;
+	return (!zonelist_zone(z)) ? true : false;
 }
 
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch
kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch
mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch
mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch
mm-use-zonelist_zone-to-get-zone.patch

