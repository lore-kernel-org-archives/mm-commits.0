Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C8CC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Apr 2022 02:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiDOCP7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 22:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346792AbiDOCP5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 22:15:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D3F1FCE9
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 19:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC429B82B5F
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 02:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D31EC385A1;
        Fri, 15 Apr 2022 02:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649988808;
        bh=DOqXlO2fX9k0E4ccfUNitl7EDptnTlmMx3IKUuoxw6U=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=tXji3r7X2uwvmKZrmmks32QYuuffgXjTG3sMMZGDLpKCLa1apxQAaDALWrtXnk98p
         iMywRPC2Hs70/LOvNfFji/KU/wGv90EmPJ6adH82ChdbQ3kPYq7NMVxE0DuaLbWW2F
         vBZLeFxFJIAjP9JajSJQLsz3vBSstpeHU1HDboSI=
Date:   Thu, 14 Apr 2022 19:13:27 -0700
To:     patrice.chotard@foss.st.com, mpatocka@redhat.com,
        markhemm@googlemail.com, lczerner@redhat.com, hch@lst.de,
        djwong@kernel.org, chuck.lever@oracle.com, hughd@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
Subject: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
Message-Id: <20220415021328.7D31EC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
