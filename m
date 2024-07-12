Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B9B1CF96
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824832; cv=none; b=pdkeRXKSLRzaAS3QHiHqxelSZit53+wzfwi7mvxR1RHmos/GyLBGb0ttjkycq6sHNZ/U5yg3L4uErOyerhW0dxyuifqccAEqZBWq6XFwOV94JgdUqAPtUlBp3vQwyAHc+dhGaxrdM9aDA2ZqXowmilUBXuNEzRa37Z1lshVEXDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824832; c=relaxed/simple;
	bh=ClAMSz2wcX4Yocccic4EAdScSP+yWN6zGJAHapV2JkI=;
	h=Date:To:From:Subject:Message-Id; b=oEHaRhQAqqMojRz8M/sEUCj2lmYnZfosvOBHg2jDjZVTn446dBD46LVvdAqkIceoq21PvLgXzEzYueSvpoACDImR7mGON0ovPPtuSlQYeRSU1rYV0mRhe7UC4+IjOMrvHBLKqiMyEtYOdbwHGqh05lmxWwI+inGTvd9QJ0NCGUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FAuuvVic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FAuuvVic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55286C32782;
	Fri, 12 Jul 2024 22:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824832;
	bh=ClAMSz2wcX4Yocccic4EAdScSP+yWN6zGJAHapV2JkI=;
	h=Date:To:From:Subject:From;
	b=FAuuvVicpGP+swYxa3rzCpOvvVd72adz6b+cv9lW6Zp3sWaXXPKeCdDXmZHYoOlYD
	 DMzDrXJNCcVOXLwN/L3DW7sVSA/k0fkk9CtgRoL0xQcSZn0k8OV9N8R6wseaGYE19e
	 17FJQ0Tdm+zJgre5Slpf+HMiqAdb9G4lb/h9C8Vs=
Date: Fri, 12 Jul 2024 15:53:51 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,chengming.zhou@linux.dev,aris@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlbc-undo-errant-change.patch removed from -mm tree
Message-Id: <20240712225352.55286C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb.c: undo errant change
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-undo-errant-change.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hugetlb.c: undo errant change
Date: Thu Jul 11 11:36:42 PM PDT 2024

During conflict resolution a line was unintentionally removed by a ksm.c
patch.

Link: https://lkml.kernel.org/r/85b0d694-d1ac-8e7a-2e50-1edc03eee21a@google.com
Fixes: ac90c56bbd73 ("mm/ksm: refactor out try_to_merge_with_zero_page()")
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlbc-undo-errant-change
+++ a/mm/hugetlb.c
@@ -2631,6 +2631,7 @@ static int gather_surplus_pages(struct h
 retry:
 	spin_unlock_irq(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
+		folio = NULL;
 		for_each_node_mask(node, cpuset_current_mems_allowed) {
 			if (!mbind_nodemask || node_isset(node, *mbind_nodemask)) {
 				folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are


