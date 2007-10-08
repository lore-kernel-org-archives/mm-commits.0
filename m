From: akpm@linux-foundation.org
Subject: + fix-page-release-issue-in-filemap_fault.patch added to -mm tree
Date: Mon, 08 Oct 2007 10:08:31 -0700
Message-ID: <200710081708.l98H8VJF009828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36085 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbXJHRIj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2007 13:08:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanzheng@21cn.com, nickpiggin@yahoo.com.au


The patch titled
     fix page release issue in filemap_fault
has been added to the -mm tree.  Its filename is
     fix-page-release-issue-in-filemap_fault.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix page release issue in filemap_fault
From: "Yan Zheng" <yanzheng@21cn.com>

find_lock_page increases page's usage count, we should decrease it
before return VM_FAULT_SIGBUS

Signed-off-by: Yan Zheng<yanzheng@21cn.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/filemap.c~fix-page-release-issue-in-filemap_fault mm/filemap.c
--- a/mm/filemap.c~fix-page-release-issue-in-filemap_fault
+++ a/mm/filemap.c
@@ -1388,6 +1388,7 @@ retry_find:
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (unlikely(vmf->pgoff >= size)) {
 		unlock_page(page);
+		page_cache_release(page);
 		goto outside_data_content;
 	}
 
_

Patches currently in -mm which might be from yanzheng@21cn.com are

fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch
fix-page-release-issue-in-filemap_fault.patch
anon-inodes-use-open-coded-atomic_inc-for-the-shared-inode.patch
