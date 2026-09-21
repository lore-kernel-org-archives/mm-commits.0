Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163CF3264EF
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 03:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961502; cv=none; b=oihEW4Gtp7FHEhW3a1YocaTfow0q4YBstpgltK5Ke4BzwP0r3MQuaGtHvRVgGxShS4b8ik/zKBp26uYjd1hUv6ZJXpscs1tVNyhDV0t6sGe/kVNv9wRVcdolIU/w4t0FFkdBcOzovHumOTPwgStyYH4JgaoFGeXwo0cdqBwP5lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961502; c=relaxed/simple;
	bh=ct7aoT+YKv3VSeahQZistnRO3ZUj+iESR5BMImfxba4=;
	h=Date:To:From:Subject:Message-Id; b=RtXQGqJYKxlDhz+SMsMfiudrU6BHXOfH3cMAXW4uD79hGaQlzOONTYzSvth9kDf5haC44Jk1kKbzZ1f8efz7e/ESH+2MXrnUiFWPwdWgd+n5SJCc8LHdy8BkFUBgqOZjIoaiALJP0gDnB5mD6ApQNUSs8bLF2J9aPBkvW3VCOfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fyNjQVR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fyNjQVR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEE71F00893;
	Mon, 21 Sep 2026 03:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789961501;
	bh=SXET1z6X5bbhADNuZRjLgdxSON7N7dKVO4JvXS+zIZk=;
	h=Date:To:From:Subject;
	b=fyNjQVR714d+XqXYj4IvqW7Me21aC3KBriHrtNgFTqr9SqUTt8hF4EFYLMJSfrBBE
	 jaOt3ZgzGUlw1TCOusf85qnuspRcU/sc6AkJfJ66aDP8lnllRaFpXpyc5jY3QWX790
	 rqW+YktLIuJ7Xsoysd89JIpMUVjL0vpb14g5ePWc=
Date: Sun, 20 Sep 2026 20:31:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] treewide-remove-folio_set-clear_private-usage.patch removed from -mm tree
Message-Id: <20260921033140.DEEE71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: treewide: remove folio_set/clear_private() usage
has been removed from the -mm tree.  Its filename was
     treewide-remove-folio_set-clear_private-usage.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: treewide: remove folio_set/clear_private() usage
Date: Sun, 13 Sep 2026 22:24:09 -0400

They are no-ops now. Remove them.

Link: https://lore.kernel.org/20260913-remove-pg_private-v4-11-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Trond Myklebust <trondmy@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
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

ceph-replace-pageprivate-with-page_private.patch
md-md-bitmap-replace-pageprivate-with-page_private.patch
buffer-replace-page_buffer-with-page_private-and-delete-it.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

