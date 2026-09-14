Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C667364042
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 03:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357943; cv=none; b=jY/4xHL5YKUhhPphnRmohoxiTpmm5+MTdyo1coWFrYkUpTHx63yomG9f2dlAZykbv6/9vyoP9V7IlxzOdWvyh/PbQXFE/CJHIFaQ12osnv9dfG108f1owd8IW5sKAuBgc9KcVcgDxfheUz+5Vc9OkEH+HqtpLDiJRMP/5Sd6ilI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357943; c=relaxed/simple;
	bh=xsdrOdc6uxcrhhAAdVRnhO96Tpjq+UyjPP18fBz34qQ=;
	h=Date:To:From:Subject:Message-Id; b=hvKLYvRMEUMEiJdCaLhKLbh81i7GiAg039SGMmDUav4pRhLK5KizIYSpgbq4zAGQNoBZghgFc71tR0uxoScB2jcnDMokqPA5ta4ov+J4/CG2VF7E1bFyzBpWvDfBQkstAjx9vTcQ6+7z40mZwdjnYvzg1R3zym2oLdYGL5QlQp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GKEta/1B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GKEta/1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616C11F000FF;
	Mon, 14 Sep 2026 03:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789357942;
	bh=nKqKYr60WfwVb9xseVGr6YyN2ZnXUUjRQfTjt+9SFGg=;
	h=Date:To:From:Subject;
	b=GKEta/1Br1ZVK8vv0017pCF7O/XzPNL7UMU0oNxonmGAeFrUNXQnpjTRgjbL21IK/
	 qWG/4qHleaFmbnmIBPFZqWaewbZKaFwT3iiEDF4GG9wWlfS2bRTZuu1RJWkQmBIvYM
	 hVHbN6AdbdMqnttq8i4JgcQ5lhaOgDyJY65bp4O4=
Date: Sun, 13 Sep 2026 20:52:22 -0700
To: mm-commits@vger.kernel.org,slava@dubeyko.com,idryomov@gmail.com,amarkuze@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ceph-replace-pageprivate-with-page_private.patch added to mm-new branch
Message-Id: <20260914035222.616C11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ceph: replace PagePrivate() with page_private()
has been added to the -mm mm-new branch.  Its filename is
     ceph-replace-pageprivate-with-page_private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ceph-replace-pageprivate-with-page_private.patch

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
Subject: ceph: replace PagePrivate() with page_private()
Date: Sun, 13 Sep 2026 22:24:10 -0400

PagePrivate() is going to be removed along with PG_private and its
implementation is the same as page_private().

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-12-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

