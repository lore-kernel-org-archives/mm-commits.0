Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360EB36F437
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067169; cv=none; b=FcMIuXq7aZFrZgghyvM6Sb4LktUGkj44y+mazLR3mBGGC6jicELpaDg6lEDbI29260ZR+tGopwCz8NI2bKvXgJinlQDRGByDFQW+Augpq+Iv3G5lBYfme4ShRCOW5ozYHuMbobQYjDCMB7wD90n/WFl8LhAIL1myQQ5bXlG9axw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067169; c=relaxed/simple;
	bh=gEfJsRsl5NO+QrZAR7jSJBnEFWlikA3CwRlT/M2BXMY=;
	h=Date:To:From:Subject:Message-Id; b=dTRcbr3gyMIdHtj/Gv/LQdfmS+Eh34t4N+KrepCra0wFIJ46NrIOwXf/0cOLpcem5pScjbsGUxCrAscG4fj+2XLY/IWm6VdBzms57XZfJqX3AIVVKlyuBc2PQybeSoLTfXucKW4Q4C0rcUwPIJ84YmwWTgSSkkFAq4UTLhOfeeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i7+rQ3jn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i7+rQ3jn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107061F000E9;
	Sun, 21 Jun 2026 18:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067168;
	bh=aWO3eb5GTkDF0or4+zBP1Kd4hOqh+j6g+3ry6xEEw0U=;
	h=Date:To:From:Subject;
	b=i7+rQ3jnv7cNA7muFag7/+FAw/VafCsI3Xn2mVl8XqHZz93wvz+li+Q1BLkiHQV0f
	 Pz6biA5COztsx9eQ0LKN1RjPDR+Nf/ELHwYun2zLVtUEoXc/QTj5ZhMpn9sZxRVbdO
	 KkAmApiXopNU9dvXkMRDm/JCmnMEY3ADP6cobKCo=
Date: Sun, 21 Jun 2026 11:39:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugetlb_madv_vs_map-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183928.107061F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hugetlb_madv_vs_map: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugetlb_madv_vs_map-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: hugetlb_madv_vs_map: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:23 +0300

hugetlb_madv_vs_map test skips testing if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-40-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_madv_vs_map.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c~selftests-mm-hugetlb_madv_vs_map-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -77,7 +77,6 @@ void *map_extra(void *unused)
 int main(void)
 {
 	pthread_t thread1, thread2, thread3;
-	unsigned long free_hugepages;
 	void *ret;
 
 	/*
@@ -89,11 +88,9 @@ int main(void)
 	ksft_print_header();
 	ksft_set_plan(1);
 
-	free_hugepages = hugetlb_free_default_pages();
-
-	if (free_hugepages != 1)
+	if (!hugetlb_setup_default_exact(1))
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
-			       free_hugepages);
+			       hugetlb_free_default_pages());
 
 	mmap_size = default_huge_page_size();
 
_

Patches currently in -mm which might be from rppt@kernel.org are


