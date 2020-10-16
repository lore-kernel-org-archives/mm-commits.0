Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37FCDC43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC32821D81
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881686;
	bh=ecU06RBuCODHwcejmnsIROXe/UhF0RUQT7k2HUkQRKg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vDKDJ33oOlsuJmeGhZsMws9bqRgB584FvjMZGTvj1tzILIU4U8R7gJL01id/bFVI5
	 BslndV5nToo5knMOWWQmEb69BwkE/NerbrM8CAi7yVL1Ah9gfn9HgtxphG2Z8tuCps
	 RMQv5JYjHC0SQxU3x5K8fYWmHngUTPuGaGDuL/Pg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390365AbgJPUyq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732596AbgJPUyq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:54:46 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAE0B21D40;
        Fri, 16 Oct 2020 20:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881685;
        bh=ecU06RBuCODHwcejmnsIROXe/UhF0RUQT7k2HUkQRKg=;
        h=Date:From:To:Subject:From;
        b=NzGa/z6ip0K55G4D/6aQxoHHn7N1SaIfHtSGMr/5giM+lp2dt3EiLg+Al51GdNkD8
         mBbaYayZ/RadydMqjjR14lJpPUeS2mzEk5cKOG+93Sq40JwbJwBpMUqacJeBrVMWJ5
         ni5kykNf2JPyp8+0GFBK7R+yuMfz36gzKQrVWe/o=
Date:   Fri, 16 Oct 2020 13:54:44 -0700
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, hch@lst.de, hughd@google.com,
        jannh@google.com, mm-commits@vger.kernel.org, oleg@redhat.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [merged] mm-gup-take-mmap_lock-in-get_dump_page.patch
 removed from -mm tree
Message-ID: <20201016205444.1SJb2DzWa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: take mmap_lock in get_dump_page()
has been removed from the -mm tree.  Its filename was
     mm-gup-take-mmap_lock-in-get_dump_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/gup: take mmap_lock in get_dump_page()

Properly take the mmap_lock before calling into the GUP code from
get_dump_page(); and play nice, allowing the GUP code to drop the
mmap_lock if it has to sleep.

As Linus pointed out, we don't actually need the VMA because
__get_user_pages() will flush the dcache for us if necessary.

Link: http://lkml.kernel.org/r/20200827114932.3572699-7-jannh@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/mm/gup.c~mm-gup-take-mmap_lock-in-get_dump_page
+++ a/mm/gup.c
@@ -1547,19 +1547,23 @@ finish_or_fault:
  * NULL wherever the ZERO_PAGE, or an anonymous pte_none, has been found -
  * allowing a hole to be left in the corefile to save diskspace.
  *
- * Called without mmap_lock, but after all other threads have been killed.
+ * Called without mmap_lock (takes and releases the mmap_lock by itself).
  */
 #ifdef CONFIG_ELF_CORE
 struct page *get_dump_page(unsigned long addr)
 {
-	struct vm_area_struct *vma;
+	struct mm_struct *mm = current->mm;
 	struct page *page;
+	int locked = 1;
+	int ret;
 
-	if (__get_user_pages_locked(current->mm, addr, 1, &page, &vma, NULL,
-				    FOLL_FORCE | FOLL_DUMP | FOLL_GET) < 1)
+	if (mmap_read_lock_killable(mm))
 		return NULL;
-	flush_cache_page(vma, addr, page_to_pfn(page));
-	return page;
+	ret = __get_user_pages_locked(mm, addr, 1, &page, NULL, &locked,
+				      FOLL_FORCE | FOLL_DUMP | FOLL_GET);
+	if (locked)
+		mmap_read_unlock(mm);
+	return (ret == 1) ? page : NULL;
 }
 #endif /* CONFIG_ELF_CORE */
 
_

Patches currently in -mm which might be from jannh@google.com are

mm-gup_benchmark-take-the-mmap-lock-around-gup.patch
binfmt_elf-take-the-mmap-lock-around-find_extend_vma.patch
mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch
mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch

