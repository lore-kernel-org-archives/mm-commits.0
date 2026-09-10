Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB6A33EB06
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081636; cv=none; b=s+Vg5h5eFjKIDuGnbYvzrgBVXm+ix2gAdJEI2lbmsiuyPlJ4Geq4nCEP4+bIEEYWoXycKHCRBqmFr0bZQax897YVZAdZl9sGetsavZmcCS/SoT3BNdbw0cSffhFkYNC8rTXmQIAcrE2YV5ZGx9iqdQu1AwD0rCvvHpsUlwaPoM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081636; c=relaxed/simple;
	bh=BpEFdFmrY+zhyq5XVKD0XMi9aYqtbvBnYY4ejgERUYE=;
	h=Date:To:From:Subject:Message-Id; b=CgLvXvaNgFnXr7YcyxIc2aFy7K2loOBmZKl7b2q6bD7N+JnXRZLghFDR/9w+gFS/hlrrHUzYWdz+FFgpbvzijrIoiyzCR/9iKXK00jZ1Mqfr0hO4rAiQhiK/NaVVRZGKkKTqwQOk0eiF3cUa6N7LWOtpXlxvmyk343oKtRh4xbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L3Mus1Wa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L3Mus1Wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B961F000FF;
	Thu, 10 Sep 2026 23:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081634;
	bh=csjmj8oqcpRHpZje1DFzdjzuq3SGEBhnNUiFw1dKFSg=;
	h=Date:To:From:Subject;
	b=L3Mus1WaXj41W+2ut1D8aFXF02b4HNjqHPtck0s8UA5gbmUOUPM/k5BwRhzuib6pC
	 jlCp4w1J3wC+VAvaN2cdJLg+Ul47FbytQ3Yt5dzbP6pwwzH3n8fz/nbI15gIjcJnej
	 D0qcqbJhnKkfoLegqMkcjRe1ejrELIl/66jzvcYA=
Date: Thu, 10 Sep 2026 16:07:14 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch removed from -mm tree
Message-Id: <20260910230714.B5B961F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch

This patch was dropped because an updated version will be issued

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


