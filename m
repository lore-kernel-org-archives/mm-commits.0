Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184E78472
	for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2026 01:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791769532; cv=none; b=AYd2G+CdLpF58kwOswcivIXyIocdIyH6ALuI04qZidb3q6WohnEzmYDkyNfWLoL68NHqvu10FeTa+rKAAcgixNXuudkfkOAXQcvnRxW5GkFS6/GAxrX3Sot4Zn4R2Hgv6Cx5N2SKJzm01ZB5sRfu6MLrbp+1P/n1qUiJ0/g79uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791769532; c=relaxed/simple;
	bh=moA7AOjFe5p4vr8G1KPJByat6uCm4fJUD8QP4uq2UkU=;
	h=Date:To:From:Subject:Message-Id; b=CiDoRTENbgrTJ3FAVHzlZDahAGAKt7TZD9y5MXNkSRSStSAGE5+eONgr0e4Dou24UIdYEFRcjbK+S17tsb+U9jir9CArwlg8hnIs3BpGUPMFhBb/TBm/wI3bb9jUoDItJyGphbF2cgZrLtzNxfH8RWnaUAgJxlobV3j6fIURIjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kaCVOROn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kaCVOROn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943491F0089B;
	Mon, 12 Oct 2026 01:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791769530;
	bh=Wr5v9yC8cAZf/nELJZg9kNZ6Up4QLo0n6v+9AiyKKpY=;
	h=Date:To:From:Subject;
	b=kaCVOROnXL5tGKThG8txrKtW6zinjHmZgE8ReSr3v0nmHiddeFueInDttxxy8Yz0E
	 QoB9BFJBGZ1IfXX/tyvynHtSgSvuZrClirHvB5sAHpPEikoPHOgwel9+vHexmkuQ9p
	 yihLS6JCOIqR67xyjNDDo7nA/ZEgsc3fsx/gGmqg=
Date: Sun, 11 Oct 2026 18:45:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,sarthak.sharma@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-make-file-helpers-return-errors-fix.patch removed from -mm tree
Message-Id: <20261012014530.943491F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-make-file-helpers-return-errors-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-make-file-helpers-return-errors-fix.patch

This patch was dropped because it was folded into selftests-mm-make-file-helpers-return-errors.patch

------------------------------------------------------
From: Sarthak Sharma <sarthak.sharma@arm.com>
Subject: selftests-mm-make-file-helpers-return-errors-fix
Date: Fri, 18 Sep 2026 17:40:50 +0530

Convert hugetlb_nr_resv_pages(), which was missed when read_num()
changed to return an error and store the parsed value through an output
pointer.

Link: https://lore.kernel.org/937939c3-ae9a-4148-a601-0f8876216423@arm.com
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/hugepage_settings.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugepage_settings.c~selftests-mm-make-file-helpers-return-errors-fix
+++ a/tools/testing/selftests/mm/hugepage_settings.c
@@ -515,10 +515,18 @@ unsigned long hugetlb_free_pages(unsigne
 unsigned long hugetlb_nr_resv_pages(unsigned long size)
 {
 	char path[PATH_MAX];
+	unsigned long nr;
+	int ret;
 
 	hugetlb_sysfs_path(path, sizeof(path), size, "resv_hugepages");
 
-	return read_num(path);
+	ret = read_num(path, &nr);
+	if (ret) {
+		print_file_access_error(path, ret);
+		exit(EXIT_FAILURE);
+	}
+
+	return nr;
 }
 
 static bool __hugetlb_setup(unsigned long size, unsigned long nr)
_

Patches currently in -mm which might be from sarthak.sharma@arm.com are

mm-gup_test-safely-calculate-gup-batch-size.patch
selftests-mm-make-file-helpers-return-errors.patch
tools-lib-mm-add-shared-file-helpers.patch
tools-lib-mm-move-hugepage_settings-out-of-selftests.patch
tools-mm-move-gup_test-from-selftests-mm-to-tools-mm.patch
tools-mm-make-gup_bench-a-benchmark-only-tool.patch
selftests-mm-add-a-gup-selftest.patch

