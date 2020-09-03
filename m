Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A59C433E2
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17DAF20FC3
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599161105;
	bh=tyfJHC5OoddQ7lc5e4knnTK8rcoPtylpw2EMGEw0cZ8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dnGyHCcoirT62zxvNxuo20di72N3vYUdf5qFT7WzjIL+vRksQl/2L0JKQA/XPGS3P
	 cFR4PdS/htVpBOb40OaPksDumGoAfwk5h3Yy0HN2u+G3/8Ej9T5BdCtRFdLWojSLLP
	 0YqX6/BXWXBepghSr9Cty07oxSxjI6YF1sOxG4P4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgICTZE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729115AbgICTZD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 15:25:03 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6FBC20BED;
        Thu,  3 Sep 2020 19:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599161102;
        bh=tyfJHC5OoddQ7lc5e4knnTK8rcoPtylpw2EMGEw0cZ8=;
        h=Date:From:To:Subject:From;
        b=BRJxsDwPWvS/eITaHvD7kUa3zhj+tyOsQd+ja+ilcvB6LOqcgBaCiCJIjlN/MKR3D
         4rriDkFQUQUlS9R5/3SCTH1LZKkw7eOAOYqKqEnZMQnyxS319eAxurtATrx1Zh8EIs
         lu3d9/lC1ezxNNQM2AQ6uxRvKo1UaxDrngeBSZ6U=
Date:   Thu, 03 Sep 2020 12:25:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ebiggers@google.com, dhowells@redhat.com
Subject:  +
 mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra.patch added to -mm
 tree
Message-ID: <20200903192502.64H_Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/readahead: pass a file_ra_state into force_page_cache_ra
has been added to the -mm tree.  Its filename is
     mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra.patch

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
Subject: mm/readahead: pass a file_ra_state into force_page_cache_ra

The file_ra_state being passed into page_cache_sync_readahead() was being
ignored in favour of using the one embedded in the struct file.  The only
caller for which this makes a difference is the fsverity code if the file
has been marked as POSIX_FADV_RANDOM, but it's confusing and worth fixing.

Link: https://lkml.kernel.org/r/20200903140844.14194-10-willy@infradead.org
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |    5 +++--
 mm/readahead.c |    5 ++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/mm/internal.h~mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra
+++ a/mm/internal.h
@@ -51,12 +51,13 @@ void unmap_page_range(struct mmu_gather
 
 void do_page_cache_ra(struct readahead_control *, unsigned long nr_to_read,
 		unsigned long lookahead_size);
-void force_page_cache_ra(struct readahead_control *, unsigned long nr);
+void force_page_cache_ra(struct readahead_control *, struct file_ra_state *,
+		unsigned long nr);
 static inline void force_page_cache_readahead(struct address_space *mapping,
 		struct file *file, pgoff_t index, unsigned long nr_to_read)
 {
 	DEFINE_READAHEAD(ractl, file, mapping, index);
-	force_page_cache_ra(&ractl, nr_to_read);
+	force_page_cache_ra(&ractl, &file->f_ra, nr_to_read);
 }
 
 /**
--- a/mm/readahead.c~mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra
+++ a/mm/readahead.c
@@ -272,11 +272,10 @@ void do_page_cache_ra(struct readahead_c
  * memory at once.
  */
 void force_page_cache_ra(struct readahead_control *ractl,
-		unsigned long nr_to_read)
+		struct file_ra_state *ra, unsigned long nr_to_read)
 {
 	struct address_space *mapping = ractl->mapping;
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
-	struct file_ra_state *ra = &ractl->file->f_ra;
 	unsigned long max_pages, index;
 
 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages &&
@@ -562,7 +561,7 @@ void page_cache_sync_ra(struct readahead
 
 	/* be dumb */
 	if (ractl->file && (ractl->file->f_mode & FMODE_RANDOM)) {
-		force_page_cache_ra(ractl, req_count);
+		force_page_cache_ra(ractl, ra, req_count);
 		return;
 	}
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

fix-khugepageds-request-size-in-collapse_file.patch
mm-readahead-make-ondemand_readahead-take-a-readahead_control.patch
mm-readahead-pass-readahead_control-to-force_page_cache_ra.patch
mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead.patch
mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra.patch
mutex-subsystem-synchro-test-module.patch

