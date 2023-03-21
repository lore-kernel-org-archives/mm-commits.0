Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB019C6FD20
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 21:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjCUVPN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 17:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjCUVPL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 17:15:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F3335EF6
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 14:15:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30267B81A37
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 21:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5601C433D2;
        Tue, 21 Mar 2023 21:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679433306;
        bh=32ub5RBJSprpkaE3WFEZIHl/xjRWDfXnho8sr0VrKXc=;
        h=Date:To:From:Subject:From;
        b=Q5qefVHK+dL1RxYYcVQa+/YDeczq0pl5eU6oxuekzR7XN43/eiuAVAlkOceD2so91
         YVLitzRgDm5PEpspmofG0epbbw7c5SNmilO6vIC8FA9AsNa/CzgVWTo97CV4GpQVfj
         O2c7Oo8MUyTt+ASq57HiqZPoGKuppojSW/6Butpg=
Date:   Tue, 21 Mar 2023 14:15:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, urezki@gmail.com, liushixin2@huawei.com,
        jolsa@kernel.org, david@redhat.com, bhe@redhat.com,
        axboe@kernel.dk, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + iov_iter-add-copy_page_to_iter_atomic.patch added to mm-unstable branch
Message-Id: <20230321211506.B5601C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: iov_iter: add copy_page_to_iter_atomic()
has been added to the -mm mm-unstable branch.  Its filename is
     iov_iter-add-copy_page_to_iter_atomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iov_iter-add-copy_page_to_iter_atomic.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: iov_iter: add copy_page_to_iter_atomic()
Date: Tue, 21 Mar 2023 20:54:32 +0000

Provide an atomic context equivalent for copy_page_to_iter().  This
eschews the might_fault() check copies memory in the same way that
copy_page_from_iter_atomic() does.

This functions assumes a non-compound page, however this mimics the
existing behaviour of copy_page_from_iter_atomic().  I am keeping the
behaviour consistent between the two, deferring any such change to an
explicit folio-fication effort.

This is being added in order that an iteratable form of vread() can be
implemented with known prefaulted pages to avoid the need for mutex
locking.

Link: https://lkml.kernel.org/r/31482908634cbb68adafedb65f0b21888c194a1b.1679431886.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uio.h |    2 ++
 lib/iov_iter.c      |   28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

--- a/include/linux/uio.h~iov_iter-add-copy_page_to_iter_atomic
+++ a/include/linux/uio.h
@@ -154,6 +154,8 @@ static inline struct iovec iov_iter_iove
 
 size_t copy_page_from_iter_atomic(struct page *page, unsigned offset,
 				  size_t bytes, struct iov_iter *i);
+size_t copy_page_to_iter_atomic(struct page *page, unsigned offset,
+				size_t bytes, struct iov_iter *i);
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
 void iov_iter_revert(struct iov_iter *i, size_t bytes);
 size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t bytes);
--- a/lib/iov_iter.c~iov_iter-add-copy_page_to_iter_atomic
+++ a/lib/iov_iter.c
@@ -821,6 +821,34 @@ size_t copy_page_from_iter_atomic(struct
 }
 EXPORT_SYMBOL(copy_page_from_iter_atomic);
 
+size_t copy_page_to_iter_atomic(struct page *page, unsigned offset, size_t bytes,
+				struct iov_iter *i)
+{
+	char *kaddr = kmap_local_page(page);
+	char *p = kaddr + offset;
+	size_t copied = 0;
+
+	if (!page_copy_sane(page, offset, bytes) ||
+	    WARN_ON_ONCE(i->data_source))
+		goto out;
+
+	if (unlikely(iov_iter_is_pipe(i))) {
+		copied = copy_page_to_iter_pipe(page, offset, bytes, i);
+		goto out;
+	}
+
+	iterate_and_advance(i, bytes, base, len, off,
+		copyout(base, p + off, len),
+		memcpy(base, p + off, len)
+	)
+	copied = bytes;
+
+out:
+	kunmap_local(kaddr);
+	return copied;
+}
+EXPORT_SYMBOL(copy_page_to_iter_atomic);
+
 static void pipe_advance(struct iov_iter *i, size_t size)
 {
 	struct pipe_inode_info *pipe = i->pipe;
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch
mm-refactor-do_fault_around.patch
mm-pefer-fault_around_pages-to-fault_around_bytes.patch
maintainers-add-myself-as-vmalloc-reviewer.patch
mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch
mm-mmap-vma_merge-further-improve-prev-next-vma-naming.patch
mm-mmap-vma_merge-set-next-to-null-if-not-applicable.patch
mm-mmap-vma_merge-extend-invariants-avoid-invalid-res-vma.patch
mm-mmap-vma_merge-init-cleanup-be-explicit-about-the-non-mergeable-case.patch
fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch
fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch
iov_iter-add-copy_page_to_iter_atomic.patch
mm-vmalloc-convert-vread-to-vread_iter.patch

