Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56D91C173C
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118481; cv=none; b=U9DGvgJ8Uoni4FZzP0teZwk+XxbyhnpYaADev4ocY9N1MrVkD6yplVo0KL+c8KApdszW+dlU9DfrdEe7yCPLlcFaYlFx5aox4xQ7NmM01Zpu3FW1/J02GuThERjlDTggbgr7HnkIdIHibdsCKSktLTWIRpfgOyngosdbZA02oho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118481; c=relaxed/simple;
	bh=NiPkh0V8FN01ZHmrOpjxTzPcBFHoN0jYG/ZAz0alkaA=;
	h=Date:To:From:Subject:Message-Id; b=f//26HkO7hlagOC/CVwZ7MBwwXyisKSO7t2ph4cYBwtJjcXoTp76AqXGBw3dR+q7gc6k4WWqdnHIxq4le/zGnf9jOx0HkKrEUn96c49iHsn0Bjw+AxLWzdgZOmPPT1j3SVuvs8dLoqb+ufodgMlaUaGoE/FW8WidPC86KuAsvpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CvLFgtk9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CvLFgtk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273B7C4CEE4;
	Tue, 13 May 2025 06:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118480;
	bh=NiPkh0V8FN01ZHmrOpjxTzPcBFHoN0jYG/ZAz0alkaA=;
	h=Date:To:From:Subject:From;
	b=CvLFgtk9Y0SZVEmCVYqRI64DwK2dbzC1/1k5B8CQsAevk2r5jifq2z4wjtFruADbt
	 L9/6sF3L9b4ShQEkwKTFpuGFROq/DA+UnopoV1Ah7E3+WZFHPlCdPNHLd1cCaD95Kv
	 rE2hyCteNRpUo/gM0gVX3R5oXuMC6dhxZ19/wRQA=
Date: Mon, 12 May 2025 23:41:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,shaggy@kernel.org,lkp@intel.com,jane.chu@oracle.com,donettom@linux.ibm.com,david@redhat.com,dan.carpenter@linaro.org,apopple@nvidia.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] jfs-implement-migrate_folio-for-jfs_metapage_aops-fix.patch removed from -mm tree
Message-Id: <20250513064120.273B7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: jfs: fix kernel-doc warning in jfs_metapage.c
has been removed from the -mm tree.  Its filename was
     jfs-implement-migrate_folio-for-jfs_metapage_aops-fix.patch

This patch was dropped because it was folded into jfs-implement-migrate_folio-for-jfs_metapage_aops.patch

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: jfs: fix kernel-doc warning in jfs_metapage.c
Date: Thu, 1 May 2025 11:10:54 +0000

Change comment style from "/**" to "/*" as the metapage_migrate_folio
function comment is not kernel-doc.

Link: https://lkml.kernel.org/r/1967593d-8084-4a4a-b384-35d5adc54eb4@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505011647.L0LGO7Lm-lkp@intel.com/
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
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

--- a/fs/jfs/jfs_metapage.c~jfs-implement-migrate_folio-for-jfs_metapage_aops-fix
+++ a/fs/jfs/jfs_metapage.c
@@ -629,7 +629,7 @@ static bool metapage_release_folio(struc
 	return ret;
 }
 
-/**
+/*
  * metapage_migrate_folio - Migration function for JFS metapages
  */
 static int metapage_migrate_folio(struct address_space *mapping, struct folio *dst,
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-add-folio_expected_ref_count-for-reference-count-calculation.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-3.patch

