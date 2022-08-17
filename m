Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E55E1C32772
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 20:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242167AbiHQU52 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 16:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242132AbiHQU5R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 16:57:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB35AB1BA
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 13:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 583AA615AE
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 20:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5F5C433D6;
        Wed, 17 Aug 2022 20:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660769822;
        bh=HUASkUF9jsALg0R4CPn7gXbli+U0oy1iZURkrTZPvRk=;
        h=Date:To:From:Subject:From;
        b=AOW1l4bKqHd6g7MBC/CGhaU/pmvUkYc2Z3374fTyVz4micnWyGrTBTyIzZ1OndK1W
         qqfYkxcbm5Xau9Sx7Unmx7aAJE7kRh3I841OmkIycEosV7JqfwIGsSyyCcw6qse+yW
         cpG2amPOTSbq8K1XrG5qBbl/wH2+U+5czcqdiebU=
Date:   Wed, 17 Aug 2022 13:57:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tkjos@android.com,
        syzbot+a7b60a176ec13cafb793@syzkaller.appspotmail.com,
        surenb@google.com, omosnace@redhat.com, minchan@kernel.org,
        maco@android.com, Liam.Howlett@oracle.com, joel@joelfernandes.org,
        hridya@google.com, gregkh@linuxfoundation.org, cmllamas@google.com,
        brauner@kernel.org, arve@android.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] binder_alloc-add-missing-mmap_lock-calls-when-using-the-vma.patch removed from -mm tree
Message-Id: <20220817205702.AA5F5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: binder_alloc: add missing mmap_lock calls when using the VMA
has been removed from the -mm tree.  Its filename was
     binder_alloc-add-missing-mmap_lock-calls-when-using-the-vma.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: binder_alloc: add missing mmap_lock calls when using the VMA
Date: Wed, 10 Aug 2022 16:02:25 +0000

Take the mmap_read_lock() when using the VMA in binder_alloc_print_pages()
and when checking for a VMA in binder_alloc_new_buf_locked().

It is worth noting binder_alloc_new_buf_locked() drops the VMA read lock
after it verifies a VMA exists, but may be taken again deeper in the call
stack, if necessary.

Link: https://lkml.kernel.org/r/20220810160209.1630707-1-Liam.Howlett@oracle.com
Fixes: a43cfc87caaf ("android: binder: stop saving a pointer to the VMA")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Ondrej Mosnacek <omosnace@redhat.com>
Reported-by: <syzbot+a7b60a176ec13cafb793@syzkaller.appspotmail.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Tested-by: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Martijn Coenen <maco@android.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Arve Hjønnevåg" <arve@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/android/binder_alloc.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/drivers/android/binder_alloc.c~binder_alloc-add-missing-mmap_lock-calls-when-using-the-vma
+++ a/drivers/android/binder_alloc.c
@@ -402,12 +402,15 @@ static struct binder_buffer *binder_allo
 	size_t size, data_offsets_size;
 	int ret;
 
+	mmap_read_lock(alloc->vma_vm_mm);
 	if (!binder_alloc_get_vma(alloc)) {
+		mmap_read_unlock(alloc->vma_vm_mm);
 		binder_alloc_debug(BINDER_DEBUG_USER_ERROR,
 				   "%d: binder_alloc_buf, no vma\n",
 				   alloc->pid);
 		return ERR_PTR(-ESRCH);
 	}
+	mmap_read_unlock(alloc->vma_vm_mm);
 
 	data_offsets_size = ALIGN(data_size, sizeof(void *)) +
 		ALIGN(offsets_size, sizeof(void *));
@@ -929,17 +932,23 @@ void binder_alloc_print_pages(struct seq
 	 * Make sure the binder_alloc is fully initialized, otherwise we might
 	 * read inconsistent state.
 	 */
-	if (binder_alloc_get_vma(alloc) != NULL) {
-		for (i = 0; i < alloc->buffer_size / PAGE_SIZE; i++) {
-			page = &alloc->pages[i];
-			if (!page->page_ptr)
-				free++;
-			else if (list_empty(&page->lru))
-				active++;
-			else
-				lru++;
-		}
+
+	mmap_read_lock(alloc->vma_vm_mm);
+	if (binder_alloc_get_vma(alloc) == NULL)
+		goto uninitialized;
+
+	for (i = 0; i < alloc->buffer_size / PAGE_SIZE; i++) {
+		page = &alloc->pages[i];
+		if (!page->page_ptr)
+			free++;
+		else if (list_empty(&page->lru))
+			active++;
+		else
+			lru++;
 	}
+
+uninitialized:
+	mmap_read_unlock(alloc->vma_vm_mm);
 	mutex_unlock(&alloc->mutex);
 	seq_printf(m, "  pages: %d:%d:%d\n", active, lru, free);
 	seq_printf(m, "  pages high watermark: %zu\n", alloc->pages_high);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


