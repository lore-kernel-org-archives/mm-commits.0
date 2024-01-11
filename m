Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC5D58205;
	Thu, 11 Jan 2024 21:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pLS5mTPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F73EC433F1;
	Thu, 11 Jan 2024 21:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705007660;
	bh=XLD78mXF3GfkDd5hMDTNHKe08UvMIrlFGV+Sa7uY1sk=;
	h=Date:To:From:Subject:From;
	b=pLS5mTPLl2SoULqsHcE7X2Dt+VPWcenj4clFzLUgG07lqoflotIFJlKOPmf2FjDmh
	 oZSx5TN5wPOSMgl8VL05zQIOBgz/1sPGOT0K92g0zWV1GQ/jPWOSJhzbLRJNzr54Yq
	 V8yz8X7HHXvwGR3QbcJH6lUeAb8pe9mH1R+xd+6U=
Date: Thu, 11 Jan 2024 13:14:19 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,lstoakes@gmail.com,joel@joelfernandes.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mremap_test-fix-build-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20240111211420.5F73EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mremap_test: fix build warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-mremap_test-fix-build-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mremap_test-fix-build-warning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: mremap_test: fix build warning
Date: Thu, 11 Jan 2024 13:20:38 +0500

Fix following build warning:
warning: format `%d' expects argument of type `int', but argument 2 has type `long long unsigned int'

Link: https://lkml.kernel.org/r/20240111082039.3398848-1-usama.anjum@collabora.com
Fixes: a4cb3b243343 ("selftests: mm: add a test for remapping to area immediately after existing mapping")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-mremap_test-fix-build-warning
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -457,7 +457,7 @@ static long long remap_region(struct con
 			char c = (char) rand();
 
 			if (((char *) dest_preamble_addr)[i] != c) {
-				ksft_print_msg("Preamble data after remap doesn't match at offset %d\n",
+				ksft_print_msg("Preamble data after remap doesn't match at offset %llu\n",
 					       i);
 				ksft_print_msg("Expected: %#x\t Got: %#x\n", c & 0xff,
 					       ((char *) dest_preamble_addr)[i] & 0xff);
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock.patch
selftests-mm-mremap_test-fix-build-warning.patch

