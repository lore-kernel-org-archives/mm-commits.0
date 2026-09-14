Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99FE36212E
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 03:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357948; cv=none; b=BakbJB077BiF08EpuZXU2T5W69FAxPVFqFvxRRn4Yf7aeXVhmkma31AH/zruqua/MhWilKulQGNdVmolTspoKi+g97jpDKitek+Pp4j+c88DaVEsIsrlAIN16HaWeRVuDIPhSO4PCbCHzm+t9IXnLUWzSdTGI5NSoqvix8dK1v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357948; c=relaxed/simple;
	bh=QYqz/b72lpBI0Cratvl1NH+sVefxZIyTYYE9jThueNg=;
	h=Date:To:From:Subject:Message-Id; b=Q7VKUsSZ2SUfYYAQFtSZQvvZKus1Iq7GJzckkr3RfqXeR70i6PsSfhnoIChc5Ge+etOxDjox7ifPnDTgRAyncwZ5dg4FdKJ31P9DLmEZCBQJxNDb0uTWMc8jmhkUwub1aaV43CM4k8lH+v2glC5Bh/YDvKKhLhgvW1m/gdNiwxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YKQwUgNv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YKQwUgNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA7C1F000FF;
	Mon, 14 Sep 2026 03:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789357946;
	bh=HfshYoTP2B701aDUKLVvnNSZ4FQxIUaGyqG7E8I6YXY=;
	h=Date:To:From:Subject;
	b=YKQwUgNvNqEFMxhjHHjG6dot/li6L5NvqYVMGkQ5QnSrHdD77nm6ruVmQDLQRh8gf
	 z9Akcr+kf/ziwZuVShy/PQmboHGZK3AgiUoxUtcjvkPq019AvZnixoXGpm4xHpVvfv
	 E2WJdFp3sHHbzycVJrTdSqzPj9FjnpWr2X7ILe4w=
Date: Sun, 13 Sep 2026 20:52:25 -0700
To: mm-commits@vger.kernel.org,yukuai@fygo.io,xiao@kernel.org,willy@infradead.org,song@kernel.org,magiclinan@didiglobal.com,jack@suse.cz,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-replace-page_buffer-with-page_private-and-delete-it.patch added to mm-new branch
Message-Id: <20260914035226.5DA7C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: buffer: replace page_buffer() with page_private() and delete it
has been added to the -mm mm-new branch.  Its filename is
     buffer-replace-page_buffer-with-page_private-and-delete-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-replace-page_buffer-with-page_private-and-delete-it.patch

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
Subject: buffer: replace page_buffer() with page_private() and delete it
Date: Sun, 13 Sep 2026 22:24:12 -0400

Only two users (in md-bitmap) use page_buffer() and both can be converted
to use page_private().  Convert both and remove page_buffer().

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-14-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>
Cc: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
---

 drivers/md/md-bitmap.c      |    7 +++----
 include/linux/buffer_head.h |    6 ------
 2 files changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/md/md-bitmap.c~buffer-replace-page_buffer-with-page_private-and-delete-it
+++ a/drivers/md/md-bitmap.c
@@ -516,7 +516,7 @@ static void end_bitmap_write(struct bio
 
 static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 {
-	struct buffer_head *bh = page_buffers(page);
+	struct buffer_head *bh = (struct buffer_head *)page_private(page);
 
 	while (bh && bh->b_blocknr) {
 		atomic_inc(&bitmap->pending_writes);
@@ -533,12 +533,11 @@ static void write_file_page(struct bitma
 
 static void free_buffers(struct page *page)
 {
-	struct buffer_head *bh;
+	struct buffer_head *bh = (struct buffer_head *)page_private(page);
 
-	if (!page_private(page))
+	if (!bh)
 		return;
 
-	bh = page_buffers(page);
 	while (bh) {
 		struct buffer_head *next = bh->b_this_page;
 		free_buffer_head(bh);
--- a/include/linux/buffer_head.h~buffer-replace-page_buffer-with-page_private-and-delete-it
+++ a/include/linux/buffer_head.h
@@ -175,12 +175,6 @@ static inline unsigned long bh_offset(co
 	return (unsigned long)(bh)->b_data & (page_size(bh->b_page) - 1);
 }
 
-/* If we *know* page->private refers to buffer_heads */
-#define page_buffers(page)					\
-	({							\
-		BUG_ON(!PagePrivate(page));			\
-		((struct buffer_head *)page_private(page));	\
-	})
 #define folio_buffers(folio)		folio_get_private(folio)
 
 void buffer_check_dirty_writeback(struct folio *folio,
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

