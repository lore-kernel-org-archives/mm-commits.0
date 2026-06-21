Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D18736C9E4
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067160; cv=none; b=cEFtbOZu/GqjqnWfIBRLriDMZKFjQDKLqp61uXl7Mx/j3WMmV7OuB8doBQc/9ReZGyyVRtrpkzeof8XTsawml9gODt0tAjv9/J6raYktlWMoqxvRWskRJs9AZkMUpJrC2QxO82c5Az5Gx2rkxvMCOC7u41wUHszA1Ks40tkkSCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067160; c=relaxed/simple;
	bh=ecCl5Tmpad/ogOc8q/QmyQu2A9+fBbVJNkweM7W9E7E=;
	h=Date:To:From:Subject:Message-Id; b=SaQzHtUUffAmifK0NrtBoF/eXfcuE/EcIKSDQanaL3OOMMm2p06s55EUc9geB0ayBeoRlnqAe2XnzTkuRsC1uP7c3Wv9QwjZ6fqznTq1PGOwker2rFE8Tll+ALAccOg75tcdEGlxYHWP8R5uCCt5cwRj5waiPQ+A1X1eUWQ4Rvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gr70E6cY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gr70E6cY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6AC1F000E9;
	Sun, 21 Jun 2026 18:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067159;
	bh=9uc2c+A9G5SaJpw9XsGIFRWIqFoWoTBpFg0CPa1fGOA=;
	h=Date:To:From:Subject;
	b=Gr70E6cYSq2HWGbGOglK3RFayAJr8791pHjXS5//hNty2je2DDh8TxFOQ73y2KwX1
	 dGUfZymCXLRWuhOZrXQFhwzRbQmj+GrYtsDxkhN5PeMo0Zl6kTuDV2BF2HbS+TjdaE
	 41TOvgzIj9zOdNyO6Jy+TY9Q6wzRo2cRKHc16XpU=
Date: Sun, 21 Jun 2026 11:39:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-cow-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183918.EB6AC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: cow: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-cow-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: cow: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:16 +0300

cow tests skips HugeTLB tests if there are no free huge pages prepared by
a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-33-rppt@kernel.org
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

 tools/testing/selftests/mm/cow.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/cow.c
@@ -1881,21 +1881,21 @@ int main(int argc, char **argv)
 
 	ksft_print_header();
 
+	thp_save_settings();
+
 	pagesize = getpagesize();
 	pmdsize = read_pmd_pagesize();
 	if (pmdsize) {
 		/* Only if THP is supported. */
 		thp_read_settings(&default_settings);
 		default_settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_INHERIT;
-		thp_save_settings();
 		thp_push_settings(&default_settings);
 
 		ksft_print_msg("[INFO] detected PMD size: %zu KiB\n",
 			       pmdsize / 1024);
 		nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
 	}
-	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
-						    ARRAY_SIZE(hugetlbsizes));
+	nr_hugetlbsizes = hugetlb_setup(2, hugetlbsizes, ARRAY_SIZE(hugetlbsizes));
 	has_huge_zeropage = detect_huge_zeropage();
 
 	ksft_set_plan(ARRAY_SIZE(anon_test_cases) * tests_per_anon_test_case() +
_

Patches currently in -mm which might be from rppt@kernel.org are


