Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D62CD26D
	for <mm-commits@vger.kernel.org>; Thu,  5 Dec 2024 04:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733373864; cv=none; b=N+qYSyto5KVpaZPmNzmuvNLYTfghko1K3dOWrHwa9NxWoPbaBgz9Q3odfndbaZdviSA99vCqjAuDOy79P0xJQH4AIDPZR64OANsecQs4ABgFRyFprlBJw19mxOmKIkFb0PzUVgOvETpmtA+Crc8nIp2i/VHPKb0pKxhljZxM860=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733373864; c=relaxed/simple;
	bh=D1AxQ5iSoSO5ietvcknjWCkvxt3lDsy5tUunXue9HE8=;
	h=Date:To:From:Subject:Message-Id; b=mw96ueoLNNTh2ccgspnhTDn8S+DFF+eNQVhwV2R7yBjQeQvUhVIbAcNr0unIyoGm9FHqvWcfpe3GOnDBEN+OdQpDrMyrZ2F0JHy1lUGfcW6YQUjShJpAzcnhoIqS1OnLZTyzi/xr1pl7I1XK8ZK34nqjN6EQbeF12R7Stw0oN2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XGduRyDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XGduRyDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C628AC4CED6;
	Thu,  5 Dec 2024 04:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733373863;
	bh=D1AxQ5iSoSO5ietvcknjWCkvxt3lDsy5tUunXue9HE8=;
	h=Date:To:From:Subject:From;
	b=XGduRyDCNo2wYL5xp49hhGHexH9bRbtKOOEm8f6OMgiR2FywclsKUA2IadhD8zUYg
	 TyS5n8W+GQfTC+qBSW1+iWHJ1GZNNdiaSmB7KKusZTFmr0bYaP77LARIlB93+atIy1
	 oegKTcTN1PXJWhZOUivYYnSepGz0DdRTkzcPmR+o=
Date: Wed, 04 Dec 2024 20:44:23 -0800
To: mm-commits@vger.kernel.org,stevensd@chromium.org,kasong@tencent.com,kaleshsingh@google.com,bharata@amd.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-clean-up-workingset.patch added to mm-unstable branch
Message-Id: <20241205044423.C628AC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: clean up workingset
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-clean-up-workingset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-clean-up-workingset.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: clean up workingset
Date: Sun, 1 Dec 2024 20:28:18 -0700

Patch series "mm/mglru: performance optimizations".

This series improves performance for some previously discussed test cases.
Most of the code changes gathered here has been floating on the mailing
list [1][2].  They are now properly organized and have gone through
various benchmarks on both client and server devices, including Android,
FIO, memcached, multiple VMs and MongoDB.

[1] https://lore.kernel.org/CAOUHufahuWcKf5f1Sg3emnqX+cODuR=2TQo7T4Gr-QYLujn4RA@mail.gmail.com/
[2] https://lore.kernel.org/CAOUHufawNerxqLm7L9Yywp3HJFiYVrYO26ePUb1jH-qxNGWzyA@mail.gmail.com/


This patch (of 6):

Move VM_BUG_ON_FOLIO() to cover both the default and MGLRU paths.  Also
use a pair of rcu_read_lock() and rcu_read_unlock() within each path, to
improve readability.

This change should not have any side effects.

Link: https://lkml.kernel.org/r/20241202032823.2741019-1-yuzhao@google.com
Link: https://lkml.kernel.org/r/20241202032823.2741019-2-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Tested-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: David Stevens <stevensd@chromium.org>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/mm/workingset.c~mm-mglru-clean-up-workingset
+++ a/mm/workingset.c
@@ -428,17 +428,17 @@ bool workingset_test_recent(void *shadow
 	struct pglist_data *pgdat;
 	unsigned long eviction;
 
-	rcu_read_lock();
-
 	if (lru_gen_enabled()) {
-		bool recent = lru_gen_test_recent(shadow, file,
-				&eviction_lruvec, &eviction, workingset);
+		bool recent;
 
+		rcu_read_lock();
+		recent = lru_gen_test_recent(shadow, file, &eviction_lruvec,
+					     &eviction, workingset);
 		rcu_read_unlock();
 		return recent;
 	}
 
-
+	rcu_read_lock();
 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, workingset);
 	eviction <<= bucket_order;
 
@@ -459,14 +459,12 @@ bool workingset_test_recent(void *shadow
 	 * configurations instead.
 	 */
 	eviction_memcg = mem_cgroup_from_id(memcgid);
-	if (!mem_cgroup_disabled() &&
-	    (!eviction_memcg || !mem_cgroup_tryget(eviction_memcg))) {
-		rcu_read_unlock();
-		return false;
-	}
-
+	if (!mem_cgroup_tryget(eviction_memcg))
+		eviction_memcg = NULL;
 	rcu_read_unlock();
 
+	if (!mem_cgroup_disabled() && !eviction_memcg)
+		return false;
 	/*
 	 * Flush stats (and potentially sleep) outside the RCU read section.
 	 *
@@ -544,6 +542,8 @@ void workingset_refault(struct folio *fo
 	bool workingset;
 	long nr;
 
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+
 	if (lru_gen_enabled()) {
 		lru_gen_refault(folio, shadow);
 		return;
@@ -558,7 +558,6 @@ void workingset_refault(struct folio *fo
 	 * is actually experiencing the refault event. Make sure the folio is
 	 * locked to guarantee folio_memcg() stability throughout.
 	 */
-	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	nr = folio_nr_pages(folio);
 	memcg = folio_memcg(folio);
 	pgdat = folio_pgdat(folio);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-mglru-clean-up-workingset.patch
mm-mglru-optimize-deactivation.patch
mm-mglru-rework-aging-feedback.patch
mm-mglru-rework-type-selection.patch
mm-mglru-rework-refault-detection.patch
mm-mglru-rework-workingset-protection.patch

