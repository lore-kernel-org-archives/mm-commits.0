Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26ECC77B75
	for <mm-commits@archiver.kernel.org>; Mon, 15 May 2023 19:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbjEOTHs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 May 2023 15:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244057AbjEOTHr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2023 15:07:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B22E15523
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 12:07:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4707631A9
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 19:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EDDC433A1;
        Mon, 15 May 2023 19:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684177662;
        bh=NWOJHf80X06mTz3e6wM8dRUZ7xy2zuM2wVADzau/FD4=;
        h=Date:To:From:Subject:From;
        b=wzVfMvoqRF2qrMaLJ0xXaCmVzoZ2p2m4L+WhGc5jj3O7IB4A2BOCfjmGLPBVN08Uw
         U3jPyqEMVdSNy21LhEc/a5lq6TUQSYckg/uyGXqZe6ycC4a4aSY8LXT1Ytl9iZymc7
         O/sC2sLNl19j+nsm7sBM003Wb5+qpS6mlWpgZnlQ=
Date:   Mon, 15 May 2023 12:07:41 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, shy828301@gmail.com, peterx@redhat.com,
        pasha.tatashin@soleen.com, Liam.Howlett@oracle.com,
        kirill.shutemov@linux.intel.com, yuanchu@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagemap-restrict-pagewalk-to-the-requested-range.patch added to mm-unstable branch
Message-Id: <20230515190742.27EDDC433A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagemap: restrict pagewalk to the requested range
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pagemap-restrict-pagewalk-to-the-requested-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagemap-restrict-pagewalk-to-the-requested-range.patch

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
From: Yuanchu Xie <yuanchu@google.com>
Subject: mm: pagemap: restrict pagewalk to the requested range
Date: Tue, 16 May 2023 01:26:08 +0800

The pagewalk in pagemap_read reads one PTE past the end of the requested
range, and stops when the buffer runs out of space. While it produces
the right result, the extra read is unnecessary and less performant.

I timed the following command before and after this patch:
	dd count=100000 if=/proc/self/pagemap of=/dev/null
The results are consistently within 0.001s across 5 runs.

Before:
100000+0 records in
100000+0 records out
51200000 bytes (51 MB) copied, 0.0763159 s, 671 MB/s

real    0m0.078s
user    0m0.012s
sys     0m0.065s

After:
100000+0 records in
100000+0 records out
51200000 bytes (51 MB) copied, 0.0487928 s, 1.0 GB/s

real    0m0.050s
user    0m0.011s
sys     0m0.039s

Link: https://lkml.kernel.org/r/20230515172608.3558391-1-yuanchu@google.com
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/proc/task_mmu.c~mm-pagemap-restrict-pagewalk-to-the-requested-range
+++ a/fs/proc/task_mmu.c
@@ -1689,23 +1689,23 @@ static ssize_t pagemap_read(struct file
 	/* watch out for wraparound */
 	start_vaddr = end_vaddr;
 	if (svpfn <= (ULONG_MAX >> PAGE_SHIFT)) {
+		unsigned long end;
+
 		ret = mmap_read_lock_killable(mm);
 		if (ret)
 			goto out_free;
 		start_vaddr = untagged_addr_remote(mm, svpfn << PAGE_SHIFT);
 		mmap_read_unlock(mm);
+
+		end = start_vaddr + ((count / PM_ENTRY_BYTES) << PAGE_SHIFT);
+		if (end >= start_vaddr && end < mm->task_size)
+			end_vaddr = end;
 	}
 
 	/* Ensure the address is inside the task */
 	if (start_vaddr > mm->task_size)
 		start_vaddr = end_vaddr;
 
-	/*
-	 * The odds are that this will stop walking way
-	 * before end_vaddr, because the length of the
-	 * user buffer is tracked in "pm", and the walk
-	 * will stop when we hit the end of the buffer.
-	 */
 	ret = 0;
 	while (count && (start_vaddr < end_vaddr)) {
 		int len;
_

Patches currently in -mm which might be from yuanchu@google.com are

mm-pagemap-restrict-pagewalk-to-the-requested-range.patch

