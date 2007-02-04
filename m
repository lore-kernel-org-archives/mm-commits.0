From: akpm@linux-foundation.org
Subject: - mm-fix-pagecache-write-deadlocks-xip.patch removed from -mm tree
Date: Sun, 04 Feb 2007 01:08:05 -0800
Message-ID: <200702040908.l14985TW026148@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34089 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbXBDJIP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 4 Feb 2007 04:08:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, cotte@freenet.de, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm-fix-pagecache-write-deadlocks: xip
has been removed from the -mm tree.  Its filename was
     mm-fix-pagecache-write-deadlocks-xip.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: mm-fix-pagecache-write-deadlocks: xip
From: Cedric Le Goater <clg@fr.ibm.com>

filemap_xip.c needs a fix also.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Carsten Otte <cotte@freenet.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/filemap_xip.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/filemap_xip.c~mm-fix-pagecache-write-deadlocks-xip mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-fix-pagecache-write-deadlocks-xip
+++ a/mm/filemap_xip.c
@@ -317,7 +317,8 @@ __xip_file_write(struct file *filp, cons
 			break;
 		}
 
-		copied = filemap_copy_from_user(page, offset, buf, bytes);
+		copied = filemap_copy_from_user_nonatomic(page, offset,
+							buf, bytes);
 		flush_dcache_page(page);
 		if (likely(copied > 0)) {
 			status = copied;
_

Patches currently in -mm which might be from clg@fr.ibm.com are

mm-fix-pagecache-write-deadlocks-xip.patch
git-acpi-fix_i386_srat.patch
kthread-api-conversion-for-dvb_frontend-and-av7110.patch
mxser-remove-useless-fields.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
