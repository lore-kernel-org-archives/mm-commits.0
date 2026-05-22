Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7447195811;
	Fri, 22 May 2026 00:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779409716; cv=none; b=DUrBVr+3KXyAVMQtmjQBK7jD3JWP7GRxXOKndYLT7fgQih72jhZiE9ZBz5+WFXTzd1Hnap/d9+j7lXzqKh6bkhB4IcwFcAarsR0eQIIVDTud1H214XY2LJE0SzScdId9p/4k4UEYHBhZEVAfbPoMfozdu8tXoIq9D78e0Zr7ds4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779409716; c=relaxed/simple;
	bh=xEJoFcEwS0toFyn0Y5JzJR8hSh/bsMrJVV5If7HUaWc=;
	h=Date:To:From:Subject:Message-Id; b=kMrvPqebE7SbHfc5Id2n2XJ3IpFVYNhFm/06VbmuGALahNb4cicfOEyrYqoheozul5KsCEhwszxi/EH629Sia1R01cSFRdWcXLekgdRyS1bj31WLrorPtj/iAH6pT35ixwJw5oHi8rQbbK3qlNsTAoBCGRk24E8DK3mugYgKFAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hzQOpGRQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hzQOpGRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E93F1F000E9;
	Fri, 22 May 2026 00:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779409714;
	bh=/ntJ++zzNW9gl05EL9fGgRT3Po0YIne7WeYxqnUz6/c=;
	h=Date:To:From:Subject;
	b=hzQOpGRQdSobOd5O6U5OX2AqkfsFVU77TndTUsixR3y7UGHkMK2Hw3dTR+NGdXmpd
	 HhVI7vOcSLzrwOA+f3n+HKqMV63Fx/VXnkxq0tlt+yDzt0AXyiWlISntC5icjg7KQE
	 mWCPpnV6iww2ikCDYCifTBooMLdrH//Ez74o+Al8=
Date: Thu, 21 May 2026 17:28:33 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stefan.strogin@gmail.com,stable@vger.kernel.org,rppt@kernel.org,osalvador@kernel.org,mina86@mina86.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,0x7f454c46@gmail.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma_debug-fix-invalid-accesses-for-inactive-cma-areas.patch added to mm-hotfixes-unstable branch
Message-Id: <20260522002834.5E93F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma_debug: fix invalid accesses for inactive CMA areas
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-cma_debug-fix-invalid-accesses-for-inactive-cma-areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma_debug-fix-invalid-accesses-for-inactive-cma-areas.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/cma_debug: fix invalid accesses for inactive CMA areas
Date: Wed, 20 May 2026 14:10:25 +0800

cma_activate_area() can fail after allocating range bitmaps.  Its cleanup
path frees those bitmaps, but only clears cma->count and
cma->available_count.  It leaves cma->nranges and each range's count in
place, so cma_debugfs_init() can still register debugfs files for an area
that never activated successfully.

That exposes two problems.  Reading the bitmap file can make debugfs walk
a freed range bitmap and trigger an invalid memory access.  Reading
maxchunk can also take cma->lock even though that lock is initialized only
on the successful activation path.

Fix this by creating debugfs entries only for CMA areas that reached
CMA_ACTIVATED.

c009da4258f9 introduced the invalid access to bitmap file.  2e32b947606d
introduced the invalid access to cma->lock.  This change applies to both
issues.  So I added two Fixes tags.

Link: https://lore.kernel.org/20260520061025.3971821-1-songmuchun@bytedance.com
Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Fixes: 2e32b947606d ("mm: cma: add functions to get region pages counters")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Stefan Strogin <stefan.strogin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/cma_debug.c~mm-cma_debug-fix-invalid-accesses-for-inactive-cma-areas
+++ a/mm/cma_debug.c
@@ -205,7 +205,8 @@ static int __init cma_debugfs_init(void)
 	cma_debugfs_root = debugfs_create_dir("cma", NULL);
 
 	for (i = 0; i < cma_area_count; i++)
-		cma_debugfs_add_one(&cma_areas[i], cma_debugfs_root);
+		if (test_bit(CMA_ACTIVATED, &cma_areas[i].flags))
+			cma_debugfs_add_one(&cma_areas[i], cma_debugfs_root);
 
 	return 0;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-cma_debug-fix-invalid-accesses-for-inactive-cma-areas.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

