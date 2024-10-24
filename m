Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39D4175D53
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 06:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750528; cv=none; b=C3cWnFlDw4/W/qDqzhnqKIIEKFQlV6+6gYjYf/VRWwsDtfRLBHmVM5QsAbX5n526q95hVtTtLPAWO4IWucRt7h9oOO0SLz+qC8c64tfy68YtdncDTJptXWdwVp5Y1l054h2QZsGDswEd48JxWyOogFt3QkTh3igibArXUkMsskY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750528; c=relaxed/simple;
	bh=ZiEpO7fdmDf6DjDVByQUgRj2pYBek0haeN3xFlNbXgg=;
	h=Date:To:From:Subject:Message-Id; b=GV+HC+UzBGxKtrqP51eOD30EdiTsp4lAdqD8jesPAk/oewThJb7wHSji5T2sNO+16Ujn0W0srg0cS6ThHNUInT+o2HQ6VGyMqd6FeW2OfZSr/a/wlEwrnow+jZgXa8aw9RZcxFqN6GsCEgTVLaOuqprkBxBMuP9xl/40yWRhc9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bT4owFHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bT4owFHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4A9C4CEC7;
	Thu, 24 Oct 2024 06:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750526;
	bh=ZiEpO7fdmDf6DjDVByQUgRj2pYBek0haeN3xFlNbXgg=;
	h=Date:To:From:Subject:From;
	b=bT4owFHhGfI2rWiPt0BilQ+p9jhjIoiKBx3IUv5QSJ3HEGb5iHicaZDFZsgSp4kox
	 QQjn+meMl5wTltw/8BsSKhUj7ENfMytQe7fw2d4uxEWrhJUNjcqysuo/uFlkMDyh36
	 QK7gaNPxsMacip00l2gwJ+imp7h8Cx9BE75K5tj4=
Date: Wed, 23 Oct 2024 23:15:25 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mark-mas-allocation-in-vms_abort_munmap_vmas-as-__gfp_nofail.patch removed from -mm tree
Message-Id: <20241024061526.2C4A9C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mark mas allocation in vms_abort_munmap_vmas as __GFP_NOFAIL
has been removed from the -mm tree.  Its filename was
     mm-mark-mas-allocation-in-vms_abort_munmap_vmas-as-__gfp_nofail.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm: mark mas allocation in vms_abort_munmap_vmas as __GFP_NOFAIL
Date: Wed, 16 Oct 2024 17:07:53 +0200

vms_abort_munmap_vmas() is a recovery path where, on entry, some VMAs have
already been torn down halfway (in a way we can't undo) but are still
present in the maple tree.

At this point, we *must* remove the VMAs from the VMA tree, otherwise we
get UAF.

Because removing VMA tree nodes can require memory allocation, the
existing code has an error path which tries to handle this by reattaching
the VMAs; but that can't be done safely.

A nicer way to fix it would probably be to preallocate enough maple tree
nodes for the removal before the point of no return, or something like
that; but for now, fix it the easy and kinda ugly way, by marking this
allocation __GFP_NOFAIL.

Link: https://lkml.kernel.org/r/20241016-fix-munmap-abort-v1-1-601c94b2240d@google.com
Fixes: 4f87153e82c4 ("mm: change failure of MAP_FIXED to restoring the gap on failure")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/vma.h~mm-mark-mas-allocation-in-vms_abort_munmap_vmas-as-__gfp_nofail
+++ a/mm/vma.h
@@ -241,15 +241,9 @@ static inline void vms_abort_munmap_vmas
 	 * failure method of leaving a gap where the MAP_FIXED mapping failed.
 	 */
 	mas_set_range(mas, vms->start, vms->end - 1);
-	if (unlikely(mas_store_gfp(mas, NULL, GFP_KERNEL))) {
-		pr_warn_once("%s: (%d) Unable to abort munmap() operation\n",
-			     current->comm, current->pid);
-		/* Leaving vmas detached and in-tree may hamper recovery */
-		reattach_vmas(mas_detach);
-	} else {
-		/* Clean up the insertion of the unfortunate gap */
-		vms_complete_munmap_vmas(vms, mas_detach);
-	}
+	mas_store_gfp(mas, NULL, GFP_KERNEL|__GFP_NOFAIL);
+	/* Clean up the insertion of the unfortunate gap */
+	vms_complete_munmap_vmas(vms, mas_detach);
 }
 
 int
_

Patches currently in -mm which might be from jannh@google.com are

maple_tree-fix-outdated-flag-name-in-comment.patch

