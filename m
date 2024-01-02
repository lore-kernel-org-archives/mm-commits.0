Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E8D15AEA
	for <mm-commits@vger.kernel.org>; Tue,  2 Jan 2024 19:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vhziGwuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643EDC433C9;
	Tue,  2 Jan 2024 19:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704223326;
	bh=DHj/NcPH9eZlX89X9/nxgOgsQ9RJ7CXFWYK5PazvoZs=;
	h=Date:To:From:Subject:From;
	b=vhziGwuq1L3PRNYY21p0v+0bGJ4E8dPrAodVE5KMjgO+UFIyDO5GLBQKAQLTy4MfN
	 3IxVj/MMB0VArn17duB7ZuAWd3RLKsQxNGGsSJWD6rIT5diDeN+VKFsattsOQ/APry
	 nK6WCbRfrAFsyms21Am2rqTaHVnFnULk5dEvJDeE=
Date: Tue, 02 Jan 2024 11:22:05 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-test-if-application-doesnt-has-root-privileges.patch added to mm-unstable branch
Message-Id: <20240102192206.643EDC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip test if application doesn't has root privileges
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-test-if-application-doesnt-has-root-privileges.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-test-if-application-doesnt-has-root-privileges.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: skip test if application doesn't has root privileges
Date: Mon, 1 Jan 2024 13:36:13 +0500

The test depends on writing to nr_hugepages which isn't possible without
root privileges.  So skip the test in this case.

Link: https://lkml.kernel.org/r/20240101083614.1076768-2-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-skip-test-if-application-doesnt-has-root-privileges
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -173,7 +173,7 @@ int main(int argc, char **argv)
 
 	ksft_print_header();
 
-	if (prereq() != 0)
+	if (prereq() || geteuid())
 		return ksft_exit_pass();
 
 	ksft_set_plan(1);
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

mm-selftests-hugepage-mremap-conform-test-to-tap-format-output.patch
selftests-mm-gup_test-conform-test-to-tap-format-output.patch
selftests-mm-hugepage-mmap-conform-to-tap-format-output.patch
selftests-mm-conform-test-to-tap-format-output.patch
selftests-mm-skip-test-if-application-doesnt-has-root-privileges.patch

