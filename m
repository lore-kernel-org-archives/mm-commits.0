Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64921C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 13 Nov 2023 17:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjKMRPD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Nov 2023 12:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjKMRPC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Nov 2023 12:15:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA0199
        for <mm-commits@vger.kernel.org>; Mon, 13 Nov 2023 09:14:59 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D042EC433C7;
        Mon, 13 Nov 2023 17:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699895698;
        bh=0idGtGcq+lQrfzp9hxWrIuODSYQnH96ZPkWMjp1y3wU=;
        h=Date:To:From:Subject:From;
        b=05Bcoe9HvOebtiMjvUR/Fly81Fk5GGi+HD0kG2od+xlo7VcK+HqCrtujU8FacZFjg
         +WmQvp6c4s4HMOojzsQ2kroz6AsnlRshQMbOHupQQd6GajrAe96aIPqPdeK3LfGLXG
         g6gWxQY7ONC+fBfocFKQKFxKfvyGKTDV7fRNyUBI=
Date:   Mon, 13 Nov 2023 09:14:58 -0800
To:     mm-commits@vger.kernel.org, yjnworkstation@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-process_vm_rw-page-counts.patch added to mm-unstable branch
Message-Id: <20231113171458.D042EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix process_vm_rw page counts
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-process_vm_rw-page-counts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-process_vm_rw-page-counts.patch

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
From: York Jasper Niebuhr <yjnworkstation@gmail.com>
Subject: mm: fix process_vm_rw page counts
Date: Sat, 11 Nov 2023 19:48:59 +0100

1. There is a "-1" missing in the page number calculation in
   process_vm_rw_core.  While this can't break anything, it can cause
   unnecessary allocations in certain cases:

   Consider handling an iovec ranging over PVM_MAX_PP_ARRAY_COUNT pages
   that is also aligned to a page boundary.  While pp_stack could hold
   references to such an amount of pinned pages, nr_pages yields
   (PVM_MAX_PP_ARRAY + 1) in process_vm_rw_core.  Consequently, a larger
   buffer is allocated with kmalloc for no reason.

   For any page boundary aligned iovec that is a multiple of PAGE_SIZE
   and larger than PVM_MAX_PP_ARRAY_COUNT pages, nr_pages will be too big
   by 1 and thus kmalloc allocates excess space for one more pointer.

2. max_pages_per_loop is constant and there is no reason to have it as
   a variable.  A macro does the job just fine and saves memory.

3. Replaced "sizeof(struct pages *)" with "sizeof(struct page *)" to
   have matching types for allocation and prevent confusion.

Link: https://lkml.kernel.org/r/20231111184859.44264-1-yjnworkstation@gmail.com
Signed-off-by: York Jasper Niebuhr <yjnworkstation@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/process_vm_access.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/process_vm_access.c~mm-fix-process_vm_rw-page-counts
+++ a/mm/process_vm_access.c
@@ -53,7 +53,10 @@ static int process_vm_rw_pages(struct pa
 }
 
 /* Maximum number of pages kmalloc'd to hold struct page's during copy */
-#define PVM_MAX_KMALLOC_PAGES (PAGE_SIZE * 2)
+#define PVM_MAX_KMALLOC_PAGES 2
+
+/* Maximum number of pages that can be stored at a time */
+#define PVM_MAX_USER_PAGES (PVM_MAX_KMALLOC_PAGES * PAGE_SIZE / sizeof(struct page *))
 
 /**
  * process_vm_rw_single_vec - read/write pages from task specified
@@ -79,8 +82,6 @@ static int process_vm_rw_single_vec(unsi
 	unsigned long start_offset = addr - pa;
 	unsigned long nr_pages;
 	ssize_t rc = 0;
-	unsigned long max_pages_per_loop = PVM_MAX_KMALLOC_PAGES
-		/ sizeof(struct pages *);
 	unsigned int flags = 0;
 
 	/* Work out address and page range required */
@@ -92,7 +93,7 @@ static int process_vm_rw_single_vec(unsi
 		flags |= FOLL_WRITE;
 
 	while (!rc && nr_pages && iov_iter_count(iter)) {
-		int pinned_pages = min(nr_pages, max_pages_per_loop);
+		int pinned_pages = min_t(unsigned long, nr_pages, PVM_MAX_USER_PAGES);
 		int locked = 1;
 		size_t bytes;
 
@@ -171,7 +172,7 @@ static ssize_t process_vm_rw_core(pid_t
 		iov_len = rvec[i].iov_len;
 		if (iov_len > 0) {
 			nr_pages_iov = ((unsigned long)rvec[i].iov_base
-					+ iov_len)
+					+ iov_len - 1)
 				/ PAGE_SIZE - (unsigned long)rvec[i].iov_base
 				/ PAGE_SIZE + 1;
 			nr_pages = max(nr_pages, nr_pages_iov);
@@ -184,8 +185,8 @@ static ssize_t process_vm_rw_core(pid_t
 	if (nr_pages > PVM_MAX_PP_ARRAY_COUNT) {
 		/* For reliability don't try to kmalloc more than
 		   2 pages worth */
-		process_pages = kmalloc(min_t(size_t, PVM_MAX_KMALLOC_PAGES,
-					      sizeof(struct pages *)*nr_pages),
+		process_pages = kmalloc(min_t(size_t, PVM_MAX_KMALLOC_PAGES * PAGE_SIZE,
+					      sizeof(struct page *)*nr_pages),
 					GFP_KERNEL);
 
 		if (!process_pages)
_

Patches currently in -mm which might be from yjnworkstation@gmail.com are

mm-fix-process_vm_rw-page-counts.patch

