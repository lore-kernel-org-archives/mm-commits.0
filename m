Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34743208CA
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 22:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755037087; cv=none; b=rCUTLsqwPWktrXj0EWWf9S9R94iLzKNDzuwTXqrcEEYNtyYK9IdBgN5oqPBvty42ubPSrC9qVciLNnSHWOZLPHhoGt/YQ2SNuUCVL5vRZYq8q9y+JrCmro0EepbG7em1Ca3w5x1BcupRyRxxRxmPtHX9iD5eeHP3BxDsszW9lDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755037087; c=relaxed/simple;
	bh=OgSQ45mNwd/Q8O/7707Po/l6gTY9fkzfu9KO4roH0ro=;
	h=Date:To:From:Subject:Message-Id; b=YH27DeyNkX18o7ouyqQfBRYiKYFOpE3aK5zwLmb2uCdHrEHEwNIUotWFDN7pDWmCSW+BtyOflXI98YxiznlMcE2EpgZscSAZkRWlRiMZYRh3x0IpgfuC+BtcsPkU6yaynjb0oq+QwKG6Xr5llDkJUicOOnLMmW9TNZKTAAODv3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JZI+Xt1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JZI+Xt1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91606C4CEF0;
	Tue, 12 Aug 2025 22:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755037085;
	bh=OgSQ45mNwd/Q8O/7707Po/l6gTY9fkzfu9KO4roH0ro=;
	h=Date:To:From:Subject:From;
	b=JZI+Xt1HHhX09sy+s+h+6jMSzK/zKia/IN9mtPQTThRVaRin167MWPGw9ED4yey6W
	 p2DRpQLdjPbQRDLGzBLRx8CaUiqPeuaF349WBOTZcVTv4sf0i0J3EdXtQuSm6KIC5i
	 AEJoDpnPbiAYLlUdh16H7bVsooyMFhcYJnlw1luo=
Date: Tue, 12 Aug 2025 15:18:04 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,alexghiti@rivosinc.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-fix-selftests-by-installing-drgn-related-script.patch added to mm-hotfixes-unstable branch
Message-Id: <20250812221805.91606C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: fix selftests by installing drgn related script
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-damon-fix-selftests-by-installing-drgn-related-script.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-fix-selftests-by-installing-drgn-related-script.patch

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: selftests/damon: fix selftests by installing drgn related script
Date: Tue, 12 Aug 2025 23:00:46 +0900

drgn_dump_damon_status is not installed during kselftest setup.  It can
break other tests which depend on drgn_dump_damon_status.  Install
drgn_dump_damon_status files to fix broken test.

Link: https://lkml.kernel.org/r/20250812140046.660486-1-ekffu200098@gmail.com
Fixes: f3e8e1e51362 ("selftests/damon: add drgn script for extracting damon status")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-fix-selftests-by-installing-drgn-related-script
+++ a/tools/testing/selftests/damon/Makefile
@@ -4,6 +4,7 @@
 TEST_GEN_FILES += access_memory access_memory_even
 
 TEST_FILES = _damon_sysfs.py
+TEST_FILES += drgn_dump_damon_status.py
 
 # functionality tests
 TEST_PROGS += sysfs.sh
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-core-fix-commit_ops_filters-by-using-correct-nth-function.patch
selftests-damon-fix-selftests-by-installing-drgn-related-script.patch
mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch
selftests-damon-test-no-op-commit-broke-damon-status.patch

