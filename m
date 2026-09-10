Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5E93AEF51
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 05:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789018548; cv=none; b=Nx6ULwV8UuJqxG/tvNXjZRn9Ey0M8BpUHXzxbGEBeNdR9ftRVueBHCdArezTi4yJDx0VghFTbGa2Ww7wE6US3FyJXBTDM3rBYT5PK7du1WRpWgdP00hQHRl9oukc++FHcI7+N3zV37LE3JGntMlm6ZiVxuDjJ01wkutjUH4gMLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789018548; c=relaxed/simple;
	bh=Z8P2LLcZvJKZhV/FbycCK0x3NqFb2KyynLpF4uJ+ZuA=;
	h=Date:To:From:Subject:Message-Id; b=p5ZpqRUv1t5umRRvSWUh7ey72Vlhxqv3UK7BCODxcle/ZrSnJRYZlO+eLMWpDa9DBxdqNbzJpy98zTt/Q0DukILXP24YJmHXSjlaWNcysy9SudYh//wgYjIF9O3pNIwfXadtV0Bxcn0PGd/XponUNIdhOczw0unVEaz4Sg23bkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gaONPoeP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gaONPoeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5344C1F000FF;
	Thu, 10 Sep 2026 05:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789018544;
	bh=z+etO2+ACib+adOFMmmmTH1z2doLY9QZNXg296bxvLE=;
	h=Date:To:From:Subject;
	b=gaONPoePdP7v8DUt6Spa6W14LJlSS1YRBw/CHhI3F+f+3de3S1PEbviggyfoaFYqi
	 o3Ux+JRbCmTZbamSTDYz4YitWdgB/u0HOQFuiWNe5Y4qJxpIaTg48BLzT/2x0LBG8u
	 2Ng+jHMOtAtdhUB46qL/+ZcJJRESekMs/MITO/gU=
Date: Wed, 09 Sep 2026 22:35:43 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch added to mm-new branch
Message-Id: <20260910053544.5344C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch

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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
Date: Thu, 10 Sep 2026 10:43:41 +0800

device_zone() uses NODE_DATA() before it is defined when CONFIG_NUMA is
disabled.  This causes non-NUMA builds with CONFIG_ZONE_DEVICE=y to fail.

Move device_zone() after the definition of NODE_DATA() so it is available
in non-NUMA builds.

Link: https://lore.kernel.org/AA5FC896-AC1B-4112-BA14-E1F8865358BF@linux.dev
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
+++ a/include/linux/mmzone.h
@@ -1686,21 +1686,11 @@ static inline bool zone_is_zone_device(c
 {
 	return zone_idx(zone) == ZONE_DEVICE;
 }
-
-static inline struct zone *device_zone(int nid)
-{
-	return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
-}
 #else
 static inline bool zone_is_zone_device(const struct zone *zone)
 {
 	return false;
 }
-
-static inline struct zone *device_zone(int nid)
-{
-	return NULL;
-}
 #endif
 
 /*
@@ -2159,11 +2149,21 @@ static inline int online_device_section(
 
 	return section && ((section->section_mem_map & flags) == flags);
 }
+
+static inline struct zone *device_zone(int nid)
+{
+	return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
+}
 #else
 static inline int online_device_section(const struct mem_section *section)
 {
 	return 0;
 }
+
+static inline struct zone *device_zone(int nid)
+{
+	return NULL;
+}
 #endif
 
 static inline int online_section_nr(unsigned long nr)
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch

