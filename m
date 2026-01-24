Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE87B1EF09B
	for <mm-commits@vger.kernel.org>; Sat, 24 Jan 2026 01:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769217707; cv=none; b=SlehYWhGZcnKfGkbm5tHiqGTK2GL9lbs6fsIBDs2gnnxC8PScRjVDOIA6WjR+zvR9EEBI2tdAMDiiJLT+LDyhs7xcF3FlEFwYFC3AKwE2Qycyq2zoL0JNU5eAe8czkunNkFa+e97GY/fujc2rsE41gH2U9wJJxxT3IHmWUzeHwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769217707; c=relaxed/simple;
	bh=C1htxR9x7nUjBGegALY1q07OHv3HtM61Gw1HYH+c3BU=;
	h=Date:To:From:Subject:Message-Id; b=fH8xJcmZwgOJymjErZ9raAqoLJHsCpcUGhh4o+WVN3MaWp+7xYI7A+NQgZ4QTQGxEvjQ1Q9wA4+NuLqR3+s/92wEtXGyS/GZ2CqGyTw2svK7/WlTz3vq9PP+ASo3r9LI0pq1yq/j485KhJ596ocVdqFmN5kzhAF5lrZUnBnhFFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tqJ0NWrX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tqJ0NWrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3167C4CEF1;
	Sat, 24 Jan 2026 01:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769217706;
	bh=C1htxR9x7nUjBGegALY1q07OHv3HtM61Gw1HYH+c3BU=;
	h=Date:To:From:Subject:From;
	b=tqJ0NWrXVF32+sKEM2vN23hq2TYt2hBopA0A62jBdAOEqSkebnLl27FpVasrhRIN2
	 dpx6dfsew/tgxuY5Br+W7Yvs+iMVvXzxHw38u+uPllOgk113IjlAZnvwY0cgVaNysP
	 SUKareZYsUAlGbIaQ30MlT9z9tn5hBDc25zX9PjI=
Date: Fri, 23 Jan 2026 17:21:46 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-make-khugepaged_collapse_control-a-local.patch added to mm-unstable branch
Message-Id: <20260124012146.C3167C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: make khugepaged_collapse_control a local
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-make-khugepaged_collapse_control-a-local.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-make-khugepaged_collapse_control-a-local.patch

This patch will later appear in the mm-unstable branch at
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
From: "Garg, Shivank" <shivankg@amd.com>
Subject: mm/khugepaged: make khugepaged_collapse_control a local
Date: Fri, 23 Jan 2026 15:03:58 +0530

Make this collapse_control instance local to the only function which uses
it.

Link: https://lkml.kernel.org/r/ba4502f7-0c35-460e-a42c-d32dea9ab9eb@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-make-khugepaged_collapse_control-a-local
+++ a/mm/khugepaged.c
@@ -827,10 +827,6 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-struct collapse_control khugepaged_collapse_control = {
-	.is_khugepaged = true,
-};
-
 static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
@@ -2618,13 +2614,16 @@ static void khugepaged_wait_work(void)
 
 static int khugepaged(void *none)
 {
+	struct collapse_control cc = {
+		.is_khugepaged = true,
+	};
 	struct mm_slot *slot;
 
 	set_freezable();
 	set_user_nice(current, MAX_NICE);
 
 	while (!kthread_should_stop()) {
-		khugepaged_do_scan(&khugepaged_collapse_control);
+		khugepaged_do_scan(&cc);
 		khugepaged_wait_work();
 	}
 
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain.patch
mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch
mm-khugepaged-remove-unnecessary-goto-skip-label.patch
mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch
mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch
mm-khugepaged-make-khugepaged_collapse_control-a-local.patch

