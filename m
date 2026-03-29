Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AA410F2
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744822; cv=none; b=FQN1LzB86LouVr1s2Xm+cqaPLdRBhVQK1qrHplNMkojEiNqobDhnuO/uS7xw79arNiUghhVRqvW3xVjR7AGfVh6hoxPBpWlNkvqQo+unOrOf02diHaNFN3ZcJQxEpaeJlOItV2nYWCEDtSW2n+Vs03EDMRVp/UNsYjO8fVnmi+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744822; c=relaxed/simple;
	bh=2Frz3eAZbZcGI/fTE9+6HjI8xAR+SDmhm+qsOVI3SVY=;
	h=Date:To:From:Subject:Message-Id; b=CtK9gcuh/ASEIk+0Iwe6hhltxj76cqIc7DUDseaz1wqTS5pADa7LY8GM6Pb9d1q3C7kWDVzgY9ABMKuxKqKoN5hhDtgZQYpXgu+tNNXfk42VQoJyjjuwQUEmN78/r3gHOeR3yYpehxVtdxhQZwfPqdTcXjURkcFPDTDBbWCiFIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BCvebEs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BCvebEs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108BFC4CEF7;
	Sun, 29 Mar 2026 00:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744822;
	bh=2Frz3eAZbZcGI/fTE9+6HjI8xAR+SDmhm+qsOVI3SVY=;
	h=Date:To:From:Subject:From;
	b=BCvebEs/Mwx0MTs9QDJRnZUeuvEVWAGVHvQNF7Nu1S233MOyc09kcVMCHD8mdow1n
	 iSHGiu9FQwwpSeLVX4LO3lIP0737BeK3PqxtNimuNPIA3XDWb9hDn3RJcKcK9JE7A6
	 fhnn01oldHXcinGEU7W9QXJ6OF89RGFJRfWC7I+c=
Date: Sat, 28 Mar 2026 17:40:21 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch removed from -mm tree
Message-Id: <20260329004022.108BFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: add damon_merge_two_regions() debug_sanity check
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add damon_merge_two_regions() debug_sanity check
Date: Fri, 6 Mar 2026 07:29:08 -0800

A data corruption could cause damon_merge_two_regions() creating zero
length DAMON regions.  Add a sanity check for that under
CONFIG_DAMON_DEBUG_SANITY.

Link: https://lkml.kernel.org/r/20260306152914.86303-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-add-damon_merge_two_regions-debug_sanity-check
+++ a/mm/damon/core.c
@@ -2475,6 +2475,21 @@ static void kdamond_apply_schemes(struct
 	mutex_unlock(&c->walk_control_lock);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_merge_two_regions(
+		struct damon_region *l, struct damon_region *r)
+{
+	/* damon_merge_two_regions() may created incorrect left region */
+	WARN_ONCE(l->ar.start >= l->ar.end, "l: %lu-%lu, r: %lu-%lu\n",
+			l->ar.start, l->ar.end, r->ar.start, r->ar.end);
+}
+#else
+static void damon_verify_merge_two_regions(
+		struct damon_region *l, struct damon_region *r)
+{
+}
+#endif
+
 /*
  * Merge two adjacent regions into one region
  */
@@ -2488,6 +2503,7 @@ static void damon_merge_two_regions(stru
 	l->nr_accesses_bp = l->nr_accesses * 10000;
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
+	damon_verify_merge_two_regions(l, r);
 	damon_destroy_region(r, t);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

