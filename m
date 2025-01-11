Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEA7184E;
	Sat, 11 Jan 2025 00:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555101; cv=none; b=qMOroiTZCZsfSAWOkmLX7mOJduit6GS2lR02dG3kGGNTZcjpWSOSBRVS7+uvqIGzZsfeXVSfQt4xNAj76i/1WnG5KDkiv7EfIRqZ2HyUadR1Uq/ez/swel05U5CPG4d2iPdAq8R1U5Cdhq4VhFW6h7BXrgsIPd/7tGp5ScC70XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555101; c=relaxed/simple;
	bh=0J4+ZIurLjKBNvL57IUNrOJ6tDSnoI7G0yCSannrP2M=;
	h=Date:To:From:Subject:Message-Id; b=mCgOddApwwmluaqHijUgDoSt5T2rqIB3qPokcz4eQq3UnEimO8+55Kxp+GGbQuiQAearQC4RAEr8z6mdwK3Cj9x6BW87HehYGMDCWgquOBZ/RhohuYSLr+Iwd3wf1iz+oxeDGtqCml8nz4CiDcat75/Wz6tC/ijjfJj+fJxmQoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aRMzx8ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aRMzx8ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF30C4CED6;
	Sat, 11 Jan 2025 00:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736555100;
	bh=0J4+ZIurLjKBNvL57IUNrOJ6tDSnoI7G0yCSannrP2M=;
	h=Date:To:From:Subject:From;
	b=aRMzx8adzuMg8fdX8r0I9jno4YyqYwAivUHE67PTJKkWeiJaiakMvowMZ1tyRpG5k
	 yw1+u7dFiZyychULa/Ddykgw2MdnxxKbqKI6ig1RzJ94jii4T/58THdD90721m9IWj
	 wKAFc0aSRkBeYSoxdiV9IJV5QQtbpUPAx/dDd534=
Date: Fri, 10 Jan 2025 16:25:00 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kaiyang2@cs.cmu.edu,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics.patch added to mm-hotfixes-unstable branch
Message-Id: <20250111002500.9DF30C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: accumulate nr_demoted for accurate demotion statistics
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics.patch

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
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm/vmscan: accumulate nr_demoted for accurate demotion statistics
Date: Fri, 10 Jan 2025 20:21:32 +0800

In shrink_folio_list(), demote_folio_list() can be called multiple times,
which can lead to inaccurate demotion statistics if the number of demoted
pages is not accumulated correctly.

Accumulate the nr_demoted count across multiple calls to
demote_folio_list(), ensuring accurate reporting of demotion statistics.

Link: https://lkml.kernel.org/r/20250110122133.423481-1-lizhijian@fujitsu.com
Fixes: f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA balancing operations")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Acked-by: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics
+++ a/mm/vmscan.c
@@ -1522,7 +1522,7 @@ keep:
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */
-	stat->nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	stat->nr_demoted += demote_folio_list(&demote_folios, pgdat);
 	nr_reclaimed += stat->nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are

mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics.patch
selftests-mm-add-a-few-missing-gitignore-files.patch

