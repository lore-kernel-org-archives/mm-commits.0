Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4207D33260C
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 03:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961505; cv=none; b=iFhjcEWnX0hP9Ekps0UX8vVqy/Ns7K+dN147a+OHuy8Eyn9QoAXW0MxfUk9D8n85lnPvsrulFXPuIxx+vNRnMMqzYfnW7hKXGKHPfXGQuRwmYa/XD2Mjnj9NyeFZO97r/JhTT28c//ZUSrxMOvOXmZ1O33Dpobu07svQL49ufFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961505; c=relaxed/simple;
	bh=uvqNFuvcxlVvj9rlKGMWSxpVCpmZqkWvPiUtWypoCG0=;
	h=Date:To:From:Subject:Message-Id; b=pLQA7JMVP6jZuYdd8cqpyKyoaFW47XZdztgxeZ9wqQuQJ38YmmovV9tm6016AUVFYrnAh5lfe9PVeGOtrXxoP+9QPGbZmIBkbWdiS2Fjdd2KTJ0rybe1E3C1BaRtrvj6SEaWBOeoLdyWHdK6tgNhGAAUkAKpA9qMyZdqPNoigwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZJHD/3Ro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZJHD/3Ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180D91F000FF;
	Mon, 21 Sep 2026 03:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789961504;
	bh=Pov9aOeSFXmgy9t5IBrmV7/Fq9p/CCQrVZfurNj3Eow=;
	h=Date:To:From:Subject;
	b=ZJHD/3RoZVIzPsbPQshh7f6bN0IiEWd+b+B+Jbyn25HjxQRXt9nYtaIDiKfUIv0zM
	 AQLOAKA7RvakUEra40AvGz1orLWcPIWjsyDDny+VRP1vaXuqKnBoa6/uwcCpxuV88i
	 i1e+PQK2H6D6oZeND/UhToXEeeQ/Dk3+0cybpYgk=
Date: Sun, 20 Sep 2026 20:31:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] buffer-replace-page_buffer-with-page_private-and-delete-it.patch removed from -mm tree
Message-Id: <20260921033144.180D91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: replace page_buffer() with page_private() and delete it
has been removed from the -mm tree.  Its filename was
     buffer-replace-page_buffer-with-page_private-and-delete-it.patch

This patch was dropped because an updated version will be issued

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

treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

