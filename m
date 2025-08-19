Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9D042065;
	Tue, 19 Aug 2025 21:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755638448; cv=none; b=EFnFX5rfcgCBunB5fFg/8txpqiRm9TTdLWD3FEvZsQdxBPxJTAVuwaONmla/7S2QCE1hOVh8OyrMSpq06QW4bd9zZtHMsd00i3lhGkNE2NOUa8RnlLkHmbAJvxstcsNZ/JT3eaR0rKBM4KBRzDGgNX7xjq2B4K+zYc+Ctqvksd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755638448; c=relaxed/simple;
	bh=rGvEBtJAcQgmmtoOBapVl91qpZyTBvI9ZBHEzh4M9Ow=;
	h=Date:To:From:Subject:Message-Id; b=eZIgQnGnP47PVqFOgPP7vW/PGJl5sFcarKs5YOwjQuMMm26dJPWTy+ptOUFSse47YnLpaT1vdWflOqAcJraCLTPRQRtIhU80279Eo4j6rjm7JPNZaPDWyJwFDcx8o7+xpphjoe3mHpf6mVlLCq08lcdhTSrWZwKKP7hPKixAmFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z/lPOtLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z/lPOtLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E1FC4CEF1;
	Tue, 19 Aug 2025 21:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755638447;
	bh=rGvEBtJAcQgmmtoOBapVl91qpZyTBvI9ZBHEzh4M9Ow=;
	h=Date:To:From:Subject:From;
	b=Z/lPOtLobZlxMs++3jePEJhnKHGVdxVEGB4caRaNUhixl7oVIgNj0RV9aDsOpjQfJ
	 ewTeDhHPUg/hNDuiN+WYx8vbnNCRa3hdC/94irT8huBWfQtU6wXhdgIj7Y2QizS1Ag
	 3lm4VUAJNO0x5fzSPwnx6bJxKreiS3hneP/qOd4k=
Date: Tue, 19 Aug 2025 14:20:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch added to mm-hotfixes-unstable branch
Message-Id: <20250819212047.84E1FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: set quota->charged_from to jiffies at first charge window
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch

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
Subject: mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Wed, 20 Aug 2025 00:01:23 +0900

Kernel initializes "jiffies" timer as 5 minutes below zero, as shown in
include/linux/jiffies.h

/*
 * Have the 32 bit jiffies value wrap 5 minutes after boot
 * so jiffies wrap bugs show up earlier.
 */
 #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))

And they cast unsigned value to signed to cover wraparound

 #define time_after_eq(a,b) \
  (typecheck(unsigned long, a) && \
  typecheck(unsigned long, b) && \
  ((long)((a) - (b)) >= 0))

In 64bit systems, these might not be a problem because wrapround occurs
300 million years after the boot, assuming HZ value is 1000.

With same assuming, In 32bit system, wraparound occurs 5 minutues after
the initial boot and every 49 days after the first wraparound.  And about
25 days after first wraparound, it continues quota charging window up to
next 25 days.

Example 1: initial boot
jiffies=0xFFFB6C20, charged_from+interval=0x000003E8
time_after_eq(jiffies, charged_from+interval)=(long)0xFFFB6838; In
signed values, it is considered negative so it is false.

Example 2: after about 25 days first wraparound
jiffies=0x800004E8, charged_from+interval=0x000003E8
time_after_eq(jiffies, charged_from+interval)=(long)0x80000100; In
signed values, it is considered negative so it is false

So, change quota->charged_from to jiffies at damos_adjust_quota() when
it is consider first charge window.

In theory; but almost impossible; quota->total_charged_sz and
qutoa->charged_from should be both zero even if it is not in first
charge window. But It will only delay one reset_interval, So it is not
big problem.

Link: https://lkml.kernel.org/r/20250819150123.1532458-1-ekffu200098@gmail.com
Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control")	[5.16]
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window
+++ a/mm/damon/core.c
@@ -2111,6 +2111,10 @@ static void damos_adjust_quota(struct da
 	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
 		return;
 
+	/* First charge window */
+	if (!quota->total_charged_sz && !quota->charged_from)
+		quota->charged_from = jiffies;
+
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-core-fix-commit_ops_filters-by-using-correct-nth-function.patch
selftests-damon-fix-selftests-by-installing-drgn-related-script.patch
mm-damon-core-fix-damos_commit_filter-not-changing-allow.patch
mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch
mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch
selftests-damon-test-no-op-commit-broke-damon-status.patch
selftests-damon-test-no-op-commit-broke-damon-status-fix.patch
mm-damon-tests-core-kunit-add-damos_commit_filter-test.patch

