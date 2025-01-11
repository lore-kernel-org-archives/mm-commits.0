Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CED49641
	for <mm-commits@vger.kernel.org>; Sat, 11 Jan 2025 02:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736564387; cv=none; b=flBBDdbHbDncG4JZ+3rRPr+PQfCSme8v/+Mt1xrFl4ygTjA7YjIpnZPiHbNyIrTI/pfXhPmdPd1f3aqzAx4AGcZgEkQwB+Ofo0kEPzRFf1l0mCFhyGotYesFifSlAB528bFDzk27fPqouOx4grBukW7Tc4aE2T+M3ZE2Vr1RwLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736564387; c=relaxed/simple;
	bh=Ze8MLiMdRnFbks7Miffunq/i9UnnNnknAFehEsLMqKo=;
	h=Date:To:From:Subject:Message-Id; b=fbXsAXmrDclAJisa3vZXv/0D3bweFmbw/+uUcwjbKQ5nD8tx38iYOU/KnVEMDm0K1Bz4FUn1Ks4LyEdOrgOECTmI/po/7XcxVg2IYP296NK+VigzqcO+ow0pvSNZkBlk1ZXMT37xzPFlJpyRCnSgOZU5Gilk4B82eXLqBP1sA84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A/hoLtXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A/hoLtXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED72BC4CED6;
	Sat, 11 Jan 2025 02:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736564387;
	bh=Ze8MLiMdRnFbks7Miffunq/i9UnnNnknAFehEsLMqKo=;
	h=Date:To:From:Subject:From;
	b=A/hoLtXoR2zgOxPHsoj+6B7vF38gSacxZEFOfJrlCzGcsu4S9RY48YdYpXZyUbHLH
	 jQ35g7AL0T0Cl8QzVHEGUVi1yYQtC9GuSnHfbEPWOOIAwQ7sKqNUcyMaFOVTtFMcpt
	 0P2EFm6yRbcUvH1211lEtYYwx4ARnvuYBaoHPZF4=
Date: Fri, 10 Jan 2025 18:59:46 -0800
To: mm-commits@vger.kernel.org,kaiyang2@cs.cmu.edu,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20250111025946.ED72BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2.patch

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
Subject: mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2
Date: Sat, 11 Jan 2025 09:52:53 +0800

introduce local nr_demoted to fix nr_reclaimed double counting

Link: https://lkml.kernel.org/r/20250111015253.425693-1-lizhijian@fujitsu.com
Fixes: f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA balancing operations")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Cc: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2
+++ a/mm/vmscan.c
@@ -1053,7 +1053,7 @@ static unsigned int shrink_folio_list(st
 	struct folio_batch free_folios;
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(demote_folios);
-	unsigned int nr_reclaimed = 0;
+	unsigned int nr_reclaimed = 0, nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
 	struct swap_iocb *plug = NULL;
@@ -1522,8 +1522,9 @@ keep:
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */
-	stat->nr_demoted += demote_folio_list(&demote_folios, pgdat);
-	nr_reclaimed += stat->nr_demoted;
+	nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_reclaimed += nr_demoted;
+	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
 		/* Folios which weren't demoted go back on @folio_list */
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are

mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics.patch
mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2.patch
mm-vmscan-fix-pgdemote_-accounting-with-lru_gen_enabled.patch
selftests-mm-add-a-few-missing-gitignore-files.patch

