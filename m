Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854C213C81B;
	Tue,  4 Mar 2025 02:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741057158; cv=none; b=ckAAe4nF6m+FV14jqtn7jppz4zhA3md/tUs1WgQWu9b6FW2Ogl0MHwjuQ/jf0q2o3X4pdojQH/4SswezBHlJ0QWdv/YTMZyNJPzm+37JYMEL5qgY3eoL/wTkcvYPiJIYwlMh6RvIaNLZjdsbJUxoUeX/SuMeAr9rR2+v7/Q2S9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741057158; c=relaxed/simple;
	bh=Z2Qjdkt6YSU8BpjclkHX2vv8TlZX9IoYQ9qnI5D4l/I=;
	h=Date:To:From:Subject:Message-Id; b=fH5etGR8FpDBkrkjMYk+ewzvhpsRg3GhlnaPBDgrKFVo+28TXiAslGub+50iwkpNxTWCJvFRzIp3BxoGVvEQkpshso6/ZS6m2KRT8vHgGEtXvKpXVkTYtcktuejqKvyEL92mrSa/sCkBPxVbZLHmemobwnisZnhXC/425EKYyD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vKG0//3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vKG0//3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCBFC4CEE4;
	Tue,  4 Mar 2025 02:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741057157;
	bh=Z2Qjdkt6YSU8BpjclkHX2vv8TlZX9IoYQ9qnI5D4l/I=;
	h=Date:To:From:Subject:From;
	b=vKG0//3Tq3DVTn7jvRRaez0XQWr/9i3+aqNR+Te+P9NEpZE+4/RoKQySH41y6trwY
	 DB4GIsOhy83O+PvbxCt1CwtWrB6rnBKIi/BMYGT5W6br3ypnD5KbaONnKLpmyJC/gX
	 YW/W2j1cyYZ25VHoatfXrqDMQjWEXjerp61Ctt7E=
Date: Mon, 03 Mar 2025 18:59:17 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,shivankg@amd.com,ryan.roberts@arm.com,quic_charante@quicinc.com,liushixin2@huawei.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-shmem-xarray-update-during-migration.patch added to mm-hotfixes-unstable branch
Message-Id: <20250304025917.BBCBFC4CEE4@smtp.kernel.org>
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
Date: Fri, 28 Feb 2025 12:49:53 -0500

Pagecache uses multi-index entries for large folio, so does shmem.  Only
swap cache still stores multiple entries for a single large folio.  Commit
fc346d0a70a1 ("mm: migrate high-order folios in swap cache correctly")
fixed swap cache but got shmem wrong by storing multiple entries for a
large shmem folio.

This results in a soft lockup as reported by Liu Shixin.

Fix it by storing a single entry for a shmem folio.

Link: https://lkml.kernel.org/r/20250228174953.2222831-1-ziy@nvidia.com
Fixes: fc346d0a70a1 ("mm: migrate high-order folios in swap cache correctly")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Liu Shixin <liushixin2@huawei.com>
Closes: https://lore.kernel.org/all/28546fb4-5210-bf75-16d6-43e1f8646080@huawei.com/
Reviewed-by: Shivank Garg <shivankg@amd.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-shmem-xarray-update-during-migration
+++ a/mm/migrate.c
@@ -524,7 +524,11 @@ static int __folio_migrate_mapping(struc
 			folio_set_swapcache(newfolio);
 			newfolio->private = folio_get_private(folio);
 		}
-		entries = nr;
+		/* shmem uses high-order entry */
+		if (!folio_test_anon(folio))
+			entries = 1;
+		else
+			entries = nr;
 	} else {
 		VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
 		entries = 1;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-migrate-fix-shmem-xarray-update-during-migration.patch
selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation.patch
mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation-fix.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

