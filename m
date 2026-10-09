Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B7241A794
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525594; cv=none; b=kn00ziSF/qyhCOof3x57oiIT6DAQCAGMuZoAkgmW0VFv2ldPxzfU4jvA/bm0nUKyz32GR0ES0kzh3l4n0AHeqewMs1Me0IgBKIxGfz5OmOBYiURkvBcWX9Zb0zwkhrmBgVqgBITasvxPRT4sns0YCaU+kWE1l5WoEadZdc5Arog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525594; c=relaxed/simple;
	bh=adBPrsTPwyf6/bJh19Zyr82JmdW+vFtZv2VlFu7jGp0=;
	h=Date:To:From:Subject:Message-Id; b=PhxgTxUWiCviMuJ+FIoWcbPFF5UQianJ+afliQ8wkTuU8DSXTPKTDB2kuE0Slz5zRr+2jPMn/5yJ0nUCU1R7MiPtGj4RSvJLvoVt/mpJvlp04ahlsxWOvXAkzLr/MLzf2kDw2lpltanygrzKyrWoc98qwtIrVHzd7DJ3MBo3WKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uE0wNGX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uE0wNGX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB411F00893;
	Fri,  9 Oct 2026 05:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525584;
	bh=o3dvpWobTr8MgX5lWv59xoFWLaXlF1qF7xqSaAK7Rko=;
	h=Date:To:From:Subject;
	b=uE0wNGX0Mkfn+N7lCrJZEnG5TlENhu5FZ7Y0x38IYPVMtp/YXm4dryFPBQi82T+A9
	 S0RTXfFMVDAESYbsuns4F3efI0eTwKi6OVnaVUDxdpZhUL/uSZSpmqsS24RHwq5T57
	 u6qTlT7V4c/piWdc+PiD3Y14PnZnT+wpeLR8OTN0=
Date: Thu, 08 Oct 2026 22:59:44 -0700
To: mm-commits@vger.kernel.org,slava@dubeyko.com,idryomov@gmail.com,david@kernel.org,amarkuze@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ceph-replace-pageprivate-with-page_private.patch removed from -mm tree
Message-Id: <20261009055944.6BB411F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ceph: replace PagePrivate() with page_private()
has been removed from the -mm tree.  Its filename was
     ceph-replace-pageprivate-with-page_private.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: ceph: replace PagePrivate() with page_private()
Date: Sun, 20 Sep 2026 22:28:08 -0400

PagePrivate() is going to be removed along with PG_private and its
implementation is the same as page_private().

Link: https://lore.kernel.org/20260920-remove-pg_private-v5-12-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Alex Markuze <amarkuze@redhat.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
---

 fs/ceph/addr.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/ceph/addr.c~ceph-replace-pageprivate-with-page_private
+++ a/fs/ceph/addr.c
@@ -70,9 +70,7 @@ static int ceph_netfs_check_write_begin(
 
 static inline struct ceph_snap_context *page_snap_context(struct page *page)
 {
-	if (PagePrivate(page))
-		return (void *)page->private;
-	return NULL;
+	return (void *)page_private(page);
 }
 
 /*
@@ -124,8 +122,8 @@ static bool ceph_dirty_folio(struct addr
 	spin_unlock(&ci->i_ceph_lock);
 
 	/*
-	 * Reference snap context in folio->private.  Also set
-	 * PagePrivate so that we get invalidate_folio callback.
+	 * Reference snap context in folio->private. Setting folio->private is
+	 * what gets us the invalidate_folio callback.
 	 */
 	VM_WARN_ON_FOLIO(folio->private, folio);
 	folio_attach_private(folio, snapc);
_

Patches currently in -mm which might be from ziy@nvidia.com are


