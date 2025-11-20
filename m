Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95022F83CF
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675120; cv=none; b=TJULVYy1ThARsBFm19GmMU/dgT7IbbkmWMRloJBFyrU0odhedJ+wJH4jA9iNUCQPgnQedgQxNPkC19XjxN/knjhAiOmBNoSR9OIe/nsYJRxBG1b0wmexL7nQ5exBH9nmu69llrlGbH/gavV5RmzX1yb0gZgT9FaXWSsXvS7Ozl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675120; c=relaxed/simple;
	bh=Q2obbyiW7doiipxulOFVg8Cpbj339bF2IEN7A+7LxrA=;
	h=Date:To:From:Subject:Message-Id; b=tE0p2dYMMhtOqcDzAOuhqF23QbU/xVPaERMvUoqoEObBvK4DB9qhTS9WfDocd2EWlkA9uwf+JVzdP+R7fC2avV+OFpM8LTna1A05tbLz6G6mazCz+y5wGd6lyy3v9ZK2kH3bigz0jXCMhfjLwZ84D0URkPbnwbhD0ukd5hDmHwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NP5KDvkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NP5KDvkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD665C4CEF1;
	Thu, 20 Nov 2025 21:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675120;
	bh=Q2obbyiW7doiipxulOFVg8Cpbj339bF2IEN7A+7LxrA=;
	h=Date:To:From:Subject:From;
	b=NP5KDvkMREDVn9AiHgSfm0pUOeCarJbOJEfMIbX+HF9trZg8t6x2WYLynloqyn4H5
	 5saOxBnpCDzkbRmxJLNUWPcEGFZeZYVpQ2HjFqioeWrw8LPbgVx0w8eoxZZZOFrP5N
	 7beveTqaQChLqfqU6ZgX56VWDKJnRu/ce5bvqNBI=
Date: Thu, 20 Nov 2025 13:45:20 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,lkp@intel.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch removed from -mm tree
Message-Id: <20251120214520.AD665C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: cleanup using pmd_trans_huge_lock()
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: cleanup using pmd_trans_huge_lock()
Date: Wed, 12 Nov 2025 07:41:06 -0800

Three pmd walk functions in vaddr.c are using pmd_trans_huge() and
pmd_lock() to handle THPs.  Simplify the code by replacing the two
function calls with a single pmd_trans_huge_lock() call.

Note that this cleanup is not only reducing the lines of code, but also
simplifies code execution flows for migration entries case, as kindly
explained [1] by Hugh, who suggested this cleanup.

[sj@kernel.org: provide lvalue to pmd_present()]
  Link: https://lkml.kernel.org/r/20251117154415.11041-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251112154114.66053-4-sj@kernel.org
Link: https://lore.kernel.org/296c2b3f-6748-158f-b85d-2952165c0588@google.com [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Suggested-by: Hugh Dickins <hughd@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   48 ++++++++++++---------------------------------
 1 file changed, 13 insertions(+), 35 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock
+++ a/mm/damon/vaddr.c
@@ -307,24 +307,16 @@ static int damon_mkold_pmd_entry(pmd_t *
 		unsigned long next, struct mm_walk *walk)
 {
 	pte_t *pte;
-	pmd_t pmde;
 	spinlock_t *ptl;
 
-	if (pmd_trans_huge(pmdp_get(pmd))) {
-		ptl = pmd_lock(walk->mm, pmd);
-		pmde = pmdp_get(pmd);
-
-		if (!pmd_present(pmde)) {
-			spin_unlock(ptl);
-			return 0;
-		}
+	ptl = pmd_trans_huge_lock(pmd, walk->vma);
+	if (ptl) {
+		pmd_t pmde = pmdp_get(pmd);
 
-		if (pmd_trans_huge(pmde)) {
+		if (pmd_present(pmde))
 			damon_pmdp_mkold(pmd, walk->vma, addr);
-			spin_unlock(ptl);
-			return 0;
-		}
 		spin_unlock(ptl);
+		return 0;
 	}
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
@@ -446,21 +438,12 @@ static int damon_young_pmd_entry(pmd_t *
 	struct damon_young_walk_private *priv = walk->private;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pmd_trans_huge(pmdp_get(pmd))) {
-		pmd_t pmde;
-
-		ptl = pmd_lock(walk->mm, pmd);
-		pmde = pmdp_get(pmd);
+	ptl = pmd_trans_huge_lock(pmd, walk->vma);
+	if (ptl) {
+		pmd_t pmde = pmdp_get(pmd);
 
-		if (!pmd_present(pmde)) {
-			spin_unlock(ptl);
-			return 0;
-		}
-
-		if (!pmd_trans_huge(pmde)) {
-			spin_unlock(ptl);
-			goto regular_page;
-		}
+		if (!pmd_present(pmde))
+			goto huge_out;
 		folio = damon_get_folio(pmd_pfn(pmde));
 		if (!folio)
 			goto huge_out;
@@ -474,8 +457,6 @@ huge_out:
 		spin_unlock(ptl);
 		return 0;
 	}
-
-regular_page:
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
@@ -910,13 +891,10 @@ static int damos_va_stat_pmd_entry(pmd_t
 	int nr;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pmd_trans_huge(*pmd)) {
-		pmd_t pmde;
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
+		pmd_t pmde = pmdp_get(pmd);
 
-		ptl = pmd_trans_huge_lock(pmd, vma);
-		if (!ptl)
-			return 0;
-		pmde = pmdp_get(pmd);
 		if (!pmd_present(pmde))
 			goto huge_unlock;
 
_

Patches currently in -mm which might be from sj@kernel.org are


