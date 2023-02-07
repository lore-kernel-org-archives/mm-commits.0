Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C04FC05027
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjBGBEL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBGBEK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:04:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFF62ED60
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:04:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B6F4B8164F
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394C5C433D2;
        Tue,  7 Feb 2023 01:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675731846;
        bh=6JDJfhRgYHLRfKmy3Fdm5b2zBsWCbQHJKfX0FMOrzDk=;
        h=Date:To:From:Subject:From;
        b=m+kIMI/PDS6X/fBS3tKoxNLfOLdd1pbKkjJCvsj3ERPTn9JoIf5Ug/LMEXPBAOGzs
         i2YIxzu/KJSE7oW8uuil58HFRtC+SrSWuTG4CJELoJsIucgEcS+IWy6YOrdK9SeCr0
         YH8DolDORIO+IsbDdpxn49O9Cd6eyOHX0AFLmnvY=
Date:   Mon, 06 Feb 2023 17:04:05 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, surenb@google.com,
        shakeelb@google.com, rientjes@google.com,
        quic_pkondeti@quicinc.com, quic_charante@quicinc.com,
        mhocko@suse.com, markhemm@googlemail.com, hughd@google.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-add-mapping_read_folio_gfp.patch added to mm-unstable branch
Message-Id: <20230207010406.394C5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: add mapping_read_folio_gfp()
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-add-mapping_read_folio_gfp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-add-mapping_read_folio_gfp.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: add mapping_read_folio_gfp()
Date: Mon, 6 Feb 2023 16:25:19 +0000

This is like read_cache_page_gfp() except it returns the folio instead
of the precise page.

Link: https://lkml.kernel.org/r/20230206162520.4029022-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mark Hemment <markhemm@googlemail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/pagemap.h~filemap-add-mapping_read_folio_gfp
+++ a/include/linux/pagemap.h
@@ -756,6 +756,8 @@ static inline struct page *grab_cache_pa
 
 struct folio *read_cache_folio(struct address_space *, pgoff_t index,
 		filler_t *filler, struct file *file);
+struct folio *mapping_read_folio_gfp(struct address_space *, pgoff_t index,
+		gfp_t flags);
 struct page *read_cache_page(struct address_space *, pgoff_t index,
 		filler_t *filler, struct file *file);
 extern struct page * read_cache_page_gfp(struct address_space *mapping,
--- a/mm/filemap.c~filemap-add-mapping_read_folio_gfp
+++ a/mm/filemap.c
@@ -3585,6 +3585,30 @@ struct folio *read_cache_folio(struct ad
 }
 EXPORT_SYMBOL(read_cache_folio);
 
+/**
+ * mapping_read_folio_gfp - Read into page cache, using specified allocation flags.
+ * @mapping:	The address_space for the folio.
+ * @index:	The index that the allocated folio will contain.
+ * @gfp:	The page allocator flags to use if allocating.
+ *
+ * This is the same as "read_cache_folio(mapping, index, NULL, NULL)", but with
+ * any new memory allocations done using the specified allocation flags.
+ *
+ * The most likely error from this function is EIO, but ENOMEM is
+ * possible and so is EINTR.  If ->read_folio returns another error,
+ * that will be returned to the caller.
+ *
+ * The function expects mapping->invalidate_lock to be already held.
+ *
+ * Return: Uptodate folio on success, ERR_PTR() on failure.
+ */
+struct folio *mapping_read_folio_gfp(struct address_space *mapping,
+		pgoff_t index, gfp_t gfp)
+{
+	return do_read_cache_folio(mapping, index, NULL, NULL, gfp);
+}
+EXPORT_SYMBOL(mapping_read_folio_gfp);
+
 static struct page *do_read_cache_page(struct address_space *mapping,
 		pgoff_t index, filler_t *filler, struct file *file, gfp_t gfp)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-memcpy_from_file_folio.patch
filemap-add-mapping_read_folio_gfp.patch
shmem-add-shmem_read_folio-and-shmem_read_folio_gfp.patch
shmem-fix-w=1-build-warnings-with-config_shmem=n.patch

