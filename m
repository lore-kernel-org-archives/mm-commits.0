From: akpm@linux-foundation.org
Subject: + fs-introduce-write_begin-write_end-and-perform_write-aops-fix-5.patch added to -mm tree
Date: Tue, 26 Jun 2007 15:42:41 -0700
Message-ID: <200706262242.l5QMgfMD003943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020AbXFZWnZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 18:43:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@sw.ru, dmonakhov@openvz.org, nickpiggin@yahoo.com.au


The patch titled
     new aop block_write_begin fix
has been added to the -mm tree.  Its filename is
     fs-introduce-write_begin-write_end-and-perform_write-aops-fix-5.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: new aop block_write_begin fix
From: Dmitriy Monakhov <dmonakhov@sw.ru>

After we enter to block_write_begin with *pagep == NULL and some page was
grabed we remember this page in *pagep And if __block_prepare_write() we
have to clear *pagep , as it was before.  Because this may confuse caller. 
for example caller may have folowing code:

 		ret = block_write_begin(..., pagep,...)
 		if (ret && *pagep != NULL) {
 			unlock_page(*pagep);
 			page_cache_release(*pagep);
 		}

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/buffer.c~fs-introduce-write_begin-write_end-and-perform_write-aops-fix-5 fs/buffer.c
--- a/fs/buffer.c~fs-introduce-write_begin-write_end-and-perform_write-aops-fix-5
+++ a/fs/buffer.c
@@ -1951,6 +1951,7 @@ int block_write_begin(struct file *file,
 		if (ownpage) {
 			unlock_page(page);
 			page_cache_release(page);
+			*pagep = NULL;
 
 			/*
 			 * prepare_write() may have instantiated a few blocks
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

fs-introduce-write_begin-write_end-and-perform_write-aops-fix-3.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix-4.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix-5.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops-fix.patch
