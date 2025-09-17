Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EABA1B3923
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 20:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758142001; cv=none; b=jYwp8wuaQ1B9ujDC9rikvrqRx1yCouF3dDjNZtYVP47+ZmhTxEf3oMwy8d3fd4ViM+x3abAYwdOI3Q6hJutf74pYVHwkzff2FAOeiKqsQzWvGKU9zVdJpsTnd2b7XhzKWXBj6wxJ/lYVRBDHdkBzYQdJJRLmW5ueBstE28S3dw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758142001; c=relaxed/simple;
	bh=7lg7Ui5YqpgSc8Fe6nNx38G4jbCoVp96315Rr9KBlHQ=;
	h=Date:To:From:Subject:Message-Id; b=mTHWRuoA1gvUzH+ji8bzd8F0iLTDAiTKQOHVUFIzr2vZibAWbE1gk88tgXdo2xf8gVbU5vEvYz+32kZ2Yhpd9UI3GjqCmv/kE+EbKBX8JVyEgJO9oKADXE2X+rshqNOUnHJdl7O3tS2kg++DcZveiiH45UnH3V9+f+7NnKth6Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w0+eRjxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w0+eRjxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82349C4CEE7;
	Wed, 17 Sep 2025 20:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758142000;
	bh=7lg7Ui5YqpgSc8Fe6nNx38G4jbCoVp96315Rr9KBlHQ=;
	h=Date:To:From:Subject:From;
	b=w0+eRjxlvujDPpwVsvAkLzxPDzHYoZfL90o7bdFIq+gF9Yf0s/qhXSw7sZ8I0Efli
	 vm1d/L09SoV5Q5Mjxu9dwauiXV3D/BoJvQUdOt8GlHEdMsUKarjzKX/2VAb2xU0K2z
	 88mzcxSd784aiue+psX26DG1SMidJv53H6OYWXi4=
Date: Wed, 17 Sep 2025 13:46:39 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,mhocko@kernel.org,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch added to mm-new branch
Message-Id: <20250917204640.82349C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix
Date: Wed Sep 17 01:45:36 PM PDT 2025

tweak comment grammar

Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix
+++ a/mm/vmalloc.c
@@ -2059,9 +2059,8 @@ retry:
 		spin_unlock(&free_vmap_area_lock);
 
 		/*
-		 * This is not a fast path. Check if yielding is
-		 * needed. This is the only one reschedule point
-		 * in vmalloc() path.
+		 * This is not a fast path.  Check if yielding is needed. This
+		 * is the only reschedule point in the vmalloc() path.
 		 */
 		cond_resched();
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch
mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch

