Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB84FC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjBJA4g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjBJAzM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583DF6F235
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA6CEB82397
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86196C4339C;
        Fri, 10 Feb 2023 00:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990451;
        bh=9Yqz2jAL0WdH9wcbiWcANiKRvcLM8bl1wlA/aOVtrXU=;
        h=Date:To:From:Subject:From;
        b=2h9W/q1ZNYjbYE9gl0FNILXTNI3j7Edvn2LH0l6cPoFLXkaiz0dOL5QSyDKpIFfK/
         m6LViwK5lVyXQUYVsLwvw+PImUXFZPxYhgGnqnCcmYuXW04PPXxynrMQV9ySc8Jeya
         H6DiFLqQu9wZwwAaQEHWZ+dHSvU6XzUDrQjpRFGY=
Date:   Thu, 09 Feb 2023 16:54:11 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, surenb@google.com,
        shakeelb@google.com, rientjes@google.com,
        quic_pkondeti@quicinc.com, quic_charante@quicinc.com,
        mhocko@suse.com, markhemm@googlemail.com, hughd@google.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-add-mapping_read_folio_gfp.patch removed from -mm tree
Message-Id: <20230210005411.86196C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: add mapping_read_folio_gfp()
has been removed from the -mm tree.  Its filename was
     filemap-add-mapping_read_folio_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 include/linux/pagemap.h |    2 ++
 mm/filemap.c            |   24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

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


