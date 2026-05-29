Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35553672B6;
	Fri, 29 May 2026 03:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026668; cv=none; b=mlbTOUWgZr3n+GGUFw/hDT+TBXlKrdWaq35dSaL9S8PvHNzT4LQqaub958pw/cDuiNzln7mmt9JaF1zJFYV1YwhTejXVetixgMfxbZXIRI+A973dQRHQYkGaokuIYy/ZoM7MGCqFtPsB7jXDZ4iXY0TqLQS3fBm3xQeUpogAr2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026668; c=relaxed/simple;
	bh=WFa7w0Yeq0mISsDZ7eaBb7eSG3S5V+gw3fCB/nOPf2k=;
	h=Date:To:From:Subject:Message-Id; b=aDlVk0FJGfgNarkbYXSc0RIV80coJZIhF89kPlBOAdbEarQZNdnwcWf4ew0b3ytrLekfWbdACCtHJUbpbplJNHA2aXUVewTrVGdfkCNE+6lBIczqDk5LkObH+fM64PvIBojjY4iYmZFcoBkEndfDLSYmJanVlBg1t2XaCF+X+JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q499wqz3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q499wqz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AB71F00A3A;
	Fri, 29 May 2026 03:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780026667;
	bh=Hpyt1CzqKxdEk/kiQy/0sBHIEl0qvRmHUdK+dfvHQPI=;
	h=Date:To:From:Subject;
	b=q499wqz3IToLL9XRJD/kfuugitQYDsRvZfu7Ct9n98Z0JwpwxvNIM5Mq2Z10p7t1e
	 yiNvxxSDrUY7/zA8QGf5+mIC/vVpLpc5OVGFEoxTy7ZL8lJ2lvkZ6uHDslyQggND4e
	 ihM/RRlMKkl7Wxm7c8B2Zdyq0KQ1cmoKVF/25CnI=
Date: Thu, 28 May 2026 20:51:06 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stefan.strogin@gmail.com,stable@vger.kernel.org,rppt@kernel.org,osalvador@kernel.org,mina86@mina86.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,0x7f454c46@gmail.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-cma_debug-fix-invalid-accesses-for-inactive-cma-areas.patch removed from -mm tree
Message-Id: <20260529035107.67AB71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma_debug: fix invalid accesses for inactive CMA areas
has been removed from the -mm tree.  Its filename was
     mm-cma_debug-fix-invalid-accesses-for-inactive-cma-areas.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

