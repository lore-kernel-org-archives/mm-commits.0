Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866A036D506
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067170; cv=none; b=WB6HTGO629RHmFG7kqrWkbaifeztvng1A1Q3mkKwaG848o0adTDJh5i0rri+eSBqN3QRUca9zMBrwsNE8TAInDqZm+aMtzAWV6vVKJDm1aOSFSkhH1f277KUfONO+IMjvdF+h0mCDOJi1HZGS+lGC/hWvuZJ2w/di8na+6WdkgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067170; c=relaxed/simple;
	bh=zv3tiYX2Sv9Hmhx91MVJctWnmCW9JZMdd+al0Opxf4o=;
	h=Date:To:From:Subject:Message-Id; b=n9shhqu4KiGId0+aPZhgIEw2Czy2GRm4/YF8HWdVDehCALcpWtnQOOpN/hvr+vfM4iDiGwz5OQwL1cIOXV0ss5VznhWgBADGtQkldfGx66MGEEUVhkoQq9NKAFJirTPu2OdqvO1bNhIJAH84D3UB/enm+WS5JgmkRyPATVcbdh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LNhTHeR9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LNhTHeR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D941F000E9;
	Sun, 21 Jun 2026 18:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067169;
	bh=TJ/U/kkqvA3mcIftlfe4B1TpdTtrxFXtx9pmqqHlMdw=;
	h=Date:To:From:Subject;
	b=LNhTHeR9pFhAZzV8/czQUsQ/0RytqR/rPIgFpXm0bMz0l88g0GO/XZPGFRVEIuMyY
	 x07Dv7hQ0TX82QtJJdLff5zHC5YC4/WXs/kkg0dekYnULuLbPufLdIfDdOz8hMvFNK
	 cjvkEZfoOqFlMjf/NRI2qh9gCMtWGQgjsiCPQgOg=
Date: Sun, 21 Jun 2026 11:39:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugetlb-mmap-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183929.60D941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hugetlb-mmap: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugetlb-mmap-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: hugetlb-mmap: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:24 +0300

hugetlb-mmap test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-41-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
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

 tools/testing/selftests/mm/hugetlb-mmap.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-mmap.c~selftests-mm-hugetlb-mmap-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -105,28 +105,35 @@ int main(int argc, char **argv)
 {
 	size_t hugepage_size;
 	size_t length = LENGTH;
-	int shift = 0;
+	int shift = 0, nr;
 
 	ksft_print_header();
-	ksft_set_plan(2);
 
 	if (argc > 1)
 		length = atol(argv[1]) << 20;
 	if (argc > 2)
 		shift = atoi(argv[2]);
 
+	hugetlb_save_settings();
 	if (shift) {
 		hugepage_size = (1UL << shift);
 		ksft_print_msg("%lu kB hugepages\n", 1UL << (shift - 10));
 	} else {
 		hugepage_size = default_huge_page_size();
+		if (!hugepage_size)
+			ksft_exit_skip("Could not detect default hugetlb page size.");
 		ksft_print_msg("Default size hugepages (%lu kB)\n", hugepage_size >> 10);
 	}
 
 	/* munmap will fail if the length is not page aligned */
-	if (hugepage_size > length)
-		length = hugepage_size;
+	length = (length + hugepage_size - 1) & ~(hugepage_size - 1);
+	nr = length / hugepage_size;
+
+	hugetlb_set_nr_pages(hugepage_size, nr);
+	if (hugetlb_free_pages(hugepage_size) < nr)
+		ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
 
+	ksft_set_plan(2);
 	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
 
 	test_anon_mmap(length, shift);
_

Patches currently in -mm which might be from rppt@kernel.org are


