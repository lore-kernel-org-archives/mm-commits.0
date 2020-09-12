Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D74DC43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14F1620732
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599927937;
	bh=yS6SthFJtTBJQa7+q5CbHQrx90GtvLY3VZOX5JuOHa0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0mqzSBWiNJ3u5+6db9IPG+76k1cI4PDadBZM3UhAGRgJUhP7WHgOabBZE0LCZn8B2
	 aa59DbEREbUMat/BbP+NraPKli1f70WzOZ5k9hzEps+tZNkwvWyXBW1ww1v88EKZ+v
	 jFeTfUdQ8/p3aTjosiOPADwV4/hg6GnrFfNIo4Cc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgILQZ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgILQYN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 12:24:13 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 619C121D6C;
        Sat, 12 Sep 2020 16:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599927852;
        bh=yS6SthFJtTBJQa7+q5CbHQrx90GtvLY3VZOX5JuOHa0=;
        h=Date:From:To:Subject:From;
        b=YhV7WVy4I9C9K2nqP2/eKTo0Opiu7JxrqWfckqjuYpxNQMZBFCBOg9ntmDvhTy4yz
         YVwV7NN6r+99Ky5sZONSrysfMVLeiWqHarJ5v2s8eo5d3O2RLRcGTvU5mrXV9689Vh
         uhKiu6DHXtM68L6dqrF81NxPt0Haw0N6PjOEfWOE=
Date:   Sat, 12 Sep 2020 09:24:12 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, ebiggers@google.com,
        mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com,
        shy828301@gmail.com, songliubraving@fb.com, willy@infradead.org
Subject:  [merged]
 fix-khugepageds-request-size-in-collapse_file.patch removed from -mm tree
Message-ID: <20200912162412.vqDpbZU6S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged.c: fix khugepaged's request size in collapse_file
has been removed from the -mm tree.  Its filename was
     fix-khugepageds-request-size-in-collapse_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: mm/khugepaged.c: fix khugepaged's request size in collapse_file

collapse_file() in khugepaged passes PAGE_SIZE as the number of pages to
be read to page_cache_sync_readahead().  The intent was probably to read a
single page.  Fix it to use the number of pages to the end of the window
instead.

Link: https://lkml.kernel.org/r/20200903140844.14194-2-willy@infradead.org
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Yang Shi <shy828301@gmail.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~fix-khugepageds-request-size-in-collapse_file
+++ a/mm/khugepaged.c
@@ -1709,7 +1709,7 @@ static void collapse_file(struct mm_stru
 				xas_unlock_irq(&xas);
 				page_cache_sync_readahead(mapping, &file->f_ra,
 							  file, index,
-							  PAGE_SIZE);
+							  end - index);
 				/* drain pagevecs to help isolate_lru_page() */
 				lru_add_drain();
 				page = find_lock_page(mapping, index);
_

Patches currently in -mm which might be from dhowells@redhat.com are

mm-readahead-make-ondemand_readahead-take-a-readahead_control.patch
mm-readahead-pass-readahead_control-to-force_page_cache_ra.patch
mm-filemap-fold-ra_submit-into-do_sync_mmap_readahead.patch
mm-readahead-pass-a-file_ra_state-into-force_page_cache_ra.patch
mutex-subsystem-synchro-test-module.patch

