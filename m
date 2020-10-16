Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6ECCC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F4AC20B1F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817979;
	bh=6modujK1KqEcnF77PHRhJ1t0xgjkAj5BhbMCyPdrZu8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=PTAf+NioKh3+LW5E4POQ8lTBG0WiN5gpOVF2+yt9VoldZBVd9s6lfRWBH8RUpjclm
	 6hBToPOc3M9TlYetW+zbM4HNzsbEBpgxIeOpQN9d33f7ptaEjaebq18YvtneKED+4x
	 qm/i5BOEu7LGV762ZJHqme6AHYGX1JWE+KScyaqo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392953AbgJPDM7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389908AbgJPDM6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:12:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19CD1208E4;
        Fri, 16 Oct 2020 03:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817978;
        bh=6modujK1KqEcnF77PHRhJ1t0xgjkAj5BhbMCyPdrZu8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WMDcetgzEeSd8kcQkCBgzltOscAhe6ICuji1Kwwb16Ysx9fLQE03phMXQE0LULfdX
         iT5HUGbCFWX1GmukuTN4InbMiNLo1cSzOa3+9i0a6iDuKpohH1swr0nQJ0HrCpIhVo
         x8E1LyWy5T6pNiz+wBm4Y0px9XY0przsA7nKZYgk=
Date:   Thu, 15 Oct 2020 20:12:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ebiederm@xmission.com, hch@lst.de,
        hughd@google.com, jannh@google.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 141/156] mm/gup: take mmap_lock in get_dump_page()
Message-ID: <20201016031257.VT__Apprg%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
