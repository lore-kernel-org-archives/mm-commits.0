Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA67414373B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291677; cv=none; b=R3gW/hOtefV2b8VF63CPIspMw/6RgztVbBHV7M5sZhS1Amw22QIdNTnuPrs98Nl+Fbh2Jk59dFjSQhsh3CidJVvEJKcMhw7cX0tzWnB1/Wx/xbdHURpjQYnWVozlAeohfhPSFMvyRoPLTQYrPENiazpqpwi+6RxLqWM4F41Zo/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291677; c=relaxed/simple;
	bh=NSaNJZDw2EQ8sjQgGVW5xXjb/ODJ+eoX7JL9X/ezv3o=;
	h=Date:To:From:Subject:Message-Id; b=d+ZB17IzGoPkeZbJseLFcvhsA5lhvVwYOCugokwM1b2Dvhytt7JIR8I0y2J20BILTLkOekHB1VBASuRPJh1FZ1dqHhJi5dGRwweCiGTsPkVHsXIg6+KnWPLfQq1z7Uh7wIEmI9t7z4JNB/pBISmZ1EjKOX3C60mOvZnXqVm+fVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vWbl7EDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vWbl7EDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17785C32782;
	Tue, 25 Jun 2024 05:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291677;
	bh=NSaNJZDw2EQ8sjQgGVW5xXjb/ODJ+eoX7JL9X/ezv3o=;
	h=Date:To:From:Subject:From;
	b=vWbl7EDMnHKPPGwSs3bevKMYmPpF9qOsqz5/f/8tWiq4QH+YYn/YGOYVmhkmQdq/L
	 4/YNHddDJ3Jk62H2gn7JoM7tmSARsw1mVpTTwmUTWf3xHA1S4KY/pmGg5k/781ptFr
	 Fg1QnLjY0LcjedvOG2wLqUClaUp4FhjC+3BsI+h8=
Date: Mon, 24 Jun 2024 22:01:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,shuah@kernel.org,mcgrof@kernel.org,david@redhat.com,p.raghav@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-use-asm-volatile-to-not-optimize-mmap-read-variable.patch removed from -mm tree
Message-Id: <20240625050117.17785C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: use asm volatile to not optimize mmap read variable
has been removed from the -mm tree.  Its filename was
     selftests-mm-use-asm-volatile-to-not-optimize-mmap-read-variable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: selftests/mm: use asm volatile to not optimize mmap read variable
Date: Thu, 6 Jun 2024 20:36:19 +0000

create_pagecache_thp_and_fd() in split_huge_page_test.c used the variable
dummy to perform mmap read.

However, this test was skipped even on XFS which has large folio support. 
The issue was compiler (gcc 13.2.0) was optimizing out the dummy variable,
therefore, not creating huge page in the page cache.

Use asm volatile() trick to force the compiler not to optimize out the
loop where we read from the mmaped addr.  This is similar to what is being
done in other tests (cow.c, etc)

As the variable is now used in the asm statement, remove the unused
attribute.

Link: https://lkml.kernel.org/r/20240606203619.677276-1-kernel@pankajraghav.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-use-asm-volatile-to-not-optimize-mmap-read-variable
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -300,7 +300,7 @@ int create_pagecache_thp_and_fd(const ch
 		char **addr)
 {
 	size_t i;
-	int __attribute__((unused)) dummy = 0;
+	int dummy = 0;
 
 	srand(time(NULL));
 
@@ -341,6 +341,7 @@ int create_pagecache_thp_and_fd(const ch
 
 	for (size_t i = 0; i < fd_size; i++)
 		dummy += *(*addr + i);
+	asm volatile("" : "+r" (dummy));
 
 	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
 		ksft_print_msg("No large pagecache folio generated, please provide a filesystem supporting large folio\n");
_

Patches currently in -mm which might be from p.raghav@samsung.com are


