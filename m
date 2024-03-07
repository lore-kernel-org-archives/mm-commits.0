Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FD71384B3
	for <mm-commits@vger.kernel.org>; Thu,  7 Mar 2024 20:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709842544; cv=none; b=mo6LREKbmBE+PwD7YmC79yZ3lkblKNgaBOTSIw9ibaQRm/7+2jfO3bubPZkH4yAcSmdi0Si5l2WEiCLrTTKusUGdFulaGe30QjoB3EhBkZhTq4g5eo9NNbUwwlk8wHzkayg4do+6N9zE2LtMwuArBau8rcNPcmS4sOwz3+wJxPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709842544; c=relaxed/simple;
	bh=EYo7T/Ixg1f0PMFlrLCRRP5HeZit7vO3IOQKNzN481s=;
	h=Date:To:From:Subject:Message-Id; b=shNnY8jSdHBeyXpoNW09lW8OagQkZZLGylBB6EnNmbP8HfZxSbxA3leQ5VljAsAV0WXC8oPkpholyXsotIZ7EMEMXOM6zhgyNu1yldG8N7SCpNaixa149LEDTlbEYVEnpqTilZDMkQ2Luxaxs75wccRzgxs2a2/Vpp6IyLsc7K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wYd4U0e2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wYd4U0e2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563E0C43390;
	Thu,  7 Mar 2024 20:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709842543;
	bh=EYo7T/Ixg1f0PMFlrLCRRP5HeZit7vO3IOQKNzN481s=;
	h=Date:To:From:Subject:From;
	b=wYd4U0e2R8fyi0UWyTB7Cewip5uowicPbRFrzX9ayMPin3uQAOg4JJEIo8Mf307gv
	 sdrGQujuGFJGPqgdeHkXITdxHr/2Fgdg9k0npOtSUcSPacTI85WnVBdViW+cwkOQbX
	 fVA0WN3vTE8kY4L2rve9KxPE1b4ThbtJpkLsAdoM=
Date: Thu, 07 Mar 2024 12:15:42 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,muchun.song@linux.dev,ben@decadent.org.uk,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-the-hugetlb-madvise-tests-on-unmet-hugepage-requirements.patch added to mm-unstable branch
Message-Id: <20240307201543.563E0C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip the hugetlb-madvise tests on unmet hugepage requirements
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-the-hugetlb-madvise-tests-on-unmet-hugepage-requirements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-the-hugetlb-madvise-tests-on-unmet-hugepage-requirements.patch

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
From: Nico Pache <npache@redhat.com>
Subject: selftests/mm: skip the hugetlb-madvise tests on unmet hugepage requirements
Date: Wed, 6 Mar 2024 15:37:14 -0700

Now that run_vmtests.sh does not guarantee that the correct hugepage count
is available, skip the hugetlb-madvise test if the requirements are not
met rather than failing.

Link: https://lkml.kernel.org/r/20240306223714.320681-4-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-madvise.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugetlb-madvise.c~selftests-mm-skip-the-hugetlb-madvise-tests-on-unmet-hugepage-requirements
+++ a/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -19,6 +19,7 @@
 #include <sys/mman.h>
 #include <fcntl.h>
 #include "vm_util.h"
+#include "../kselftest.h"
 
 #define MIN_FREE_PAGES	20
 #define NR_HUGE_PAGES	10	/* common number of pages to map/allocate */
@@ -78,7 +79,7 @@ int main(int argc, char **argv)
 	free_hugepages = get_free_hugepages();
 	if (free_hugepages < MIN_FREE_PAGES) {
 		printf("Not enough free huge pages to test, exiting!\n");
-		exit(1);
+		exit(KSFT_SKIP);
 	}
 
 	fd = memfd_create(argv[0], MFD_HUGETLB);
_

Patches currently in -mm which might be from npache@redhat.com are

selftests-mm-dont-fail-testsuite-due-to-a-lack-of-hugepages.patch
selftests-mm-skip-uffd-hugetlb-tests-with-insufficient-hugepages.patch
selftests-mm-skip-the-hugetlb-madvise-tests-on-unmet-hugepage-requirements.patch

