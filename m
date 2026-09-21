Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F12347BA7
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 04:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789963806; cv=none; b=PQeoYrde0DgKZ7W1ScSnbPPurywZUBUDPsebv2F/ie3opCzKxwS+UEi8+j8jUV6ptYRAYkLyqExeneDK8pl53kfSaO43UVvuxGLVWRHBv+5jWJoxYvYXmIqYBVrPQZXYWzMqW/02qxv6w3MwYLkWIQbR4WdqiznijZfpM7Liu7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789963806; c=relaxed/simple;
	bh=J9fmraUkxUbpqiNYFWwVS2fO/EY4iBvdDUOTtEftFfg=;
	h=Date:To:From:Subject:Message-Id; b=INPpn3hEWVUoSqVRhbXgBj8BVLaYGDtilNBjKZAx4ILoA+21Ko7rlyn/7wxPSaJRX8mZ/4jv1rLmIOEXEexhUSo0NjReRqGYt4fN18SKNj5y0sz8/kdu5UtWOsj10dJ05GFm2EjCnXUz+YfbdEBAI+Z72uSljr+HamAsKsvIv2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LQkSFlU4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LQkSFlU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7930F1F000FF;
	Mon, 21 Sep 2026 04:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789963803;
	bh=vaIOSI2EhgldLgFC7FF2JDR5oxiBoI/TB+z4nCyD8Vk=;
	h=Date:To:From:Subject;
	b=LQkSFlU4dTtfWiGwEt6hh0Kg5B6h+N0W3GIIPqAazPuQ9pFTVUhT7Aw8uPCnSThU7
	 vdRXpqRtCYo0gqsRw2fpIhvXt/JwQroKe5HxnZMXR36RYLJJCgPL/ZKI2ZjpKyHTeE
	 8RpmoazlQWq27kM/wjAnhbIMkRXKsvGJYefU2JW8=
Date: Sun, 20 Sep 2026 21:10:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + treewide-remove-folio_set-clear_private-usage.patch added to mm-unstable branch
Message-Id: <20260921041003.7930F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: treewide: remove folio_set/clear_private() usage
has been added to the -mm mm-unstable branch.  Its filename is
     treewide-remove-folio_set-clear_private-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/treewide-remove-folio_set-clear_private-usage.patch

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
Subject: treewide: remove folio_set/clear_private() usage
Date: Sun, 20 Sep 2026 22:28:07 -0400

They are no-ops now. Remove them.

Assisted-by: LLM
Link: https://lore.kernel.org/20260920-remove-pg_private-v5-11-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Trond Myklebust <trondmy@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
---

 fs/nfs/write.c          |    2 --
 include/linux/pagemap.h |    4 +---
 mm/migrate.c            |    1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

--- a/fs/nfs/write.c~treewide-remove-folio_set-clear_private-usage
+++ a/fs/nfs/write.c
@@ -717,7 +717,6 @@ static void nfs_inode_add_request(struct
 	nfs_lock_request(req);
 	spin_lock(&mapping->i_private_lock);
 	set_bit(PG_MAPPED, &req->wb_flags);
-	folio_set_private(folio);
 	folio->private = req;
 	spin_unlock(&mapping->i_private_lock);
 	atomic_long_inc(&nfsi->nrequests);
@@ -745,7 +744,6 @@ static void nfs_inode_remove_request(str
 
 			spin_lock(&mapping->i_private_lock);
 			folio->private = NULL;
-			folio_clear_private(folio);
 			clear_bit(PG_MAPPED, &req->wb_head->wb_flags);
 			spin_unlock(&mapping->i_private_lock);
 
--- a/include/linux/pagemap.h~treewide-remove-folio_set-clear_private-usage
+++ a/include/linux/pagemap.h
@@ -594,7 +594,6 @@ static inline void folio_attach_private(
 {
 	folio_get(folio);
 	folio->private = data;
-	folio_set_private(folio);
 }
 
 /**
@@ -629,9 +628,8 @@ static inline void *folio_detach_private
 {
 	void *data = folio_get_private(folio);
 
-	if (!folio_test_private(folio))
+	if (!data)
 		return NULL;
-	folio_clear_private(folio);
 	folio->private = NULL;
 	folio_put(folio);
 
--- a/mm/migrate.c~treewide-remove-folio_set-clear_private-usage
+++ a/mm/migrate.c
@@ -835,7 +835,6 @@ void folio_migrate_flags(struct folio *n
 	 */
 	if (folio_test_swapcache(folio))
 		folio_clear_swapcache(folio);
-	folio_clear_private(folio);
 
 	/* page->private contains hugetlb specific flags */
 	if (!folio_test_hugetlb(folio))
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

