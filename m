Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8052717578
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118483; cv=none; b=QK9gRA0M15E0Ejxm4JdmXunxeB1g7bvxbh8SqKMb9tSeyeC2XbRPbCRaBzxlBYIAKoDh38UU4zUGQCerS/xB1rWJImbRhMYljuUv5GGju3WYN6uSd/O5P+tOwnE11z82yHQOmCMDaYLipzDF3cW0kWUJHXCyZ9ljp1lB4YIq7LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118483; c=relaxed/simple;
	bh=HrcYc74e0w7lnr+A1KBmM1NZkzJzBpzQvQ3z7Dd5Mf0=;
	h=Date:To:From:Subject:Message-Id; b=sXJl7oDm6Oi6Rq2Kotn/AKNZ39vG0OOMYsqqDDdX+o82fydZmlM3ofU/HYM3IEAcQ9p8Gxex37JtviL2XvUA//qYaIdzsDGbjsX3DMPuS0Gveajfpjo+Cn5KHLq0VZZlB6IEv5rDLehp5iHYqlay88u73PQ/vDvqlv6YwbiZDuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kOfUCh5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kOfUCh5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE18C4CEEF;
	Tue, 13 May 2025 06:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118483;
	bh=HrcYc74e0w7lnr+A1KBmM1NZkzJzBpzQvQ3z7Dd5Mf0=;
	h=Date:To:From:Subject:From;
	b=kOfUCh5CddfuU9cdXOubm5VP5bMhBHJ48aHVE38azMRkLeeXZHcBIkDOG6SZ7P+kF
	 I5szPFC/SwQoExX3elq70EgRDwr9pxZOqEgkQfy7fG+NKvupWj3IngniGIy2eeQ+/L
	 vOUSUbdcxPG5rJZz3iJB+luimfF9PjPLOU5VCKMs=
Date: Mon, 12 May 2025 23:41:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,shaggy@kernel.org,lkp@intel.com,jane.chu@oracle.com,donettom@linux.ibm.com,david@redhat.com,dan.carpenter@linaro.org,apopple@nvidia.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-3.patch removed from -mm tree
Message-Id: <20250513064122.DDE18C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: jfs: remove redundant NULL check in __metapage_migrate_folio()
has been removed from the -mm tree.  Its filename was
     jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-3.patch

This patch was dropped because it was folded into jfs-implement-migrate_folio-for-jfs_metapage_aops.patch

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

