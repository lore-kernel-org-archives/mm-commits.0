From: akpm@linux-foundation.org
Subject: + direct-io-fix-error-path-crashes.patch added to -mm tree
Date: Tue, 31 Jul 2007 15:32:54 -0700
Message-ID: <200707312232.l6VMWscf026132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755175AbXGaWdT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 18:33:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, gurudas.pai@oracle.com, joe.jin@oracle.com, stable@kernel.org, zach.brown@oracle.com


The patch titled
     direct-io: fix error-path crashes
has been added to the -mm tree.  Its filename is
     direct-io-fix-error-path-crashes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: direct-io: fix error-path crashes
From: Badari Pulavarty <pbadari@us.ibm.com>

Need to initialize map_bh.b_state to zero.  Otherwise, in case of a faulty
user-buffer its possible to go into dio_zero_block() and submit a page by
mistake - since it checks for buffer_new().

http://marc.info/?l=linux-kernel&m=118551339032528&w=2

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: gurudas pai <gurudas.pai@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/direct-io.c~direct-io-fix-error-path-crashes fs/direct-io.c
--- a/fs/direct-io.c~direct-io-fix-error-path-crashes
+++ a/fs/direct-io.c
@@ -974,6 +974,7 @@ direct_io_worker(int rw, struct kiocb *i
 	dio->get_block = get_block;
 	dio->end_io = end_io;
 	dio->map_bh.b_private = NULL;
+	dio->map_bh.b_state = 0;
 	dio->final_block_in_bio = -1;
 	dio->next_block_for_io = -1;
 
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

direct-io-fix-error-path-crashes.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
hugetlbfs-read-support.patch
hugetlbfs-read-support-fix.patch
ext2-statfs-improvement-for-block-and-inode-free-count.patch
fix-for-ext2-reservation.patch
