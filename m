Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108682571C2
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 03:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754970624; cv=none; b=aR77eACiq/aM3DlMFJMp4YPI0XFwfWL+RBK/wMeMTKmgrq936zZzT8ZgunELJL6Emndtn3Ql6gF07qEzDlemBOnqjYUGFEGWpib8GJ5OoV64iRArP3ZTMBNVyrw+iRAS1WUyaUMZxwU3KLQ8T8VHeTuCCXjxMSGmRGPrBjrFwJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754970624; c=relaxed/simple;
	bh=InoLqkRiu+i+yAEYIk/FoZ+cdCgicbnfPZkJPw+u0b4=;
	h=Date:To:From:Subject:Message-Id; b=sBZXYyn0I9ko8U5fXavfDvTMwi0rJzaoLYlPtWReb169wTKB+8KdIsTBlN1lnACHVArc3Qw08ygBwcvcPWyPCooppCkF3xJhinZgwy8McvEdUqeab1EAr+zIcOReXw0rcxDogOA6idoKjmhkPG1DPTJ1pPkm15VXi6yRl/pTy/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oc2wEWOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oc2wEWOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1F5C4CEF0;
	Tue, 12 Aug 2025 03:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754970623;
	bh=InoLqkRiu+i+yAEYIk/FoZ+cdCgicbnfPZkJPw+u0b4=;
	h=Date:To:From:Subject:From;
	b=Oc2wEWOiuP+6vyjL+oDg8dtFbE+d5gAvN1Low0Wz+W4ZyOrVLRpnECWXMvSSZ/A+c
	 42G2a5n2uoQ9snU6ppe8Jbuy/XpZEGhyl/nOQaRstkaSw0QzVkE2Bna9Gl8ZAsEEpX
	 AAjhn6KZ96NhLECAJNNBh1AlRvGdSQGBKtcbL2Pw=
Date: Mon, 11 Aug 2025 20:50:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch added to mm-new branch
Message-Id: <20250812035023.7D1F5C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: do check_huge_anon() with a number been passed in
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: selftests/mm: do check_huge_anon() with a number been passed in
Date: Sat, 9 Aug 2025 19:42:09 +0000

Currently it hard codes the number of hugepage to check for
check_huge_anon(), but it would be more reasonable to do the check based
on a number passed in.

Pass in the hugepage number and do the check based on it.

Link: https://lkml.kernel.org/r/20250809194209.30484-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-do-check_huge_anon-with-a-number-been-passed-in
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -107,12 +107,12 @@ static char *allocate_zero_filled_hugepa
 	return result;
 }
 
-static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, size_t len)
+static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
 {
 	unsigned long rss_anon_before, rss_anon_after;
 	size_t i;
 
-	if (!check_huge_anon(one_page, 4, pmd_pagesize))
+	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
 	rss_anon_before = rss_anon();
@@ -143,7 +143,7 @@ void split_pmd_zero_pages(void)
 	size_t len = nr_hpages * pmd_pagesize;
 
 	one_page = allocate_zero_filled_hugepage(len);
-	verify_rss_anon_split_huge_page_all_zeroes(one_page, len);
+	verify_rss_anon_split_huge_page_all_zeroes(one_page, nr_hpages, len);
 	ksft_test_result_pass("Split zero filled huge pages successful\n");
 	free(one_page);
 }
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch

