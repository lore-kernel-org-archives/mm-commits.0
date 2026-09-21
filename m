Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B78146D5A
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 04:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789963787; cv=none; b=uYBiJGUIP0vsOoduR0EwDnFwy1Z6qnslY/cqMCHKvHze1vi6Xo7Q8hSn56GB28FuKQKjBvk6V8ESuVQHY+djW9ClX1/c/6cE8rO8Do3NF2XJgGsoNTVE/z+SBlMpi0R+Cl+6IUQtidrMZEHXjHR1anHuQmjpleixAFd0n7Nb+co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789963787; c=relaxed/simple;
	bh=Tu/4nrT1xuwNNYrhgEL2mGi4L43OhFjkMvcVVO3yb84=;
	h=Date:To:From:Subject:Message-Id; b=PHV4LDZAMqEqrG1CiSXCel5jJy6J/Bjo/SSDXi/lplSdCVTkCxbx9HGxe6jWGJtsoidQSHC8poA5XnGghC9WQ6Km4ckQrKrR3fzdW2loEmPvQYvdg7YlQ1AHRtq+vm15PU9+q05cEO88CIO8MsDr2fxb5xhtpifwUCj+/twyCA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K9l1x1Zh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K9l1x1Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C851F000FF;
	Mon, 21 Sep 2026 04:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789963785;
	bh=ENf0z6PRzWIVaFWOmJ09DE2fhjpRiq6jSGUvKhTP7Ss=;
	h=Date:To:From:Subject;
	b=K9l1x1ZhRCTNZs0Vp5iYr2mYmKOH3TtZpfLvAgwLKFVuuFXzrw9w+A03a6M96dpFB
	 dGReGpgKSzz5wv5owsDIQTsuKJ+8HPu0ygttRSXlMTayldUGeqKVaktGtQDnnWSHaK
	 gzVTIxKeYM4bsXXPCDoLJtqd8kQ6KfarBB+nzCnY=
Date: Sun, 20 Sep 2026 21:09:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch added to mm-unstable branch
Message-Id: <20260921040945.91C851F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: use direct assignment instead of folio_change_private()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/hugetlb: use direct assignment instead of folio_change_private()
Date: Sun, 20 Sep 2026 22:28:01 -0400

folio_change_private() should be used along with folio_attach_private() and
folio_detach_private(), where adding and remove ->private content requires
folio refcount change. add_hugetlb_folio() simply sets folio->private to
NULL without refcount manipulation. Change it to direct assignment to avoid
semantic confusion.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
Link: https://lore.kernel.org/20260920-remove-pg_private-v5-5-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
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
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

