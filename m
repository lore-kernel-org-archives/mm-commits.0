Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592F12DB794;
	Tue,  9 Jun 2026 01:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968157; cv=none; b=rubfB2sB53/XqU+AJiNJ1j4C8nAx7RrNJEI9/dvwMm5IvlRNpcj9w8laPF6My6loSiNkHDofNhd7xCaZuME0HOobCfwfqReAn0c9MzkjuVXvLTd4xn29mXhUQDkRC2w5t6vaniRXqoQ+79LNZZyEHDMiiHwPYPyngzC9fFRyhEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968157; c=relaxed/simple;
	bh=9jHkxvXqvVqmtF76HUrlmX37NLwS4sAtU4D1xyzPMxM=;
	h=Date:To:From:Subject:Message-Id; b=gUWgnIlAmKZFg4H/9LBHZOdrdrMN7lvhL+E8ta+MKMUUFpwJJJwrfTHCEGcP8smsQOruusVmUZkADCORS1ce46gkqPDTEdMUI/zzD732DgjnSqNaqtzmVaPin+yspNutEzWCEKts3gG7EjGGRyAiHWijqhnNdzveaBQeZl4iQqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VIt7MqmM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VIt7MqmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB781F00898;
	Tue,  9 Jun 2026 01:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968156;
	bh=mGNjz3jIOEOTKnwl/gsIwXqOBM6jqIUel7EaLcItHGw=;
	h=Date:To:From:Subject;
	b=VIt7MqmM45NCpef6GYwDhVe5NlW7mtzk6D9hes5yZDPnxGGJmmtQzVoQV7Ccg9qN6
	 NgXQ63aOyVpABDh3qagkeZ89kHW05xzKLsK++XoA0NdNKpe1gVvHPdTA0Y+dLJAQ/8
	 nWGvndRO6wh1BCacIgKKIga72KU2Ak6VW69FtVkw=
Date: Mon, 08 Jun 2026 18:22:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,dev.jain@arm.com,david@kernel.org,balbirs@nvidia.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-use-huge_page_size-in-pagemap_scan_hugetlb_entry.patch removed from -mm tree
Message-Id: <20260609012236.2BB781F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: use huge_page_size() in pagemap_scan_hugetlb_entry()
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-use-huge_page_size-in-pagemap_scan_hugetlb_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: fs/proc/task_mmu: use huge_page_size() in pagemap_scan_hugetlb_entry()
Date: Fri, 29 May 2026 18:23:26 +0100

The partial-page check compares against HPAGE_SIZE (PMD_SIZE), which is
wrong for gigantic hugetlb hstates (e.g.  1G).  The walker hands the
callback a huge_page_size()-sized range, never start + HPAGE_SIZE, so the
comparison always declares it partial and aborts the WP.  Compare against
the actual hstate's page size.

Link: https://lore.kernel.org/20260529172331.356655-3-kas@kernel.org
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-use-huge_page_size-in-pagemap_scan_hugetlb_entry
+++ a/fs/proc/task_mmu.c
@@ -2960,7 +2960,7 @@ static int pagemap_scan_hugetlb_entry(pt
 	if (~categories & PAGE_IS_WRITTEN)
 		goto out_unlock;
 
-	if (end != start + HPAGE_SIZE) {
+	if (end != start + huge_page_size(hstate_vma(vma))) {
 		/* Partial HugeTLB page WP isn't possible. */
 		pagemap_scan_backout_range(p, start, end);
 		p->arg.walk_end = start;
_

Patches currently in -mm which might be from kas@kernel.org are


