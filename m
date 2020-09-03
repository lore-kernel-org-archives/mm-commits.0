Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE63C433E9
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 803FE20DD4
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599161103;
	bh=i9MATadk5UsL1Y2VfLQxcwhQHv0Iro05HlvuQDkLxz0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=B/XrZ2C+e8WwyEQY96eYPigsBsIqfiux/gDPdA3s6jzIbvPdWhyJLbL6gzaj36kXZ
	 RnDhW2wD8iF3yB+VpHTledno1TeSl3PobYJco3Rx0E1T13V9l2jB3U92N2LTZl0JeP
	 hn8QBaGOER+Cj71l8/bD4bcTJ93zllD8nrwSSM6Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgICTZD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729096AbgICTZB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 15:25:01 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8A422098B;
        Thu,  3 Sep 2020 19:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599161100;
        bh=i9MATadk5UsL1Y2VfLQxcwhQHv0Iro05HlvuQDkLxz0=;
        h=Date:From:To:Subject:From;
        b=ctIGLfzz7rRsTSyh2EtVT07m7CSwgwIHeqRHoEJdLhu2jETR3n4A7xuDPEfZqXjW8
         aqVGOFmWnrbXM0tRlWiGEyNIjCI6uSOR8b5/VG5WB/QWQ6WtleQa1giBg2apd3dRPP
         7BBHIcPnj0+tZwROxwN+iot7Bfj/o/Cu77XH7PUM=
Date:   Thu, 03 Sep 2020 12:25:00 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ebiggers@google.com, dhowells@redhat.com
Subject:  +
 mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead.patch added to -mm tree
Message-ID: <20200903192500.cpX9U%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: fold ra_submit into do_sync_mmap_readahead
has been added to the -mm tree.  Its filename is
     mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: mm/filemap: fold ra_submit into do_sync_mmap_readahead

Fold ra_submit() into its last remaining user and pass the
readahead_control struct to both do_page_cache_ra() and
page_cache_sync_ra().

Link: https://lkml.kernel.org/r/20200903140844.14194-9-willy@infradead.org
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c  |   10 +++++-----
 mm/internal.h |   10 ----------
 2 files changed, 5 insertions(+), 15 deletions(-)

--- a/mm/filemap.c~mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead
+++ a/mm/filemap.c
@@ -2486,8 +2486,8 @@ static struct file *do_sync_mmap_readahe
 	struct file *file = vmf->vma->vm_file;
 	struct file_ra_state *ra = &file->f_ra;
 	struct address_space *mapping = file->f_mapping;
+	DEFINE_READAHEAD(ractl, file, mapping, vmf->pgoff);
 	struct file *fpin = NULL;
-	pgoff_t offset = vmf->pgoff;
 	unsigned int mmap_miss;
 
 	/* If we don't want any read-ahead, don't bother */
@@ -2498,8 +2498,7 @@ static struct file *do_sync_mmap_readahe
 
 	if (vmf->vma->vm_flags & VM_SEQ_READ) {
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-		page_cache_sync_readahead(mapping, ra, file, offset,
-					  ra->ra_pages);
+		page_cache_sync_ra(&ractl, ra, ra->ra_pages);
 		return fpin;
 	}
 
@@ -2519,10 +2518,11 @@ static struct file *do_sync_mmap_readahe
 	 * mmap read-around
 	 */
 	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-	ra->start = max_t(long, 0, offset - ra->ra_pages / 2);
+	ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
 	ra->size = ra->ra_pages;
 	ra->async_size = ra->ra_pages / 4;
-	ra_submit(ra, mapping, file);
+	ractl._index = ra->start;
+	do_page_cache_ra(&ractl, ra->size, ra->async_size);
 	return fpin;
 }
 
--- a/mm/internal.h~mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead
+++ a/mm/internal.h
@@ -59,16 +59,6 @@ static inline void force_page_cache_read
 	force_page_cache_ra(&ractl, nr_to_read);
 }
 
-/*
- * Submit IO for the read-ahead request in file_ra_state.
- */
-static inline void ra_submit(struct file_ra_state *ra,
-		struct address_space *mapping, struct file *file)
-{
-	DEFINE_READAHEAD(ractl, file, mapping, ra->start);
-	do_page_cache_ra(&ractl, ra->size, ra->async_size);
-}
-
 /**
  * page_evictable - test whether a page is evictable
  * @page: the page to test
_

Patches currently in -mm which might be from dhowells@redhat.com are

fix-khugepageds-request-size-in-collapse_file.patch
mm-readahead-make-ondemand_readahead-take-a-readahead_control.patch
mm-readahead-pass-readahead_control-to-force_page_cache_ra.patch
mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead.patch
mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra.patch
mutex-subsystem-synchro-test-module.patch

