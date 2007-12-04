From: akpm@linux-foundation.org
Subject: + mm-fix-xip-file-writes.patch added to -mm tree
Date: Tue, 04 Dec 2007 11:58:36 -0800
Message-ID: <200712041958.lB4Jwam8002271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38161 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbXLDT73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 14:59:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, borntraeger@de.ibm.com, cotte@de.ibm.com


The patch titled
     mm: fix XIP file writes
has been added to the -mm tree.  Its filename is
     mm-fix-xip-file-writes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: fix XIP file writes
From: Nick Piggin <npiggin@suse.de>

Writing to XIP files at a non-page-aligned offset results in data corruption
because the writes were always sent to the start of the page.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap_xip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap_xip.c~mm-fix-xip-file-writes mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-fix-xip-file-writes
+++ a/mm/filemap_xip.c
@@ -314,7 +314,7 @@ __xip_file_write(struct file *filp, cons
 		fault_in_pages_readable(buf, bytes);
 		kaddr = kmap_atomic(page, KM_USER0);
 		copied = bytes -
-			__copy_from_user_inatomic_nocache(kaddr, buf, bytes);
+			__copy_from_user_inatomic_nocache(kaddr + offset, buf, bytes);
 		kunmap_atomic(kaddr, KM_USER0);
 		flush_dcache_page(page);
 
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-xip-file-writes.patch
git-jfs.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
rewrite-rd.patch
rewrite-rd-fix.patch
reiser4.patch
