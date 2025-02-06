Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08938224AFB
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738828653; cv=none; b=Yw7nIbb0d5XO29ZdBorVRvvWztBRmPeJHvp99oDTzXHtqsVObcUubG5z+70Mlp6lf7iANBsmE3iJSmQFKcs0sfKXG3RRh2Tff/SfpPy8+ETz+jtuPhBeq7mEFNTA3hf8VSt5kCri3tH77xFK5KXHEUcuULuNRVQCnGx3xdHBaFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738828653; c=relaxed/simple;
	bh=iKbNqm0jWb0Q+mAXXDlReROUx2ruj743W7VLs13O000=;
	h=Date:To:From:Subject:Message-Id; b=DriYSdIK/pbBuH3zMs8BchIzWTB9eW21xlb0dMmblApnDbGvhkfO0AAH+XKkKZ/RzfBAKvyyw0cOvef5TtvUagD1uTsCjSpL5aqSV8myk+aQMi8lt1CWkuy2jvCsWqGARo25F0CYpd+6TkilBOHWyS/IULbNZipHercwCTYUW2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ro1wRCTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ro1wRCTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04F7C4CEDD;
	Thu,  6 Feb 2025 07:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738828652;
	bh=iKbNqm0jWb0Q+mAXXDlReROUx2ruj743W7VLs13O000=;
	h=Date:To:From:Subject:From;
	b=Ro1wRCTuM1u1a+IgOEuO8JCJ+z3/Jm47pbzT0wECoaYXvpamIc1i6n4GloF+DObxs
	 213hXeS/a/BWW+n7dTM9Z5E8Kmnl8oP9WKL2o+/XM/0N60gFPasObMXbcSdexm9ZYE
	 lD6q9+4LQn7wIJNglgRyA95zBauP1yVNS/jdHYBw=
Date: Wed, 05 Feb 2025 23:57:32 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch added to mm-unstable branch
Message-Id: <20250206075732.B04F7C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: skip scanning cluster range if it's empty cluster
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/swap: skip scanning cluster range if it's empty cluster
Date: Wed, 5 Feb 2025 17:27:13 +0800

Since ci->lock has been taken when isolating cluster from
si->free_clusters or taking si->percpu_cluster->next[order], it's
unnecessary to scan and check the cluster range availability if i'ts empty
cluster, and this can accelerate the huge page swapping.

Link: https://lkml.kernel.org/r/20250205092721.9395-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/swapfile.c~mm-swap-skip-scanning-cluster-range-if-its-empty-cluster
+++ a/mm/swapfile.c
@@ -729,6 +729,9 @@ static bool cluster_scan_range(struct sw
 	unsigned long offset, end = start + nr_pages;
 	unsigned char *map = si->swap_map;
 
+	if (cluster_is_empty(ci))
+		return true;
+
 	for (offset = start; offset < end; offset++) {
 		switch (READ_ONCE(map[offset])) {
 		case 0:
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-swap_statec-fix-the-obsolete-code-comment.patch
mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch
mm-swap-remove-swap_flag_prio_shift.patch
mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch
mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch
mm-swapfilec-update-the-code-comment-above-swap_count_continued.patch
mm-swapfilec-optimize-code-in-setup_clusters.patch
mm-swap_statec-remove-the-meaningless-code-comment.patch
mm-swapfilec-remove-the-unneeded-checking.patch
mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch
mm-swapfilec-remove-the-incorrect-code-comment.patch
mm-swapfilec-open-code-cluster_alloc_swap.patch

