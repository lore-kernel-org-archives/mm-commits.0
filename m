Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C408E7F7C1
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104036; cv=none; b=M99FKShs68KZJoEEhP3qGimylWcAYFucV5Axf9fOMmFv0kwMY5cY+axbfhyiW2nePe9dvHSZwy/hr+SVo3Rp4zHVhL1O5BFjhnF0BIu/R7qDFtVAd3nlYhjcVq3b3mxUKjIn4wujTEUKw4iH1xRKyICVxM+YYQ34VTRba6wIm6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104036; c=relaxed/simple;
	bh=sxku4LOkvpqGPzV2gly8yI6VZCHCP/Tf6Xsj1PToh0Q=;
	h=Date:To:From:Subject:Message-Id; b=Hyo3Lb5pMc+OmBMqu7QJTMhUO6Yu2DEPqKdPDfRVPCAhZbu29YB+DwD+slUeVoWzEdtQzfpvgE0geK+jRoCuFFPO5zIfwQm5bTotHYJOOixrDY7XI1g4VgVtTKhzurHK9A/PJMcUBd/yt4U3ra3o689eQ2B9XBKZuHaSoqLlGps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F5bHr3Au; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F5bHr3Au"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9574AC113CD;
	Fri, 26 Apr 2024 04:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104036;
	bh=sxku4LOkvpqGPzV2gly8yI6VZCHCP/Tf6Xsj1PToh0Q=;
	h=Date:To:From:Subject:From;
	b=F5bHr3AuYFX5pFkqjh+dEYwtg5FUeZQEPsghb0qFAag5coHPk0Bu+eZIV1evHRNOV
	 ZO5QcjLB0TruJgrRamk0kU4PU7ICy8PfXf7+KaHHWTALH4eD/V92ZY9hT3BkJTobzj
	 iyGdX1zPAiUxm0b5IuwbkV4G7L6MWxt4tXGzKTk8=
Date: Thu, 25 Apr 2024 21:00:36 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch removed from -mm tree
Message-Id: <20240426040036.9574AC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc.c: don't show protection in zone's ->lowmem_reserve[] for empty zone
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/page_alloc.c: don't show protection in zone's ->lowmem_reserve[] for empty zone
Date: Tue, 26 Mar 2024 14:11:32 +0800

On one node, for lower zone's ->lowmem_reserve[], it will show how much
memory is reserved in this lower zone to avoid excessive page allocation
from the relevant higher zone's fallback allocation.

However, currently lower zone's lowmem_reserve[] element will be filled
even though the relevant higher zone is empty.  That doesnt' make sense
and can cause confusion.

E.g on node 0 of one system as below, it has zone
DMA/DMA32/NORMAL/MOVABLE/DEVICE, among them zone MOVABLE/DEVICE are the
highest and both are empty.  In zone DMA/DMA32's protection array, we can
see that it has value for zone MOVABLE and DEVICE.

Node 0, zone      DMA
  ......
  pages free     2816
        boost    0
        min      7
        low      10
        high     13
        spanned  4095
        present  3998
        managed  3840
        cma      0
        protection: (0, 1582, 23716, 23716, 23716)
   ......
Node 0, zone    DMA32
  pages free     403269
        boost    0
        min      753
        low      1158
        high     1563
        spanned  1044480
        present  487039
        managed  405070
        cma      0
        protection: (0, 0, 22134, 22134, 22134)
   ......
Node 0, zone   Normal
  pages free     5423879
        boost    0
        min      10539
        low      16205
        high     21871
        spanned  5767168
        present  5767168
        managed  5666438
        cma      0
        protection: (0, 0, 0, 0, 0)
   ......
Node 0, zone  Movable
  pages free     0
        boost    0
        min      32
        low      32
        high     32
        spanned  0
        present  0
        managed  0
        cma      0
        protection: (0, 0, 0, 0, 0)
Node 0, zone   Device
  pages free     0
        boost    0
        min      0
        low      0
        high     0
        spanned  0
        present  0
        managed  0
        cma      0
        protection: (0, 0, 0, 0, 0)

Here, clear out the element value in lower zone's ->lowmem_reserve[] if the
relevant higher zone is empty.

And also replace space with tab in _deferred_grow_zone()

Link: https://lkml.kernel.org/r/20240326061134.1055295-7-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone
+++ a/mm/page_alloc.c
@@ -315,7 +315,7 @@ static inline bool deferred_pages_enable
 static bool __ref
 _deferred_grow_zone(struct zone *zone, unsigned int order)
 {
-       return deferred_grow_zone(zone, order);
+	return deferred_grow_zone(zone, order);
 }
 #else
 static inline bool deferred_pages_enabled(void)
@@ -5903,10 +5903,11 @@ static void setup_per_zone_lowmem_reserv
 
 			for (j = i + 1; j < MAX_NR_ZONES; j++) {
 				struct zone *upper_zone = &pgdat->node_zones[j];
+				bool empty = !zone_managed_pages(upper_zone);
 
 				managed_pages += zone_managed_pages(upper_zone);
 
-				if (clear)
+				if (clear || empty)
 					zone->lowmem_reserve[j] = 0;
 				else
 					zone->lowmem_reserve[j] = managed_pages / ratio;
_

Patches currently in -mm which might be from bhe@redhat.com are

documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

