Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 007E0C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  8 Apr 2022 21:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiDHVEd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Apr 2022 17:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiDHVEc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2022 17:04:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5D5F847E
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 14:02:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4A146CE2DA7
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 21:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A853DC385A3;
        Fri,  8 Apr 2022 21:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649451743;
        bh=WtvPQSgyxuLeVRRu9TdCNNkbbtCYJ2qzKaOryHJKz44=;
        h=Date:To:From:Subject:From;
        b=pbqmf0Rxn/ZLN9M+wO0d/Z6JFEwIojq1j6Q1XKjVPsAvxwzbxv5N2YB4CF6zH0ZIm
         MGplfA91waYXwQMJ0okVdXeIfVEcxT6Je05/mzv4p2ot4IMhNNf84lEKPA1Nz90f82
         xqE6d7nUAAntRqYDlrG2XG2NnqmhR3GzrZP5yZtc=
Date:   Fri, 08 Apr 2022 14:02:22 -0700
To:     mm-commits@vger.kernel.org, patrice.chotard@foss.st.com,
        mpatocka@redhat.com, markhemm@googlemail.com, lczerner@redhat.com,
        hch@lst.de, djwong@kernel.org, chuck.lever@oracle.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-fix-regressions-from-wider-use-of-zero_page.patch added to -mm tree
Message-Id: <20220408210223.A853DC385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: fix regressions from wider use of ZERO_PAGE
has been added to the -mm tree.  Its filename is
     tmpfs-fix-regressions-from-wider-use-of-zero_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tmpfs-fix-regressions-from-wider-use-of-zero_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-fix-regressions-from-wider-use-of-zero_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: fix regressions from wider use of ZERO_PAGE

Chuck Lever reported fsx-based xfstests generic 075 091 112 127 failing
when 5.18-rc1 NFS server exports tmpfs: bisected to recent tmpfs change.

Whilst nfsd_splice_action() does contain some questionable handling of
repeated pages, and Chuck was able to work around there, history from
Mark Hemment makes clear that there might be similar dangers elsewhere:
it was not a good idea for me to pass ZERO_PAGE down to unknown actors.

Revert shmem_file_read_iter() to using ZERO_PAGE for holes only when
iter_is_iovec(); in other cases, use the more natural iov_iter_zero()
instead of copy_page_to_iter().  We would use iov_iter_zero() throughout,
but the x86 clear_user() is not nearly so well optimized as copy to user
(dd of 1T sparse tmpfs file takes 57 seconds rather than 44 seconds).

And now pagecache_init() does not need to SetPageUptodate(ZERO_PAGE(0)):
which had caused boot failure on arm noMMU STM32F7 and STM32H7 boards

Link: https://lkml.kernel.org/r/9a978571-8648-e830-5735-1f4748ce2e30@google.com
Fixes: 56a8c8eb1eaf ("tmpfs: do not allocate pages on read")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Patrice CHOTARD <patrice.chotard@foss.st.com>
Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Tested-by: Chuck Lever III <chuck.lever@oracle.com>
Cc: Mark Hemment <markhemm@googlemail.com>
Cc: Patrice CHOTARD <patrice.chotard@foss.st.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 ------
 mm/shmem.c   |   31 ++++++++++++++++++++-----------
 2 files changed, 20 insertions(+), 17 deletions(-)

--- a/mm/filemap.c~tmpfs-fix-regressions-from-wider-use-of-zero_page
+++ a/mm/filemap.c
@@ -1063,12 +1063,6 @@ void __init pagecache_init(void)
 		init_waitqueue_head(&folio_wait_table[i]);
 
 	page_writeback_init();
-
-	/*
-	 * tmpfs uses the ZERO_PAGE for reading holes: it is up-to-date,
-	 * and splice's page_cache_pipe_buf_confirm() needs to see that.
-	 */
-	SetPageUptodate(ZERO_PAGE(0));
 }
 
 /*
--- a/mm/shmem.c~tmpfs-fix-regressions-from-wider-use-of-zero_page
+++ a/mm/shmem.c
@@ -2513,7 +2513,6 @@ static ssize_t shmem_file_read_iter(stru
 		pgoff_t end_index;
 		unsigned long nr, ret;
 		loff_t i_size = i_size_read(inode);
-		bool got_page;
 
 		end_index = i_size >> PAGE_SHIFT;
 		if (index > end_index)
@@ -2570,24 +2569,34 @@ static ssize_t shmem_file_read_iter(stru
 			 */
 			if (!offset)
 				mark_page_accessed(page);
-			got_page = true;
+			/*
+			 * Ok, we have the page, and it's up-to-date, so
+			 * now we can copy it to user space...
+			 */
+			ret = copy_page_to_iter(page, offset, nr, to);
+			put_page(page);
+
+		} else if (iter_is_iovec(to)) {
+			/*
+			 * Copy to user tends to be so well optimized, but
+			 * clear_user() not so much, that it is noticeably
+			 * faster to copy the zero page instead of clearing.
+			 */
+			ret = copy_page_to_iter(ZERO_PAGE(0), offset, nr, to);
 		} else {
-			page = ZERO_PAGE(0);
-			got_page = false;
+			/*
+			 * But submitting the same page twice in a row to
+			 * splice() - or others? - can result in confusion:
+			 * so don't attempt that optimization on pipes etc.
+			 */
+			ret = iov_iter_zero(nr, to);
 		}
 
-		/*
-		 * Ok, we have the page, and it's up-to-date, so
-		 * now we can copy it to user space...
-		 */
-		ret = copy_page_to_iter(page, offset, nr, to);
 		retval += ret;
 		offset += ret;
 		index += offset >> PAGE_SHIFT;
 		offset &= ~PAGE_MASK;
 
-		if (got_page)
-			put_page(page);
 		if (!iov_iter_count(to))
 			break;
 		if (ret < nr) {
_

Patches currently in -mm which might be from hughd@google.com are

tmpfs-fix-regressions-from-wider-use-of-zero_page.patch
mm-munlock-remove-fields-to-fix-htmldocs-warnings.patch

