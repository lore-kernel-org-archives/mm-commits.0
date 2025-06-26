Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C032206A6
	for <mm-commits@vger.kernel.org>; Thu, 26 Jun 2025 21:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750974564; cv=none; b=LIjqGWDqxf5zp7bILMZFW4imMqrBlX9CQ5T7/SkjAaZjBnKh0L983GO8RYVzscFa2iTTNYrf40xer+ihmJbuuuthKciaAzo8CyJMJPJtYPVak/6PxDCF0uZudT+1PZWGZ8TONIuwZuwstw5oeHLaukBFzi4tgE8doRFV+pxg+9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750974564; c=relaxed/simple;
	bh=KKUQPnDtz81WtYafW/s4ZWcs7yO4U3X4pzoFlAXi9Bk=;
	h=Date:To:From:Subject:Message-Id; b=CCpP0K3krUl+tvZapWC1l0IyF/810etMX0xzzeyX9bMbJcyFoA7gzcJlej3XcMPHmIjcDIK9cZtbFbF5C9jEHdF7ZxTAyFfb4dIik5XPj5ImdQpAfGFIeYBPb5iTGhD1NsFixiS1B4EvijoeHIciWpZr9twQqdoiLxKj2fHtVOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sExzDIiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sExzDIiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD184C4CEEB;
	Thu, 26 Jun 2025 21:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750974563;
	bh=KKUQPnDtz81WtYafW/s4ZWcs7yO4U3X4pzoFlAXi9Bk=;
	h=Date:To:From:Subject:From;
	b=sExzDIiIIWPwa9eN0DXByXINGOC2aJOa8vw5enZDpeU5g9SSHdQcsbE3X4Mp+XQ7x
	 4hIoKoPP6SRYXbIJykFMh0qTdNFxI9vUNPU8hSYVdmbdFbcKa3uEUuu71E+oqeHU1W
	 wIcElfmk6/zN3oNL2e/BlzkoC47sonMFWfEPW8NA=
Date: Thu, 26 Jun 2025 14:49:23 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jackmanb@google.com,david@redhat.com,axelrasmussen@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix.patch added to mm-unstable branch
Message-Id: <20250626214923.CD184C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix.patch

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

Author: Peter Xu <peterx@redhat.com>
Subject: selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix
Date:   Thu Jun 26 14:22:21 2025 -0400

reduce uffd-unit-test poison test to minimum

Link: https://lkml.kernel.org/r/aF2RSsjuEOtzXcUa@x1.local
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1040,7 +1040,7 @@ static void uffd_poison_test(uffd_test_a
 	unsigned long nr, poison_pages = UFFD_POISON_TEST_NPAGES;
 
 	if (nr_pages < poison_pages) {
-		uffd_test_skip("Too less pages for POISON test");
+		uffd_test_skip("Too few pages for POISON test");
 		return;
 	}
 
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum.patch

