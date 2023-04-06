Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 383C5C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbjDFCsa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234955AbjDFCrj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:47:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A1FA240
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 295F4642A2
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77084C433D2;
        Thu,  6 Apr 2023 02:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749134;
        bh=yRcJp08uMHI+ZFshCgA6PwCbzuI2x63t9oepk86iPAQ=;
        h=Date:To:From:Subject:From;
        b=IuncX5nTd7/g+DXsnPg3l4v4Twyy9X8zYuWBA+ENXnV5L6xr1XU7JwW6Wt9rQ4ARe
         7u7/g40HsmEbafpndocdJbj0tJFKpk6l32rfs0/kXasOGo7byadXDuyA7BjveVyXJD
         UZrJwCiQC0kFBXS0f2SsibzUzSVyW+6QcawbtKLM=
Date:   Wed, 05 Apr 2023 19:45:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, urezki@gmail.com, liushixin2@huawei.com,
        jolsa@kernel.org, david@redhat.com, bhe@redhat.com,
        axboe@kernel.dk, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] iov_iter-add-copy_page_to_iter_nofault.patch removed from -mm tree
Message-Id: <20230406024534.77084C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: iov_iter: add copy_page_to_iter_nofault()
has been removed from the -mm tree.  Its filename was
     iov_iter-add-copy_page_to_iter_nofault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: iov_iter: add copy_page_to_iter_nofault()
Date: Wed, 22 Mar 2023 18:57:03 +0000

Provide a means to copy a page to user space from an iterator, aborting if
a page fault would occur.  This supports compound pages, but may be passed
a tail page with an offset extending further into the compound page, so we
cannot pass a folio.

This allows for this function to be called from atomic context and _try_
to user pages if they are faulted in, aborting if not.

The function does not use _copy_to_iter() in order to not specify
might_fault(), this is similar to copy_page_from_iter_atomic().

This is being added in order that an iteratable form of vread() can be
implemented while holding spinlocks.

Link: https://lkml.kernel.org/r/19734729defb0f498a76bdec1bef3ac48a3af3e8.1679511146.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uio.h |    2 +
 lib/iov_iter.c      |   48 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

--- a/include/linux/uio.h~iov_iter-add-copy_page_to_iter_nofault
+++ a/include/linux/uio.h
@@ -173,6 +173,8 @@ static inline size_t copy_folio_to_iter(
 {
 	return copy_page_to_iter(&folio->page, offset, bytes, i);
 }
+size_t copy_page_to_iter_nofault(struct page *page, unsigned offset,
+				 size_t bytes, struct iov_iter *i);
 
 static __always_inline __must_check
 size_t copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
--- a/lib/iov_iter.c~iov_iter-add-copy_page_to_iter_nofault
+++ a/lib/iov_iter.c
@@ -172,6 +172,18 @@ static int copyout(void __user *to, cons
 	return n;
 }
 
+static int copyout_nofault(void __user *to, const void *from, size_t n)
+{
+	long res;
+
+	if (should_fail_usercopy())
+		return n;
+
+	res = copy_to_user_nofault(to, from, n);
+
+	return res < 0 ? n : res;
+}
+
 static int copyin(void *to, const void __user *from, size_t n)
 {
 	size_t res = n;
@@ -734,6 +746,42 @@ size_t copy_page_to_iter(struct page *pa
 }
 EXPORT_SYMBOL(copy_page_to_iter);
 
+size_t copy_page_to_iter_nofault(struct page *page, unsigned offset, size_t bytes,
+				 struct iov_iter *i)
+{
+	size_t res = 0;
+
+	if (!page_copy_sane(page, offset, bytes))
+		return 0;
+	if (WARN_ON_ONCE(i->data_source))
+		return 0;
+	if (unlikely(iov_iter_is_pipe(i)))
+		return copy_page_to_iter_pipe(page, offset, bytes, i);
+	page += offset / PAGE_SIZE; // first subpage
+	offset %= PAGE_SIZE;
+	while (1) {
+		void *kaddr = kmap_local_page(page);
+		size_t n = min(bytes, (size_t)PAGE_SIZE - offset);
+
+		iterate_and_advance(i, n, base, len, off,
+			copyout_nofault(base, kaddr + offset + off, len),
+			memcpy(base, kaddr + offset + off, len)
+		)
+		kunmap_local(kaddr);
+		res += n;
+		bytes -= n;
+		if (!bytes || !n)
+			break;
+		offset += n;
+		if (offset == PAGE_SIZE) {
+			page++;
+			offset = 0;
+		}
+	}
+	return res;
+}
+EXPORT_SYMBOL(copy_page_to_iter_nofault);
+
 size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i)
 {
_

Patches currently in -mm which might be from lstoakes@gmail.com are


