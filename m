Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7FBEAD0
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 23:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697664; cv=none; b=DqiKyP5Hpxamu7SXGFeMVE5dYYSqvT66sBf9Nc/nsHkScVlpIMw/RY4SPAkwGyFgDpd0gOGX5jWFps25LY1MqSZZi5tikCX5FQm/hhqpvBUbcGlrmNtqFfyCptJ0E+O5gijRJ7RxicMRnVlsOPsCEsadaSnvAyLkt/8EywEnCU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697664; c=relaxed/simple;
	bh=5wkrqMv/YiFlbvzKUWN7HiEcf/Ub0dPqh8dCJVI5/cU=;
	h=Date:To:From:Subject:Message-Id; b=GinIb4dyIvAAddMAcKoYIC3fWlg2j1B90+UKJ4QiBm6sN8Wr0D5+MupbQ9s7e/PofYbG37+7/0+LOzYxdjdks/OISIqdoNYHwU7AZNJbdeIyAKdJXweWLPA0c5rTwQ3TH3BfzMgtpyy/t/YeZSGoltF/mk/SK12pGDvsSV+m42A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wra0sWh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wra0sWh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15272C4CEE4;
	Mon, 19 May 2025 23:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747697664;
	bh=5wkrqMv/YiFlbvzKUWN7HiEcf/Ub0dPqh8dCJVI5/cU=;
	h=Date:To:From:Subject:From;
	b=Wra0sWh1SUankM4zqrNbk2082zJWeVucuKJD/vxVIZb7VktPCL1H7QtRH6OvskbR1
	 TspToAkHQN6kosGfPHwvfLkF6qpPHCIC4a08xfwSbArL6obO2f/doFlRMJZhor+/qs
	 KS50accOXJKgvbvYx2HuTvlCQuJP5iOtYrTMVpck=
Date: Mon, 19 May 2025 16:34:23 -0700
To: mm-commits@vger.kernel.org,pfalcato@suse.de,lorenzo.stoakes@oracle.com,adam@wowsignal.io,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-guard_regionsuffd-tests-when-uffd-is-not-present.patch added to mm-new branch
Message-Id: <20250519233424.15272C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip guard_regions.uffd tests when uffd is not present.
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-guard_regionsuffd-tests-when-uffd-is-not-present.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-guard_regionsuffd-tests-when-uffd-is-not-present.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: skip guard_regions.uffd tests when uffd is not present.
Date: Fri, 16 May 2025 09:29:37 -0400

Patch series "Skip mm selftests instead when kernel features are not
present", v2.

Two guard_regions tests on userfaultfd fail when userfaultfd is not
present.  Skip them instead.

hugevm test reads kernel config to get page table level information and
fails when neither /proc/config.gz nor /boot/config-* is present.  Skip it
instead.


This patch (of 2):

When userfaultfd is not compiled into kernel, userfaultfd() returns -1,
causing guard_regions.uffd tests to fail.  Skip the tests instead.

Link: https://lkml.kernel.org/r/20250516132938.356627-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20250516132938.356627-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Adam Sindelar <adam@wowsignal.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/guard-regions.c~selftests-mm-skip-guard_regionsuffd-tests-when-uffd-is-not-present
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -1453,8 +1453,21 @@ TEST_F(guard_regions, uffd)
 
 	/* Set up uffd. */
 	uffd = userfaultfd(0);
-	if (uffd == -1 && errno == EPERM)
-		ksft_exit_skip("No userfaultfd permissions, try running as root.\n");
+	if (uffd == -1) {
+		switch (errno) {
+		case EPERM:
+			SKIP(return, "No userfaultfd permissions, try running as root.");
+			break;
+		case ENOSYS:
+			SKIP(return, "userfaultfd is not supported/not enabled.");
+			break;
+		default:
+			ksft_exit_fail_msg("userfaultfd failed with %s\n",
+					   strerror(errno));
+			break;
+		}
+	}
+
 	ASSERT_NE(uffd, -1);
 
 	ASSERT_EQ(ioctl(uffd, UFFDIO_API, &api), 0);
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-skip-guard_regionsuffd-tests-when-uffd-is-not-present.patch
selftests-mm-skip-hugevm-test-if-kernel-config-file-is-not-present.patch

