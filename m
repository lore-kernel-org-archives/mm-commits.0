Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE050C433E1
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97D292063A
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529438;
	bh=RSzizehkR1ipHbdYouBsuqKpjOehGkVSqzAxkPDoBjE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Q/1PNNl0CAGB+rjSzyQwtPeG+wLaIM7flqcOcCf1ooQlyPcziwscboQ6IaIiRnEZR
	 Wg8MpjnIaLuR532Y3O9xTt712Ltwu05E6eVi5B02sPC1ChSwi/lxTYbaCRdt+4JiHk
	 N+XiFTv7RAE54O4kCP7XHuThVvyueijENz9gokfY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgHOWKh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729572AbgHOWKg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4099622D02;
        Sat, 15 Aug 2020 00:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451488;
        bh=RSzizehkR1ipHbdYouBsuqKpjOehGkVSqzAxkPDoBjE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vEyQApNQcdOgO9sNFzruf8b2wYE65t6nYfCIIusxwyMyydwS6YIH9JulBSoyeo3i/
         /zi56BGpIF0ZpPj4OEt8PhYev3QYiltACYM1zeHdd1qYhdeHMN0Eq5L+hokLDODl0f
         nUELInlkuHGHguRoIPavS00k4dIEerpELJ9fMyHg=
Date:   Fri, 14 Aug 2020 17:31:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, elver@google.com,
        kirill@shutemov.name, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 24/39] mm/filemap.c: fix a data race in
 filemap_fault()
Message-ID: <20200815003127.4HDfspt4g%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>
Subject: mm/filemap.c: fix a data race in filemap_fault()

struct file_ra_state ra.mmap_miss could be accessed concurrently during
page faults as noticed by KCSAN,

 BUG: KCSAN: data-race in filemap_fault / filemap_map_pages

 write to 0xffff9b1700a2c1b4 of 4 bytes by task 3292 on cpu 30:
  filemap_fault+0x920/0xfc0
  do_sync_mmap_readahead at mm/filemap.c:2384
  (inlined by) filemap_fault at mm/filemap.c:2486
  __xfs_filemap_fault+0x112/0x3e0 [xfs]
  xfs_filemap_fault+0x74/0x90 [xfs]
  __do_fault+0x9e/0x220
  do_fault+0x4a0/0x920
  __handle_mm_fault+0xc69/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 read to 0xffff9b1700a2c1b4 of 4 bytes by task 3313 on cpu 32:
  filemap_map_pages+0xc2e/0xd80
  filemap_map_pages at mm/filemap.c:2625
  do_fault+0x3da/0x920
  __handle_mm_fault+0xc69/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 32 PID: 3313 Comm: systemd-udevd Tainted: G        W    L 5.5.0-next-20200210+ #1
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

ra.mmap_miss is used to contribute the readahead decisions, a data race
could be undesirable.  Both the read and write is only under non-exclusive
mmap_sem, two concurrent writers could even underflow the counter.  Fix
the underflow by writing to a local variable before committing a final
store to ra.mmap_miss given a small inaccuracy of the counter should be
acceptable.

Link: http://lkml.kernel.org/r/20200211030134.1847-1-cai@lca.pw
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Qian Cai <cai@lca.pw>
Tested-by: Qian Cai <cai@lca.pw>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/filemap.c~mm-filemap-fix-a-data-race-in-filemap_fault
+++ a/mm/filemap.c
@@ -2468,6 +2468,7 @@ static struct file *do_sync_mmap_readahe
 	struct address_space *mapping = file->f_mapping;
 	struct file *fpin = NULL;
 	pgoff_t offset = vmf->pgoff;
+	unsigned int mmap_miss;
 
 	/* If we don't want any read-ahead, don't bother */
 	if (vmf->vma->vm_flags & VM_RAND_READ)
@@ -2483,14 +2484,15 @@ static struct file *do_sync_mmap_readahe
 	}
 
 	/* Avoid banging the cache line if not needed */
-	if (ra->mmap_miss < MMAP_LOTSAMISS * 10)
-		ra->mmap_miss++;
+	mmap_miss = READ_ONCE(ra->mmap_miss);
+	if (mmap_miss < MMAP_LOTSAMISS * 10)
+		WRITE_ONCE(ra->mmap_miss, ++mmap_miss);
 
 	/*
 	 * Do we miss much more than hit in this file? If so,
 	 * stop bothering with read-ahead. It will only hurt.
 	 */
-	if (ra->mmap_miss > MMAP_LOTSAMISS)
+	if (mmap_miss > MMAP_LOTSAMISS)
 		return fpin;
 
 	/*
@@ -2516,13 +2518,15 @@ static struct file *do_async_mmap_readah
 	struct file_ra_state *ra = &file->f_ra;
 	struct address_space *mapping = file->f_mapping;
 	struct file *fpin = NULL;
+	unsigned int mmap_miss;
 	pgoff_t offset = vmf->pgoff;
 
 	/* If we don't want any read-ahead, don't bother */
 	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
 		return fpin;
-	if (ra->mmap_miss > 0)
-		ra->mmap_miss--;
+	mmap_miss = READ_ONCE(ra->mmap_miss);
+	if (mmap_miss)
+		WRITE_ONCE(ra->mmap_miss, --mmap_miss);
 	if (PageReadahead(page)) {
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		page_cache_async_readahead(mapping, ra, file,
@@ -2688,6 +2692,7 @@ void filemap_map_pages(struct vm_fault *
 	unsigned long max_idx;
 	XA_STATE(xas, &mapping->i_pages, start_pgoff);
 	struct page *page;
+	unsigned int mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
 
 	rcu_read_lock();
 	xas_for_each(&xas, page, end_pgoff) {
@@ -2724,8 +2729,8 @@ void filemap_map_pages(struct vm_fault *
 		if (page->index >= max_idx)
 			goto unlock;
 
-		if (file->f_ra.mmap_miss > 0)
-			file->f_ra.mmap_miss--;
+		if (mmap_miss > 0)
+			mmap_miss--;
 
 		vmf->address += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
 		if (vmf->pte)
@@ -2745,6 +2750,7 @@ next:
 			break;
 	}
 	rcu_read_unlock();
+	WRITE_ONCE(file->f_ra.mmap_miss, mmap_miss);
 }
 EXPORT_SYMBOL(filemap_map_pages);
 
_
