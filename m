Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C4F4C98
	for <mm-commits@vger.kernel.org>; Wed, 15 Jan 2025 03:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736912200; cv=none; b=mUlRc5dzZm9BcqvgNeChC4OamoFbi7t2TDzoogGZnCNqBFwP1C6RTqBn2tslQJzzN2h5I7msX5O2Uzv9X1lfHIZFHjU+/3HapFAGHHfI6plySeqN61BLa37f6UUevc9UczIkpYuvT+MLJlp6b0GDyFYO4rabfkTXkfZ+cwNwObo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736912200; c=relaxed/simple;
	bh=4UA8FMmlL1dGaNDTxrLlhYCuw9AuMVCkm/m1Z0B4Hcg=;
	h=Date:To:From:Subject:Message-Id; b=t2249pfg9w9Jqsp7c23cXc7c6QEa/ZxZIOQIVmDpSxIjtEs7GXdPYHBe+qQYdXBo7Ztz7O0rcB94FQGDrf+hDxSWuauPQJynIGmSupgypr9Wfsk62ElhVB4R1jiJhkFEksToRtuScHRCIfU9M0w9gkJoEeBy5A6qSdaZwLF+zhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uyt1UBj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uyt1UBj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D6EC4CEDD;
	Wed, 15 Jan 2025 03:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736912200;
	bh=4UA8FMmlL1dGaNDTxrLlhYCuw9AuMVCkm/m1Z0B4Hcg=;
	h=Date:To:From:Subject:From;
	b=uyt1UBj8K/R/gFrE/nLDUbIZSYsQq8LRqkcK6gcpywT0yAapWnLTB+6Pc3hcEojdo
	 1DJas5wRoX9Csh88Y8jnvIIK1BIyhl29LzrKDioKgJZpZ76t3sLuFYVkitePWdLSFl
	 8fO3fA9uOo1t01DrUgfNAmVt9+3lMjQ/7jsjPM08=
Date: Tue, 14 Jan 2025 19:36:39 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mkdirty-fix-memory-leak-in-test_uffdio_copy.patch added to mm-unstable branch
Message-Id: <20250115033640.08D6EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/mkdirty: fix memory leak in test_uffdio_copy()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-mkdirty-fix-memory-leak-in-test_uffdio_copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mkdirty-fix-memory-leak-in-test_uffdio_copy.patch

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
From: liuye <liuye@kylinos.cn>
Subject: selftests/mm/mkdirty: fix memory leak in test_uffdio_copy()
Date: Tue, 14 Jan 2025 10:38:38 +0800

Release memory before exception branch returns to prevent memory leaks

Checking tools/testing/selftests/mm/mkdirty.c ...
tools/testing/selftests/mm/mkdirty.c:283:3: error: Memory leak: src [memleak]
  return;
  ^

Link: https://lkml.kernel.org/r/20250114023838.48589-1-liuye@kylinos.cn
Signed-off-by: liuye <liuye@kylinos.cn>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mkdirty.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/mkdirty.c~selftests-mm-mkdirty-fix-memory-leak-in-test_uffdio_copy
+++ a/tools/testing/selftests/mm/mkdirty.c
@@ -280,6 +280,7 @@ static void test_uffdio_copy(void)
 	dst = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE|MAP_ANON, -1, 0);
 	if (dst == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
+		free(src);
 		return;
 	}
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmscan-fix-hard-lockup-in-function-isolate_lru_folios.patch
selftests-memfd-memfd_test-fix-possible-null-pointer-dereference.patch
selftests-mm-mkdirty-fix-memory-leak-in-test_uffdio_copy.patch

