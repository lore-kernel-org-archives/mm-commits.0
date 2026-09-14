Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8658236212E
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 03:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357945; cv=none; b=cUo3t1wQl5LoJF2wgzwx72HVczGr3e50WtJuPPRcLtBdhLWI+Eh6OJpzIwDVnjIUh2cfsvOpKvb891AK6nizHz1tAtdqT/E0h+lJJ3VwRKkAVQoGeWP8yJn6HVui27UZ2lN9803BxSz8EPXJKCJz0jVeQpe3RDYafrn5LWWkDEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357945; c=relaxed/simple;
	bh=pMWaeIkXr9Q75NtfQ0P0b2u5ei3Y8tETp75XAUDWNUI=;
	h=Date:To:From:Subject:Message-Id; b=AVSccbVzrOlC4NNl82B9y3cAUFXElXQGwGGdM8QhDnvhjSWcuZryofVPVJEqn2BXJKyVhLaNr4YFiMQMQnRyc0Ujxp894wE4mIaSBq58GWig1/+XmbWIitcycaYPHn8K/NTMuyqNIfMfnq4ChdfWhpOwsruOoEw4cgLfOI1jqvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kXR83pHA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kXR83pHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F251F000FF;
	Mon, 14 Sep 2026 03:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789357944;
	bh=dtOYdJ0mseMwe56Prn4U3FmWreU9u9IljieZ0jtCqTQ=;
	h=Date:To:From:Subject;
	b=kXR83pHAebIJjiAVKXW47XpXCU3xjOkO6wQCBJkrTR0dMDhC6kGxSNniii3zc3v6t
	 WgCNbvE/B1VrLKipFexcU5UYMiQuq+b9oWRepojofmiQ7+M8PnpwYYvDVtk1joVq+B
	 zyWhImNXswW37H2sa4V9/KWBpCosQNryhRGwBdbs=
Date: Sun, 13 Sep 2026 20:52:23 -0700
To: mm-commits@vger.kernel.org,yukuai@fygo.io,xiao@kernel.org,song@kernel.org,magiclinan@didiglobal.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + md-md-bitmap-replace-pageprivate-with-page_private.patch added to mm-new branch
Message-Id: <20260914035224.58F251F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: md/md-bitmap: replace PagePrivate() with page_private()
has been added to the -mm mm-new branch.  Its filename is
     md-md-bitmap-replace-pageprivate-with-page_private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/md-md-bitmap-replace-pageprivate-with-page_private.patch

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
Subject: md/md-bitmap: replace PagePrivate() with page_private()
Date: Sun, 13 Sep 2026 22:24:11 -0400

PagePrivate() is going to be removed along with PG_private and its
implementation has been changed to match page_private().

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-13-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>
---

 drivers/md/md-bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/md-bitmap.c~md-md-bitmap-replace-pageprivate-with-page_private
+++ a/drivers/md/md-bitmap.c
@@ -535,7 +535,7 @@ static void free_buffers(struct page *pa
 {
 	struct buffer_head *bh;
 
-	if (!PagePrivate(page))
+	if (!page_private(page))
 		return;
 
 	bh = page_buffers(page);
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

