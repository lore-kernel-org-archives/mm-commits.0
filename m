Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6478125D5
	for <mm-commits@vger.kernel.org>; Sat,  8 Jun 2024 04:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717821656; cv=none; b=moc2IILXdWx9mAT8C1o9vz0DviBgy9j0CfK8wHRGen2I2xzO2Yu7szBW0FrbZCtZIQCGexMU6J7zZHh2cdod8wpk+UWCLq7kv1C6mFXNlyeU5ibrVvsoQ51IsGayXkdnlL+TRJtq/RpjEEKy/4IJDJO2BvEcYtic0Zko+NPkTf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717821656; c=relaxed/simple;
	bh=TY/x5WAx7sDswvL3RrTB2AI5MFfWJGQ/bhzBvNNXtXc=;
	h=Date:To:From:Subject:Message-Id; b=UttJcpWdBM8BBrXVy/OYfA7qHHhJ8oS2vgWgnF+YQt6gpWv4OnKMR7hVvC4SisYqFEWjZN6d4ln12qdhni02BCvWW7IFzqTPqU9U4nBoQvRMkMRaCWis0dia0AWPSrhPzW0zBBPPB0uJ/x5QXs37eJi/DEEGkp4fBHfIRlbm3Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w1iCbzw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w1iCbzw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E667C2BD11;
	Sat,  8 Jun 2024 04:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717821656;
	bh=TY/x5WAx7sDswvL3RrTB2AI5MFfWJGQ/bhzBvNNXtXc=;
	h=Date:To:From:Subject:From;
	b=w1iCbzw6nYFVlGw3Vrw/dgPTKt0/UYw9T6Kc9i7l+e947VUm2RP93IlYech7ai8Ym
	 FyGTpfFjNHHMxsMEa4uwGZc+uj6sFiD0lZKKZc34JSKzKSnKj71fMfMI/Fld6YJD0J
	 7jwe/KBayCSvLMHEyWRUAkgmKoMkNwTUBjslzI6s=
Date: Fri, 07 Jun 2024 21:40:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,shuah@kernel.org,mcgrof@kernel.org,david@redhat.com,p.raghav@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-asm-volatile-to-not-optimize-mmap-read-variable.patch added to mm-unstable branch
Message-Id: <20240608044056.4E667C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: use asm volatile to not optimize mmap read variable
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-use-asm-volatile-to-not-optimize-mmap-read-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-asm-volatile-to-not-optimize-mmap-read-variable.patch

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

selftests-mm-use-asm-volatile-to-not-optimize-mmap-read-variable.patch

