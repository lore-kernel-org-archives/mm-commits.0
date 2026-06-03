Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB443932FA
	for <mm-commits@vger.kernel.org>; Wed,  3 Jun 2026 23:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780529184; cv=none; b=bhpGUQG7HTS2SFVRu1SuhS0j+nOk6+NbCvQnXbzgT3w7H7lpObyusJHO3Avk2Gq37h2nMCxHj70yhKmq98TPhEXWSuc18YuiHhrs4o6BpwRUp78P61+ZgTuf05mdtwq0mqUcXGPP6ZlXAd8A7QzivtiM498E0AdsOZTyGMlWC4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780529184; c=relaxed/simple;
	bh=AokCZUPnucU/Ii3/5XIu6GVPxnB4+GY7tXZe31HNaWI=;
	h=Date:To:From:Subject:Message-Id; b=h8T2yQwx0HGGyX2BnCYlYCyJHnpHxTd30vze1WPd5s1eOeBuV9jDyLT3vNCeOz5PiwR+XKel3nmVbw/FhhDIxKnIsBgAccyRbiExkZNMiLGfwEKTHdbxwaTPPnzD8L2Dk3fYlZcKS85xK/fdSqwU/be4YIXiE4o/aVRLMkjgl+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ShawkhHr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ShawkhHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD601F00898;
	Wed,  3 Jun 2026 23:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780529183;
	bh=7IeZzmxJ3F+nWheH3j3kpn8EDlOBnP7Olo5x9frOAJA=;
	h=Date:To:From:Subject;
	b=ShawkhHrJ6fzhwrMIhE2HUSIEDAcwiKyeaw9my1BAvLibx8r1Bwr+CMcCCXKlhRZ1
	 j14YTnNLQTZY0Gts49I+NoKqKKOMUfIhlFSmhc+FfaW2X6AQ/MM5gE0uN8RS5dAUJL
	 wpLhS1slO6xu8sy8/GQlSA4N8fZcHME8+m18O9Ug=
Date: Wed, 03 Jun 2026 16:26:22 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,songmuchun@bytedance.com,rppt@kernel.org,muchun.song@linux.dev,minchan@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jhubbard@nvidia.com,gregkh@linuxfoundation.org,digetx@gmail.com,david@kernel.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-cma_sysfs-skip-inactive-cma-areas-in-sysfs.patch removed from -mm tree
Message-Id: <20260603232622.DDD601F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma_sysfs: skip inactive CMA areas in sysfs
has been removed from the -mm tree.  Its filename was
     mm-cma_sysfs-skip-inactive-cma-areas-in-sysfs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/cma_sysfs: skip inactive CMA areas in sysfs
Date: Fri, 22 May 2026 21:14:34 +0800

cma_activate_area() can fail after a CMA area has already been added to
cma_areas[].  In that case the area is left in the global array, but it
does not reach the point where CMA_ACTIVATED is set.

cma_sysfs_init() currently walks all cma_area_count entries and creates
sysfs files for every area, including ones that failed activation.  These
areas are not usable CMA areas and should not be exposed to userspace as
valid CMA regions.

If such an inactive area is exposed, userspace sees a CMA directory whose
read-only accounting files report zeros.  total_pages and available_pages
report zero because the failed activation path clears cma->count and
cma->available_count, while the allocation and release counters also stay
at zero because the area cannot service CMA allocations.  This makes the
failed area look like a valid but empty CMA region and can mislead tests,
monitoring, and diagnostics.

Skip CMA areas that did not reach CMA_ACTIVATED when creating the sysfs
objects.  Since inactive entries can now be skipped, make the error unwind
tolerate entries that never had cma_kobj initialized.

Link: https://lore.kernel.org/20260524140420.61864-1-kaitao.cheng@linux.dev
Link: https://lore.kernel.org/20260522131434.78532-1-kaitao.cheng@linux.dev
Fixes: 43ca106fa8ec ("mm: cma: support sysfs")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Reported-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Muchun Song <songmuchun@bytedance.com>
Closes: https://lore.kernel.org/linux-mm/55481a8b-dcfc-4bef-ba59-aa0b43dca88b@kernel.org/
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dmitry Osipenko <digetx@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_sysfs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/cma_sysfs.c~mm-cma_sysfs-skip-inactive-cma-areas-in-sysfs
+++ a/mm/cma_sysfs.c
@@ -117,13 +117,16 @@ static int __init cma_sysfs_init(void)
 		return -ENOMEM;
 
 	for (i = 0; i < cma_area_count; i++) {
+		cma = &cma_areas[i];
+		if (!test_bit(CMA_ACTIVATED, &cma->flags))
+			continue;
+
 		cma_kobj = kzalloc_obj(*cma_kobj);
 		if (!cma_kobj) {
 			err = -ENOMEM;
 			goto out;
 		}
 
-		cma = &cma_areas[i];
 		cma->cma_kobj = cma_kobj;
 		cma_kobj->cma = cma;
 		err = kobject_init_and_add(&cma_kobj->kobj, &cma_ktype,
@@ -138,7 +141,8 @@ static int __init cma_sysfs_init(void)
 out:
 	while (--i >= 0) {
 		cma = &cma_areas[i];
-		kobject_put(&cma->cma_kobj->kobj);
+		if (cma->cma_kobj)
+			kobject_put(&cma->cma_kobj->kobj);
 	}
 	kobject_put(cma_kobj_root);
 
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-page_isolation-avoid-unsafe-folio-reads-while-scanning-compound-pages.patch

