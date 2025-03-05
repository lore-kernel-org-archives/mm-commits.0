Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF6C259CAC;
	Wed,  5 Mar 2025 21:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741210923; cv=none; b=alNw8aROdjY7K93A3pvLWL+Qk9zgfblcf4weZtfxCHzZmFJgnZ3qHmHunk/ygcRXQsgRhFfaiOSvLj9O3Ir7PmAEA9zlTj75mqFD5v2944A6c0sgwkyWZtnSHcKGh9W1Ayn+ktElgUly7jbrmgFvOb7Mtc0SzF7J7H2fgvSCpT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741210923; c=relaxed/simple;
	bh=MEYlErtMNJGu33by+TzxsernoAlyBfFr0DR1qd9lK7s=;
	h=Date:To:From:Subject:Message-Id; b=gkwytEsEVdpHGeAxJVQytJ1pOxj0cc6BJczYjHWgHZNruKRN4JSp4egFGIOX+sRHQqeQDKrmbJ02NZMSGrQz6KHk3DgVdFSyAcr1AE0XN5Eky1oL88bW+bPhOhXJ7FhlzvXWd6/eQs0Cki8juP0KUir4W2MWKD/vfqZisO9wEpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BI+sRnJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BI+sRnJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB55CC4CED1;
	Wed,  5 Mar 2025 21:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741210922;
	bh=MEYlErtMNJGu33by+TzxsernoAlyBfFr0DR1qd9lK7s=;
	h=Date:To:From:Subject:From;
	b=BI+sRnJXarI7PG91EIILoliHTDaVJc7h3igxHYNINav3DhNukARL1XN9YBcNNrLgE
	 KS1cVW4LH5CMBaC1uCdnsTRPALTXYcxUGZUx2BfcZVXFE5phER4KhR1lVv3S3QV79y
	 bPq/ZJZzumo74VDDLyPZenbruc2tcmqbIDARx5Ec=
Date: Wed, 05 Mar 2025 13:42:01 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,ryan.roberts@arm.com,quic_charante@quicinc.com,liushixin2@huawei.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-shmem-xarray-update-during-migration.patch added to mm-hotfixes-unstable branch
Message-Id: <20250305214202.BB55CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: fix shmem xarray update during migration
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate-fix-shmem-xarray-update-during-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-fix-shmem-xarray-update-during-migration.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: fix shmem xarray update during migration
Date: Wed, 5 Mar 2025 15:04:03 -0500

A shmem folio can be either in page cache or in swap cache, but not at the
same time.  Namely, once it is in swap cache, folio->mapping should be
NULL, and the folio is no longer in a shmem mapping.

In __folio_migrate_mapping(), to determine the number of xarray entries to
update, folio_test_swapbacked() is used, but that conflates shmem in page
cache case and shmem in swap cache case.  It leads to xarray multi-index
entry corruption, since it turns a sibling entry to a normal entry during
xas_store() (see [1] for a userspace reproduction).  Fix it by only using
folio_test_swapcache() to determine whether xarray is storing swap cache
entries or not to choose the right number of xarray entries to update.

[1] https://lore.kernel.org/linux-mm/Z8idPCkaJW1IChjT@casper.infradead.org/

Note:
In __split_huge_page(), folio_test_anon() && folio_test_swapcache() is
used to get swap_cache address space, but that ignores the shmem folio in
swap cache case.  It could lead to NULL pointer dereferencing when a
in-swap-cache shmem folio is split at __xa_store(), since
!folio_test_anon() is true and folio->mapping is NULL.  But fortunately,
its caller split_huge_page_to_list_to_order() bails out early with EBUSY
when folio->mapping is NULL.  So no need to take care of it here.

Link: https://lkml.kernel.org/r/20250305200403.2822855-1-ziy@nvidia.com
Fixes: fc346d0a70a1 ("mm: migrate high-order folios in swap cache correctly")
Reported-by: Liu Shixin <liushixin2@huawei.com>
Closes: https://lore.kernel.org/all/28546fb4-5210-bf75-16d6-43e1f8646080@huawei.com/
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/migrate.c~mm-migrate-fix-shmem-xarray-update-during-migration
+++ a/mm/migrate.c
@@ -518,15 +518,13 @@ static int __folio_migrate_mapping(struc
 	if (folio_test_anon(folio) && folio_test_large(folio))
 		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
 	folio_ref_add(newfolio, nr); /* add cache reference */
-	if (folio_test_swapbacked(folio)) {
+	if (folio_test_swapbacked(folio))
 		__folio_set_swapbacked(newfolio);
-		if (folio_test_swapcache(folio)) {
-			folio_set_swapcache(newfolio);
-			newfolio->private = folio_get_private(folio);
-		}
+	if (folio_test_swapcache(folio)) {
+		folio_set_swapcache(newfolio);
+		newfolio->private = folio_get_private(folio);
 		entries = nr;
 	} else {
-		VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
 		entries = 1;
 	}
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-migrate-fix-shmem-xarray-update-during-migration.patch
selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch

