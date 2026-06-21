Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81C036F429
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067168; cv=none; b=mVUROfKrya5QDP7qEfplKGK2wFY+KRqVjsBjAtzEAjj0JFlQCYmrsnr0UJhA8eKW1JIePyMJtXKw7DTIIodegczDUPMMWtxEEYzjywf9TjlCLAQOFj6HoSaslMgn7Hph0VVF+1TWh2eSOsCgF4fBspbinfOcr1yq6PVElpSfwBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067168; c=relaxed/simple;
	bh=nM4muixUqnK1QBV+bzmy94QlbBqJcRCjilSWPsDapkQ=;
	h=Date:To:From:Subject:Message-Id; b=UHbnGa9A9iF7SN/b7rpXsK3eSovXPh+JQi6G1nU571uq9Rr+APN+L6p4JEMeYYi4SAPHUSoPumayQIgRVtdH6VyxgDLWldSWUjYIDfSlEx8oSWPIi5QdtBkHo0V4PWnMpAo7xp5ZiuZHeN3HuBKqtR5V05g1mxROCd0cxGeH63A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZKLqbFtO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZKLqbFtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB60A1F00A3A;
	Sun, 21 Jun 2026 18:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067166;
	bh=CFIIdncdhub86HM/d8Vo0UbGPosOphAY6FfXz+C1lN0=;
	h=Date:To:From:Subject;
	b=ZKLqbFtOcdk9cgsfDc7vZcVcBTl8Z+5JSSIR4izLumjGtbOPjlLUWnCliBXb9IvVi
	 1ekbOb6GydH3E3u5nxFGlVsIGXo5QkYyKqqY6hEY9aZY1yCaLVIAZXO1zKgvfkYyIg
	 7mdveTHeqKYc42ym7c519MevCnG/iOoRSv+O8pRY=
Date: Sun, 21 Jun 2026 11:39:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugetlb-madvise-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183926.BB60A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hugetlb-madvise: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugetlb-madvise-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: hugetlb-madvise: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:22 +0300

hugetlb-madvise test skips testing if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-39-rppt@kernel.org
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

 tools/testing/selftests/mm/hugetlb-madvise.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-madvise.c~selftests-mm-hugetlb-madvise-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -4,12 +4,6 @@
  *
  * Basic functional testing of madvise MADV_DONTNEED and MADV_REMOVE
  * on hugetlb mappings.
- *
- * Before running this test, make sure the administrator has pre-allocated
- * at least MIN_FREE_PAGES hugetlb pages and they are free.  In addition,
- * the test takes an argument that is the path to a file in a hugetlbfs
- * filesystem.  Therefore, a hugetlbfs filesystem must be mounted on some
- * directory.
  */
 
 #define _GNU_SOURCE
@@ -68,9 +62,9 @@ int main(int argc, char **argv)
 	if (!base_page_size)
 		ksft_exit_fail_msg("Unable to determine base page size\n");
 
+	if (!hugetlb_setup_default(MIN_FREE_PAGES))
+		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", hugetlb_free_default_pages(), MIN_FREE_PAGES);
 	free_hugepages = hugetlb_free_default_pages();
-	if (free_hugepages < MIN_FREE_PAGES)
-		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", free_hugepages, MIN_FREE_PAGES);
 
 	fd = memfd_create(argv[0], MFD_HUGETLB);
 	if (fd < 0)
_

Patches currently in -mm which might be from rppt@kernel.org are


