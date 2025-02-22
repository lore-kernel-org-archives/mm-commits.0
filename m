Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0AF5383
	for <mm-commits@vger.kernel.org>; Sat, 22 Feb 2025 00:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740183077; cv=none; b=GGQyr8jOKvz7zvWyNYDI2hgJSC1MxRC+lqCEjTqz+//RhAT9hGtG7cURA0HLSiq4DF1kuXHMXmXnoJ+bfD5iCgG+jrcTUHrn3ZFjhUc7NeT82zo9n5W+bjA7MTX/ZV+IHYq4k7LfrNnCZPZ7QcbjEuChSeQfdWbMf5zN/1WPjAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740183077; c=relaxed/simple;
	bh=xv8ONOF3kBfbP6lHAqFSSLxiCZqvZEORoucnNWFptyU=;
	h=Date:To:From:Subject:Message-Id; b=hvQ5Vy+AAo1t7vNvclS6gFqhYjyT4WUwgFhCiwJGML52VkrRt9Ii3mjU1AWCY6Y1FaLU2XFQGC03GmdOV73Jp06/fqK75jLPC82KnJ8zPpt2Ezgma15EBiMREqqKw7QpUMzRoU/iF0PW1DoIgeABKwel0AGukLYt3qLzHyOaNeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z/ClXumT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z/ClXumT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A25C4CED6;
	Sat, 22 Feb 2025 00:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740183077;
	bh=xv8ONOF3kBfbP6lHAqFSSLxiCZqvZEORoucnNWFptyU=;
	h=Date:To:From:Subject:From;
	b=Z/ClXumT3b6/D2IFQYZFSpMZ92YkVrKbgq4zbbOLgW+PNOteZL/9HBet85cKOupo+
	 i9ORWouXdyswko5SOLISRqgHy0aTyKY6IHmRigWXrYTDHHNtLjQAL2SWopzdEn4XUE
	 lJGsh06iepTcx4eLUR4w3m6LqrB/TLAr8mC2BCtw=
Date: Fri, 21 Feb 2025 16:11:16 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch added to mm-unstable branch
Message-Id: <20250222001117.30A25C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip gup_longerm tests on weird filesystems
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: skip gup_longerm tests on weird filesystems
Date: Fri, 21 Feb 2025 18:25:48 +0000

Some filesystems don't support funtract()ing unlinked files.  They return
ENOENT.  In that case, skip the test.

Link: https://lkml.kernel.org/r/20250221-mm-selftests-v2-9-28c4d66383c5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-skip-gup_longerm-tests-on-weird-filesystems
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -96,7 +96,15 @@ static void do_test(int fd, size_t size,
 	int ret;
 
 	if (ftruncate(fd, size)) {
-		ksft_test_result_fail("ftruncate() failed (%s)\n", strerror(errno));
+		if (errno == ENOENT) {
+			/*
+			 * This can happen if the file has been unlinked and the
+			 * filesystem doesn't support truncating unlinked files.
+			 */
+			ksft_test_result_skip("ftruncate() failed with ENOENT");
+		} else {
+			ksft_test_result_fail("ftruncate() failed (%s)\n", strerror(errno));
+		}
 		return;
 	}
 
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-fix-assumption-that-sudo-is-present.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_threads.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch

