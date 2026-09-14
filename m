Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D623644D4
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 03:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357922; cv=none; b=p0eMZY8YrLiK4yuQB23JkAXctNupiz2i4sX1x7BJn8QP51F8VqRNW61ZJTToafjk3AmwvkIOKEHSVW26O2FsSEBobI0dryaodyDHNE8yOZHccwRs258UcQL2sG7SKS7P93z1Yr/cnj8xmOa05NHvgSuH4zn9N2Bg6AF2QJo4kQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357922; c=relaxed/simple;
	bh=V93Muj0CFGsNflvC3ZLuTrjIbLOzfg7ZmrKB0SKTaoU=;
	h=Date:To:From:Subject:Message-Id; b=SBxNLkwxFkt0OEi9X5yBPd44qXVayRv9KyuDB4GyWXKBpgrcCQlBBoKq6zZAYwT2ghxhF2qJ1F7QgYc514XkiGhx08KTqSwudVKo/9abCXnBD14mYg7+fVgR3OqdeST3ZCjkZBSpTI8hXbql3Ra5tob8SDTdy2eLlppL7nYxin8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xAiU1Ub6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xAiU1Ub6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF6D1F000FF;
	Mon, 14 Sep 2026 03:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789357920;
	bh=TSQGYN38IXvXRDbT1ne1kK/AWtfIMGJgx1UlhtdXihc=;
	h=Date:To:From:Subject;
	b=xAiU1Ub6HPdLjciPeGzypPqiqJLkAe2/OjKQ13Qyn8XOqBLRKVZUJHi21bCv1O38R
	 YqWtkRhyNXd9MWFu8kVESFWXb+5JCkvUqbxwq79U10y/mnnCI3WZCTbFNKiOptqhOR
	 XQFABc/K5wdAT67CcarLSBsXUiHnVS2xjhJvZlRk=
Date: Sun, 13 Sep 2026 20:52:00 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,osalvador@suse.de,muchun.song@linux.dev,gourry@gourry.net,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch added to mm-new branch
Message-Id: <20260914035200.7DF6D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: use direct assignment instead of folio_change_private()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/hugetlb: use direct assignment instead of folio_change_private()
Date: Sun, 13 Sep 2026 22:24:03 -0400

folio_change_private() should be used along with folio_attach_private()
and folio_detach_private(), where adding and remove ->private content
requires folio refcount change.  add_hugetlb_folio() simply sets
folio->private to NULL without refcount manipulation.  Change it to direct
assignment to avoid semantic confusion.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-5-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: David Hildenbrand <david@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
To: Oscar Salvador <osalvador@suse.de>
---

 mm/hugetlb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-direct-assignment-instead-of-folio_change_private
+++ a/mm/hugetlb.c
@@ -1446,11 +1446,8 @@ void add_hugetlb_folio(struct hstate *h,
 	}
 
 	__folio_set_hugetlb(folio);
-	folio_change_private(folio, NULL);
-	/*
-	 * We have to set hugetlb_vmemmap_optimized again as above
-	 * folio_change_private(folio, NULL) cleared it.
-	 */
+	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. */
+	folio->private = NULL;
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
 	arch_clear_hugetlb_flags(folio);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-zsmalloc-replace-pg_private-with-pointer-comparison.patch
perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch
xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch
fscrypt-stop-setting-pg_private-on-bounce-page.patch
mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch
f2fs-stop-using-pg_private.patch
f2fs-convert-the-private-flag-helpers-to-folio-only.patch
erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private.patch
erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch
mm-page-flags-check-page-folio-private-instead-of-pg_private.patch
treewide-remove-folio_set-clear_private-usage.patch
ceph-replace-pageprivate-with-page_private.patch
md-md-bitmap-replace-pageprivate-with-page_private.patch
buffer-replace-page_buffer-with-page_private-and-delete-it.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

