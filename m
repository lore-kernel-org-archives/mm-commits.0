Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB86714EC65
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 19:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719429090; cv=none; b=oJvlkF/Yy7cGjk98SzjR7LDGoTKXNof7t69BacD9JsIRZ7oewbtxNDQ7nw+wDhezV7pdGYQZzotn18tjpbgU6tvQIoMgdQPM/wnKWf+aFRq0iaX/qSgj0Ss2PKHGQAmjfPskrTVEGMPl07k4y+cg1j1BtRoHG9dnzSG3pY1cstg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719429090; c=relaxed/simple;
	bh=sPx/P2k1zTuW4vfOmW+RNJswuxAPavMd9GLQkuFKv+M=;
	h=Date:To:From:Subject:Message-Id; b=qlc3OccT1U7jaowscnYxFDC0p0k6faZlf4XWk0ZMkbrpFwrq8aBwdtdcV1l6LSzAttgguJwDJ5tGKlNN3KgUw9ht59fO4MTpAxDtn8Xin8wUAWcnLnk2d/+zJi8+coNnuEs3likQFrBwo/geDeo8tHGqf6ml2ELYUjv3JFKsacM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B+4wwdFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B+4wwdFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658CFC32782;
	Wed, 26 Jun 2024 19:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719429089;
	bh=sPx/P2k1zTuW4vfOmW+RNJswuxAPavMd9GLQkuFKv+M=;
	h=Date:To:From:Subject:From;
	b=B+4wwdFl2yKNx90XQOPkwskecSjNcUDpiwtN4bgBczuqRrs7kge01r0jqFvZ3dLnD
	 GI/TanvSH2bYN9rrFvcnAdQjSFgsaUPGXfqN9m5lg91c+6dIuC21funAVxrgKgTjPr
	 DlhvsCphYQATRIJ7ga1tDB0307Sw4btRyPiM1OgE=
Date: Wed, 26 Jun 2024 12:11:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,donettom@linux.ibm.com,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix.patch added to mm-unstable branch
Message-Id: <20240626191129.658CFC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix
Date: Wed, 26 Jun 2024 18:14:44 +0200

Donet reports an issue during NUMA migration we haven't seen previously:

	[   71.422804] list_del corruption, c00c00000061b3c8->next is
	LIST_POISON1 (5deadbeef0000100)
	[   71.422839] ------------[ cut here ]------------
	[   71.422843] kernel BUG at lib/list_debug.c:56!
	[   71.422850] Oops: Exception in kernel mode, sig: 5 [#1]

We forgot to convert one "return 0;" to return an error instead from
migrate_misplaced_folio_prepare() in case the target node is nearly
full.

Link: https://lkml.kernel.org/r/8f85c31a-e603-4578-bf49-136dae0d4b69@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix
+++ a/mm/migrate.c
@@ -2564,7 +2564,7 @@ int migrate_misplaced_folio_prepare(stru
 		int z;
 
 		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING))
-			return 0;
+			return -EAGAIN;
 		for (z = pgdat->nr_zones - 1; z >= 0; z--) {
 			if (managed_zone(pgdat->node_zones + z))
 				break;
_

Patches currently in -mm which might be from david@redhat.com are

mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix.patch

