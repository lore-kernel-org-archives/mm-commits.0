Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB235366
	for <mm-commits@vger.kernel.org>; Fri,  9 May 2025 00:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746749420; cv=none; b=m+qd7S6yOuojN06ONAxN0+Ul2p/5qX7+MllK6rwmAxc/OmTMDC6h2mJRUr38qDbTiWjvNLqN8bB0X6shaCch1SbO/F6gntA9xtIPyRy7w2Ln2+u+hY66NjD8KYb9FO2a8Yrt1vd5bwFGTqfpVYXR0kNvJYBEjJN6Y/dTctJJK4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746749420; c=relaxed/simple;
	bh=yMEe8dGAy1AnwIWOETloAxHCvNpIFi+9LqKENWYJCKk=;
	h=Date:To:From:Subject:Message-Id; b=Y6AjAwznuoZvWYYtIq4IL8myC6bu9Xeh3ulljDqO32M/WIkH9TUWvYOiFS7nXtRhnVyzMEBz2acHm2OBujihOlS7M6evGI+G0XVVsD37Ny0zTBRPryD9TDBAMAUsA0EdRY62b3w+I8QixO8X1wfvQBwr+YgA4oZ0tx9b9jKyL1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z2LiT503; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z2LiT503"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45ABBC4CEE7;
	Fri,  9 May 2025 00:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746749419;
	bh=yMEe8dGAy1AnwIWOETloAxHCvNpIFi+9LqKENWYJCKk=;
	h=Date:To:From:Subject:From;
	b=Z2LiT503+0nYmQqv3F3eQu6hKtB8qyL1X9M3xcQQtCBfvF6ZXwozXB2byx9/Ndi7W
	 MFdufWsBBt35OSSs8sHCxtmubcWHfu3gsFRfCsqwsJdz9VOOiqKrCmtTJcJLc+A43H
	 7ASYMfDtjGF0gmQKEf4mWY7TjeVQYPQEg/iMQ7Gg=
Date: Thu, 08 May 2025 17:10:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,shaggy@kernel.org,lkp@intel.com,jane.chu@oracle.com,donettom@linux.ibm.com,david@redhat.com,dan.carpenter@linaro.org,apopple@nvidia.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-3.patch added to mm-unstable branch
Message-Id: <20250509001019.45ABBC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: jfs: remove redundant NULL check in __metapage_migrate_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-3.patch

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
From: Shivank Garg <shivankg@amd.com>
Subject: jfs: remove redundant NULL check in __metapage_migrate_folio()
Date: Thu, 8 May 2025 06:00:33 +0000

Link: https://lkml.kernel.org/r/a67db238-0ca6-4725-abb2-dc092de87e1b@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202505071850.XaOkcCkX-lkp@intel.com/
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_metapage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jfs/jfs_metapage.c~jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-3
+++ a/fs/jfs/jfs_metapage.c
@@ -238,7 +238,7 @@ static int __metapage_migrate_folio(stru
 	int rc;
 
 	mp = folio_to_mp(src, 0);
-	if (mp && metapage_locked(mp))
+	if (metapage_locked(mp))
 		return -EAGAIN;
 
 	rc = filemap_migrate_folio(mapping, dst, src, mode);
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-add-folio_expected_ref_count-for-reference-count-calculation.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-3.patch

