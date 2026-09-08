Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DE2356766;
	Tue,  8 Sep 2026 19:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788894019; cv=none; b=iRsj4oeMMhW3Al402NUGe0D/cLR/gIxdJHtF8M6YbdhvNOvT3s16J1Z3t4A5kRDwHxW7c3RAgpkCNkFXyPu808TS86RGagsN0TBC/lLIW09WQoU/X1Uqrp1X1vY+d7cV88Z2v+RqZHw1xjM08u27jiuL1A9zUMb664TDARqYDFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788894019; c=relaxed/simple;
	bh=TkMUznrXurED6ouL2kpIGcGJ6tGr5yarQgd2lU0tR0Q=;
	h=Date:To:From:Subject:Message-Id; b=dt+LLW6aF03++wEON5EQhci3q/bfKs0oSfELalg5Ko9usD6/ynXbbBk7EFRXGjAFI/qeY7J34lP2ggzOjbsIDOJ+uLgiUciASs9yZt3lwJRchRquIJW20XPAA4/RlHtrF82Eje3m1DQWTIA0qdNmnGJdRO6KvqLmA7z/6bFaTXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tdu/efGa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tdu/efGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34C11F00A3F;
	Tue,  8 Sep 2026 19:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788894017;
	bh=btL9acUu57VC72oDspwZpJDiNzFfNPHfnyRiBllBNvY=;
	h=Date:To:From:Subject;
	b=Tdu/efGapWXcAUedOk4nJnGegLbPoX83HtbhUf0XVclt9Mqj0jZPYmjNQYGUjdl7K
	 /h3pyXtqYZhcaey2G5FIG7amiMloAhCVQ840FVKlM2dfyG7DJEgNaYxhGhX88jdlYe
	 qaqprgjMl7Gi2dmUwSetc7oOHJ+5JrKbjOyGo0vs=
Date: Tue, 08 Sep 2026 12:00:17 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-unconditionally-skip-last-region.patch added to mm-hotfixes-unstable branch
Message-Id: <20260908190017.D34C11F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: fix unconditionally skip last region
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-fix-unconditionally-skip-last-region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-unconditionally-skip-last-region.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: mm/damon/core: fix unconditionally skip last region
Date: Tue, 8 Sep 2026 06:47:38 -0700

Once quota set, the charge_{target,addr}_from unconditionally skips and
resets at the last region of the tracked target, so the last region can be
skipped even when it has not been processed.

Example:

    1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
    2. Quota is configured to process only 100 bytes per window.
    3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
       addr}_from is saved at (Target, 100).
    4. Window 2: The loop reaches R2.  Because R2 is
       damon_last_region(t), the old code unconditionally returns true,
       skipping R2 entirely and resetting the charge_{target,addr}_from.

    Result: R2 is permanently skipped even though it has never been
    processed.

However, it is important to note that this is a very minor issue.  This is
because it is triggered only when the previous window saved/kept
charge_{target,addr}_from, and in the next window, all regions except the
last region were skipped by damos_skip_charged_region().

Fix this by only resetting the charge_{target,addr}_from when last region
is reached, only skipping when it is applied or cannot split.

Link: https://lore.kernel.org/20260908134739.96919-1-sj@kernel.org
Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # v5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-fix-unconditionally-skip-last-region
+++ a/mm/damon/core.c
@@ -2342,36 +2342,39 @@ static bool damos_skip_charged_region(st
 {
 	struct damos_quota *quota = &s->quota;
 	unsigned long sz_to_skip;
+	bool skip = false;
 
 	/* Skip previously charged regions */
 	if (quota->charge_target_from) {
 		if (t != quota->charge_target_from)
 			return true;
-		if (r == damon_last_region(t)) {
-			quota->charge_target_from = NULL;
-			quota->charge_addr_from = 0;
-			return true;
-		}
 		if (quota->charge_addr_from &&
-				r->ar.end <= quota->charge_addr_from)
-			return true;
+				r->ar.end <= quota->charge_addr_from) {
+			skip = true;
+			goto out;
+		}
 
 		if (quota->charge_addr_from && r->ar.start <
 				quota->charge_addr_from) {
 			sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
 					r->ar.start, min_region_sz);
 			if (!sz_to_skip) {
-				if (damon_sz_region(r) <= min_region_sz)
-					return true;
+				if (damon_sz_region(r) <= min_region_sz) {
+					skip = true;
+					goto out;
+				}
 				sz_to_skip = min_region_sz;
 			}
 			damon_split_region_at(t, r, sz_to_skip);
-			return true;
+			skip = true;
 		}
+	}
+out:
+	if (r == damon_last_region(t)) {
 		quota->charge_target_from = NULL;
 		quota->charge_addr_from = 0;
 	}
-	return false;
+	return skip;
 }
 
 static void damos_update_stat(struct damos *s,
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

mm-damon-core-allow-esz-to-be-set-to-zero.patch
mm-damon-core-fix-unconditionally-skip-last-region.patch
docs-mm-damon-design-accurate-semantics-of-nr_snapshots.patch
docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots.patch
docs-mm-damon-design-fix-typo-of-max_nr_snapshots.patch

