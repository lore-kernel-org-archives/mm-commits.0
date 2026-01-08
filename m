Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2D53A0B2D
	for <mm-commits@vger.kernel.org>; Thu,  8 Jan 2026 02:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767839820; cv=none; b=hq2cUJu9uFggFwsEpJIt6j80Nchdob4LcJQIQ7+HbK3EGYUngBriuYqsaAxayo/HMqGvGtMc8aYHw9DZ7hKTAdjZrEePb0AGM5AvzSPXWVtu/+oo3DqMS9iRtH5YHu7iz7iikijedLWXO13TMGviOvB/UY3FdwAgy2/FRcn+pOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767839820; c=relaxed/simple;
	bh=BkI+V1kd2aQ3vHdBqNjjXh7NMQGnwSBOi6s6opGpQTo=;
	h=Date:To:From:Subject:Message-Id; b=rZA8sELRD57E+XnoG4AmZygZAOhSDRpbSVDOFjVla54DjlV5GrPwtFsxl0KvEGH8Gm+PDPiG4fQcxejNpUdeiuL7oS9QAkxPjaZX0FpF8FWxrGA2cvAYysE9JSxFTf1KAu4coS7E2sO1ZKZwUao617KfECckeapcBEYBecZ2AHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P4MkWf9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P4MkWf9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480FDC4CEF1;
	Thu,  8 Jan 2026 02:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767839819;
	bh=BkI+V1kd2aQ3vHdBqNjjXh7NMQGnwSBOi6s6opGpQTo=;
	h=Date:To:From:Subject:From;
	b=P4MkWf9aJ7LNSzRy6S+TDiq2UCU/Y1/KMQotDHBG9WBF2W5qF5oqolk4yhShEaGS7
	 Z9zVrkgXrumwQm8ne9Uyxn7VvWsaHLG2yupalJyi5OpSB5pKFeE44v09ojzaxZzoNR
	 zkz+smk7XLgg7fJjL6VE2zyOq9KGg3lvfscbTh1M=
Date: Wed, 07 Jan 2026 18:36:58 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,yangqixiao@inspur.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-initialize-folio-variables-to-null-for-clarity.patch added to mm-new branch
Message-Id: <20260108023659.480FDC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: initialize 'folio' variables to NULL for clarity
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-initialize-folio-variables-to-null-for-clarity.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-initialize-folio-variables-to-null-for-clarity.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Aaron Yang <yangqixiao@inspur.com>
Subject: mm/damon/paddr: initialize 'folio' variables to NULL for clarity
Date: Wed, 7 Jan 2026 17:30:38 -0800

In damon_pa_mark_accessed_or_deactivate(), damon_pa_pageout(),
damon_pa_migrate(), and damon_pa_stat(), the local variable 'folio' is
declared but not initialized.

Initialize 'folio' to NULL to improve code readability and
maintainability.

Link: https://patch.msgid.link/20260104013255.16962-1-yangqixiao@inspur.com
Link: https://lkml.kernel.org/r/20260108013041.80601-1-sj@kernel.org
Signed-off-by: Aaron Yang <yangqixiao@inspur.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-initialize-folio-variables-to-null-for-clarity
+++ a/mm/damon/paddr.c
@@ -156,7 +156,7 @@ static unsigned long damon_pa_pageout(st
 	LIST_HEAD(folio_list);
 	bool install_young_filter = true;
 	struct damos_filter *filter;
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	/* check access in page level again by default */
 	damos_for_each_ops_filter(filter, s) {
@@ -212,7 +212,7 @@ static inline unsigned long damon_pa_mar
 		unsigned long *sz_filter_passed)
 {
 	phys_addr_t addr, applied = 0;
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
@@ -262,7 +262,7 @@ static unsigned long damon_pa_migrate(st
 {
 	phys_addr_t addr, applied;
 	LIST_HEAD(folio_list);
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
@@ -295,7 +295,7 @@ static unsigned long damon_pa_stat(struc
 		unsigned long *sz_filter_passed)
 {
 	phys_addr_t addr;
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	if (!damos_ops_has_filter(s))
 		return 0;
_

Patches currently in -mm which might be from yangqixiao@inspur.com are

mm-damon-paddr-initialize-folio-variables-to-null-for-clarity.patch

