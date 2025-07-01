Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5940A1C84B3
	for <mm-commits@vger.kernel.org>; Tue,  1 Jul 2025 20:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751402746; cv=none; b=J1ykvxC1HBJsn6YLO0mx3MrgoEhcHGoCYaPGS0790QzzJB3QwGHF4aXTpKkg9oJb/rxT4apelV6WNFIRYHxqwffiylHexodk3YZz1nDC/RycovsZ/SoXIqRSqnl97RiTc2kwATb0oOyTqlNYJ2ASElXzH8tCHb1SEn45umT0/4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751402746; c=relaxed/simple;
	bh=xvZhGpNRviRED5H0rojwFHnafk+GQXAz7sW1Zx/BrLY=;
	h=Date:To:From:Subject:Message-Id; b=cPp5R2vO4niKNPUoH4nTjUqceBrqFPFIQk5HqOXXxMF8Re57U3gNBYHz/coYFw9OJJRZZTi8LCDz8+TGOxYtNUDY402V4aV5qqPU0seBjaMJQusnEZPTQL1/ygCvLOd3IguT72fkEKtErKAUGpTJzNga1CdCp7euZ9AYCRV5FSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1MpKw+FP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1MpKw+FP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD62CC4CEEB;
	Tue,  1 Jul 2025 20:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751402745;
	bh=xvZhGpNRviRED5H0rojwFHnafk+GQXAz7sW1Zx/BrLY=;
	h=Date:To:From:Subject:From;
	b=1MpKw+FPsb88/jSkzulJfunpc8gRtvE6ab1jTZzSDM6xv/aLiiU0hn7dzFRk/2Q3s
	 gDWjRIi5dSk4/N/3IF4BHO1OVVuwk+HXYNA30RNwPGecpAfAWCRGrw8wd1/vZUq97q
	 fqTl6p/lZ+ait21RvxDbCnrdOOgUGgdf1pGCHCSM=
Date: Tue, 01 Jul 2025 13:45:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,myon@debian.org,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,bertranddrouvot.pg@gmail.com,apopple@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fix-do_pages_stat-to-use-compat_uptr_t-fix.patch removed from -mm tree
Message-Id: <20250701204545.AD62CC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fix-do_pages_stat-to-use-compat_uptr_t-fix
has been removed from the -mm tree.  Its filename was
     fix-do_pages_stat-to-use-compat_uptr_t-fix.patch

This patch was dropped because it was folded into fix-do_pages_stat-to-use-compat_uptr_t.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fix-do_pages_stat-to-use-compat_uptr_t-fix
Date: Wed Jun 25 01:37:57 PM PDT 2025

fix coding style

Cc: Alistair Popple <apopple@nvidia.com>
Cc: Bertrand Drouvot <bertranddrouvot.pg@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Christoph Berg <myon@debian.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~fix-do_pages_stat-to-use-compat_uptr_t-fix
+++ a/mm/migrate.c
@@ -2449,8 +2449,9 @@ static int do_pages_stat(struct mm_struc
 
 			pages32 += chunk_nr;
 			pages = (const void __user * __user *) pages32;
-		} else
+		} else {
 			pages += chunk_nr;
+		}
 		status += chunk_nr;
 		nr_pages -= chunk_nr;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fix-do_pages_stat-to-use-compat_uptr_t.patch
mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
maple-tree-use-goto-label-to-simplify-code-fix.patch
mm-damon-sysfs-schemes-decouple-from-damos_action-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
mm-shmem-support-vm_uffd_ops-api-checkpatch-fixes.patch
mm-hugetlb-support-vm_uffd_ops-api-checkpatch-fixes.patch
maintainers-add-lib-raid6-to-software-raid.patch

