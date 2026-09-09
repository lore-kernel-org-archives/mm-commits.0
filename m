Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6E048EC85
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 22:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788993473; cv=none; b=sZvH2MyMdjsIds7i1uw5nc9dcLa/FXL25ol+KfyaK/apiRlupMCy1Y5Xr2C2I5V7iCWkfFCXdGEYcLb11HbMkMF/+ugttmlWbFbO4xhwN2rEUoFfKpCNjQMAOHJUJFAooRipX+I+i1m8QzJcFodysGObJRw4VXYPns/i5hxfbRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788993473; c=relaxed/simple;
	bh=cbutHBizFy/RPbWRIMfqPeABeahi43AOiCkGZQzoSA8=;
	h=Date:To:From:Subject:Message-Id; b=UcYpM6CwW6nq26MwuBaQtKUsP63ErzG/FjwqL40cemqWTescWQJuZGIMiA06lEbZeYY0ufBK8w/8jQL78sS/B2F82labamQ9dYdQHdoi+NDCWQUlznkvEqwICTdfIix9O3drxn11O0AlJeQS2stqkgm0revm8QT0NoK+tT5UxLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R1lV0tbq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R1lV0tbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A213C1F00893;
	Wed,  9 Sep 2026 22:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788993447;
	bh=Wm+4X8UAyIdV5uzVljpQdSmNH3nvwXdCPGxyKDBsZyE=;
	h=Date:To:From:Subject;
	b=R1lV0tbqyjxnVJjkKE2vdi77LJsN4rPyFasvP53vBV5VButePJYYZhJYfaR1jDxFK
	 2K9W8XTHz1avz88CE8qFPNRfwL7qk719eV0ttLVxuAZeyGZ4tOiGHcKku2sgnMGqhG
	 /3DI13SdD3Km9Y6aId/LfJUFE185bLZSkMJJzOQ8=
Date: Wed, 09 Sep 2026 15:37:27 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch added to mm-new branch
Message-Id: <20260909223727.A213C1F00893@smtp.kernel.org>
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
Date: Wed Sep  9 03:33:07 PM PDT 2026

hack around build error

https://lore.kernel.org/202609100517.0DrzxrW4-lkp@intel.com
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/mmzone.h~mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
+++ a/include/linux/mmzone.h
@@ -1687,16 +1687,20 @@ static inline bool zone_is_zone_device(c
 	return zone_idx(zone) == ZONE_DEVICE;
 }
 
+#ifdef CONFIG_NUMA
 static inline struct zone *device_zone(int nid)
 {
 	return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
 }
+#endif
 #else
 static inline bool zone_is_zone_device(const struct zone *zone)
 {
 	return false;
 }
+#endif
 
+#if !defined(CONFIG_ZONE_DEVICE) && !defined(CONFIG_NUMA)
 static inline struct zone *device_zone(int nid)
 {
 	return NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

