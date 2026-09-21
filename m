Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4534347BD9
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 04:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789963808; cv=none; b=SlFp2CHMtTqW7IGNRnT7faSTLKHJ57tRkZLhQaAwVrl17dARJ1c7C2sC5gob4AYaMbiAdfIyayC5tuV2w1Sf0zmaNHFKZlyogEwuwFIxdxPZRdSkvkNzdp5C32RfaZdc4kl22Eh0FEdQDL+RT8+jcmq2zydOVAQah0Z0IMfz7zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789963808; c=relaxed/simple;
	bh=oeps/M8R6qS0KHVEy1PCmYnfjJn3mT+D9otXAD4QbvU=;
	h=Date:To:From:Subject:Message-Id; b=BMPNHNSZc1PhR+/tAoFrXl/FA96sijPyEjoW2vg/YDH8NA52ygLKLjDgzfWjxN+n/e7Mt9cdQh11xTZmh7c3aQ5uMpQMq3TRpF9NhDNaf3L+3S1VDODPuATXVQwzjLV7gHUgd2Svpb2BlFodOpmIwMDaYWzWXxTfuddQ2NUNF9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BEfxhJYy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BEfxhJYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C321F00893;
	Mon, 21 Sep 2026 04:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789963806;
	bh=kjUTAWHql7AIHk0/4aukuWAKCMGATU8xkNAPAFqDZfA=;
	h=Date:To:From:Subject;
	b=BEfxhJYyLGoKSaUWRJMoGqegGaah4NIKshHLXHowc2uT4Z/LTCgPjY5ybm/g5hWBU
	 X7nIS291Ry2kVap2Vr0bclpyAqJvJORxiH+ZGZgxp2VIblyHCbuhtdVFCLcyeORqy6
	 9YI/ezac9e8DVZJ50DBFzhD9f47zujQVOzQroFVg=
Date: Sun, 20 Sep 2026 21:10:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ceph-replace-pageprivate-with-page_private.patch added to mm-unstable branch
Message-Id: <20260921041006.44C321F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ceph: replace PagePrivate() with page_private()
has been added to the -mm mm-unstable branch.  Its filename is
     ceph-replace-pageprivate-with-page_private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ceph-replace-pageprivate-with-page_private.patch

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
Subject: ceph: replace PagePrivate() with page_private()
Date: Sun, 20 Sep 2026 22:28:08 -0400

PagePrivate() is going to be removed along with PG_private and its
implementation is the same as page_private().

Assisted-by: LLM
Link: https://lore.kernel.org/20260920-remove-pg_private-v5-12-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
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
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

