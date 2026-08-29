Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFE1187346
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 22:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788042014; cv=none; b=JfRB6t33rdKcxIf9Sy8ErCGVtK3vnDIVFyTci0dbOBnwDVsD2xJ7RxO/hxB5KExW79T0QF3+688ExIvrrAiHIbX/pNMMmwYFz134F+8AozOaJ7KFGdP3CLRIxBQizrJDPaxNC+uGG5oPaKau4rLnAipNeHeDB9sDssZMbwa7IHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788042014; c=relaxed/simple;
	bh=Daz2naO/qTCtXn980oYVQ91v1sQ7V6nQiyOa2qPUaS4=;
	h=Date:To:From:Subject:Message-Id; b=HCnfgliCQap+TrRZpj/i/wvBDbHTUJ9ud9wRkCsJDuoDsc8f0whXdWMUH+2/DYwW57rU1C/82DFMLKFeQQq52WjIeWNDxY8ajURuGP+v6LEDRFW7quDLjAFMnX2MNT9bMgXF47eP6XlneuDh88hnI0Mf7QWGaLwG4/a87fHLrIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NoXk0ezD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NoXk0ezD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75F11F000E9;
	Sat, 29 Aug 2026 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788042013;
	bh=W4qp7ovRzaGqLWO500rI6ULTgg4nsI2GvCRIdmgEea8=;
	h=Date:To:From:Subject;
	b=NoXk0ezDYKgzZqx3IjUuTnjkChCWY+E24Z2jsIJcT2ejsTqP6HyL18IGAFW+4aNwz
	 19rkijcB5bN8Kmt7/81lra5D4Xh07+VsXVuLp52kRpEZsLxnbiddgdyIuVao99Epok
	 nq76Sb8h3DtTvVKStCaXWo0j/ASgWGhmb35u6KF4=
Date: Sat, 29 Aug 2026 15:20:12 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-make-type-fallback-logic-explicit-in-isolate_folios.patch added to mm-new branch
Message-Id: <20260829222012.E75F11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: make type fallback logic explicit in isolate_folios()
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-make-type-fallback-logic-explicit-in-isolate_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-make-type-fallback-logic-explicit-in-isolate_folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm/mglru: make type fallback logic explicit in isolate_folios()
Date: Sat, 29 Aug 2026 15:42:03 +0800

Patch series "mm/mglru: clean up isolate_folios for readability and
clarity", v2.

Right now, isolate_folios() is quite difficult to follow:

1. It uses for_each_evictable_type(i, swappiness) to iterate over
   the types, but 'i' is not actually used as the type within the
   loop body.

2. It retries the same type when folios were scanned but none could
   be isolated, but the retry is implemented in a rather subtle way
   that is difficult to understand.

This patchset makes both behaviors explicit and much easier to follow.

There are no functional changes for swappiness values from 1 to 200. 
There is a slight functional change for 0 and 201: with the existing code,
there is no chance to retry for these values because
for_each_evictable_type() only iterates once.  After this patch, 0 and 201
have behavior that is more consistent with the 1-200 range.


This patch (of 2):

The for_each_evictable_type() loop in isolate_folios() is misleading: it
does not actually iterate over each evictable type.  Instead,
get_type_to_scan() selects the type to scan, while the iterator `i` merely
bounds the number of attempts.

Make the fallback behavior explicit in the code and remove the opaque
for_each_evictable_type(i, swappiness).

Link: https://lore.kernel.org/20260829074204.45304-1-baohua@kernel.org
Link: https://lore.kernel.org/20260829074204.45304-2-baohua@kernel.org
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   50 ++++++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

--- a/mm/vmscan.c~mm-mglru-make-type-fallback-logic-explicit-in-isolate_folios
+++ a/mm/vmscan.c
@@ -4829,35 +4829,41 @@ static int get_type_to_scan(struct lruve
 	return positive_ctrl_err(&sp, &pv);
 }
 
+static inline bool is_single_type_reclaim(int swappiness)
+{
+	return swappiness == MIN_SWAPPINESS ||
+	       swappiness == SWAPPINESS_ANON_ONLY;
+}
+
 static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			  struct scan_control *sc, int swappiness,
 			  struct list_head *list, int *isolated,
 			  int *isolate_type, int *isolate_scanned)
 {
-	int i;
-	int total_scanned = 0;
+	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
 	int type = get_type_to_scan(lruvec, swappiness);
+	int total_scanned = 0, scanned, tier;
+
+retry:
+	tier = get_tier_idx(lruvec, type);
+	scanned = scan_folios(nr_to_scan, lruvec, sc,
+			      type, tier, list, isolated);
+
+	total_scanned += scanned;
+	if (*isolated) {
+		*isolate_type = type;
+		*isolate_scanned = scanned;
+		return total_scanned;
+	}
 
-	for_each_evictable_type(i, swappiness) {
-		int scanned;
-		int tier = get_tier_idx(lruvec, type);
-
-		scanned = scan_folios(nr_to_scan, lruvec, sc,
-				      type, tier, list, isolated);
-
-		total_scanned += scanned;
-		if (*isolated) {
-			*isolate_type = type;
-			*isolate_scanned = scanned;
-			break;
-		}
-		/*
-		 * If scanned > 0 and isolated == 0, avoid falling back to the
-		 * other type, as this type remains sufficient. Falling back
-		 * too readily can disrupt the positive_ctrl_err() bias.
-		 */
-		if (!scanned)
-			type = !type;
+	/*
+	 * We are running out of the current reclaim type. Fall back to
+	 * the other type if allowed.
+	 */
+	if (!scanned && type_fallback_allowed) {
+		type = !type;
+		type_fallback_allowed = false;
+		goto retry;
 	}
 
 	return total_scanned;
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-vmscan-drop-the-combined-limit-gate-in-__node_reclaim.patch
mm-mglru-preserve-inactive-placement-when-enabling-mglru.patch
mm-mglru-make-type-fallback-logic-explicit-in-isolate_folios.patch

