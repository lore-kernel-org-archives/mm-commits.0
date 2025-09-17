Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627D71B3923
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 20:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758141998; cv=none; b=KfLOv0sSAzoMo3oxf0mPRE66T6CqZobNNNWJ2sPf2JygpSsGpg3rAdE3pkDrhadNypceQeyED7UbKJPduJ57CxeQmJRcj7a27yQd1aKB8oKfSay/y6bBFHGDzU/xaoLD7KLAhODIzb8Y2OzFEBDd5EhF1Qz6hb2Au5maUa69rJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758141998; c=relaxed/simple;
	bh=+H2ua/9kvoC+qeeqkjj/YVx0cbHWaNtSNWzkEamCsqo=;
	h=Date:To:From:Subject:Message-Id; b=QQGGjuEe0k0Tv+q2gYVquArKSOJKv0cZVuyQxinOAMLA6V9E1AT/qwyBukzsSM1cdZk9PYompHZBd9ME7fSWgqqFaqEM2MbY2o1sHeuBrmWmMuGUBhBmIS4Orw0eZhCCgMSvEXt/H2+UxbSsDJIx7G5HML6UNycYV//z6t/pU/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nUWjiKOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nUWjiKOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D72C4CEE7;
	Wed, 17 Sep 2025 20:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758141997;
	bh=+H2ua/9kvoC+qeeqkjj/YVx0cbHWaNtSNWzkEamCsqo=;
	h=Date:To:From:Subject:From;
	b=nUWjiKOyXmkPgLIqJDUsl77/MReEB4fvBvUYhq9Uh+OGFP/HY51uVeh0KYXseLgMR
	 LpChiKu/b88InV5gigkds+suvBlySK1XXHyAv4zmAPnWeDyQ2VfD39CWT7oDttTDN5
	 YsRssSDX1+c3S3Ntx3wN9JgEVfAW6c8XaM1weTmM=
Date: Wed, 17 Sep 2025 13:46:37 -0700
To: mm-commits@vger.kernel.org,mhocko@kernel.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-move-resched-point-into-alloc_vmap_area.patch added to mm-new branch
Message-Id: <20250917204637.C7D72C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: move resched point into alloc_vmap_area()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-move-resched-point-into-alloc_vmap_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-move-resched-point-into-alloc_vmap_area.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: move resched point into alloc_vmap_area()
Date: Wed, 17 Sep 2025 20:59:06 +0200

Currently vm_area_alloc_pages() contains two cond_resched() points. 
However, the page allocator already has its own in slow path so an extra
resched is not optimal because it delays the loops.

The place where CPU time can be consumed is in the VA-space search in
alloc_vmap_area(), especially if the space is really fragmented using
synthetic stress tests, after a fast path falls back to a slow one.

Move a single cond_resched() there, after dropping free_vmap_area_lock in
a slow path.  This keeps fairness where it matters while removing
redundant yields from the page-allocation path.

Link: https://lkml.kernel.org/r/20250917185906.1595454-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-move-resched-point-into-alloc_vmap_area
+++ a/mm/vmalloc.c
@@ -2057,6 +2057,13 @@ retry:
 		addr = __alloc_vmap_area(&free_vmap_area_root, &free_vmap_area_list,
 			size, align, vstart, vend);
 		spin_unlock(&free_vmap_area_lock);
+
+		/*
+		 * This is not a fast path. Check if yielding is
+		 * needed. This is the only one reschedule point
+		 * in vmalloc() path.
+		 */
+		cond_resched();
 	}
 
 	trace_alloc_vmap_area(addr, size, align, vstart, vend, IS_ERR_VALUE(addr));
@@ -3622,7 +3629,6 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 							pages + nr_allocated);
 
 			nr_allocated += nr;
-			cond_resched();
 
 			/*
 			 * If zero or pages were obtained partly,
@@ -3664,7 +3670,6 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		for (i = 0; i < (1U << order); i++)
 			pages[nr_allocated + i] = page + i;
 
-		cond_resched();
 		nr_allocated += 1U << order;
 	}
 
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-move-resched-point-into-alloc_vmap_area.patch

