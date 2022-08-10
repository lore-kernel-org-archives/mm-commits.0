Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65F4C19F2D
	for <mm-commits@archiver.kernel.org>; Wed, 10 Aug 2022 01:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiHJBal (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Aug 2022 21:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiHJBaS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2022 21:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22046137
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 18:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B241061255
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 01:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0847FC433C1;
        Wed, 10 Aug 2022 01:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660095015;
        bh=+TtklDUhekqwzPOgJBVcT1H5jYzG3WoHU+6YH/KVvCQ=;
        h=Date:To:From:Subject:From;
        b=eimkyu5dXODAgECLPSHqa8Xtj7hc4q+HvZING7tVuMH9UAl8boc2okc0sqFxHuker
         jWrPi3Qrifr0Pd87wqdn0vOWpQ0SzocftJe7VEk8vMKRSTCtJTxjYiP3VKLRpV+0dI
         2iqhYsu1UF/5YQhcm6d8AawmoT3UQoRNfId1QXTo=
Date:   Tue, 09 Aug 2022 18:30:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tkjos@android.com,
        surenb@google.com, omosnace@redhat.com, minchan@kernel.org,
        maco@android.com, Liam.Howlett@oracle.com, joel@joelfernandes.org,
        hridya@google.com, gregkh@linuxfoundation.org, cmllamas@google.com,
        brauner@kernel.org, arve@android.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + binder_alloc-add-missing-mmap_lock-calls-when-using-the-vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20220810013015.0847FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: binder_alloc: add missing mmap_lock calls when using the VMA
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     binder_alloc-add-missing-mmap_lock-calls-when-using-the-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/binder_alloc-add-missing-mmap_lock-calls-when-using-the-vma.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: binder_alloc: add missing mmap_lock calls when using the VMA
Date: Tue, 9 Aug 2022 16:06:31 +0000

Take the mmap_read_lock() when using the VMA in binder_alloc_print_pages()
and when checking for a VMA in binder_alloc_new_buf_locked().

It is worth noting binder_alloc_new_buf_locked() drops the VMA read lock
after it verifies a VMA exists, but may be taken again deeper in the call
stack, if necessary.

Link: https://lkml.kernel.org/r/20220809160618.1052539-1-Liam.Howlett@oracle.com
Fixes: a43cfc87caaf ("android: binder: stop saving a pointer to the VMA")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Ondrej Mosnacek <omosnace@redhat.com>
Reported-by: syzbot+a7b60a176ec13cafb793@syzkaller.appspotmail.com
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
Cc: Carlos Llamas <cmllamas@google.com>
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

binder_alloc-add-missing-mmap_lock-calls-when-using-the-vma.patch

