From: akpm@linux-foundation.org
Subject: - udf-fix-udf_debug-macro.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:17:41 -0800
Message-ID: <200802082017.m18KHMOC010807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57242 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355AbYBHUy0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:54:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, hch@lst.de, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: fix udf_debug macro
has been removed from the -mm tree.  Its filename was
     udf-fix-udf_debug-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: udf: fix udf_debug macro
From: Marcin Slusarz <marcin.slusarz@gmail.com>

udf_debug should be enclosed with do { } while (0)
to be safely used in code like below:
if (something)
	udf_debug();
else
	anything;
(Otherwise compiler will not compile it with:
"error: expected expression before 'else'")

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/udf_fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/udf_fs.h~udf-fix-udf_debug-macro include/linux/udf_fs.h
--- a/include/linux/udf_fs.h~udf-fix-udf_debug-macro
+++ a/include/linux/udf_fs.h
@@ -39,11 +39,11 @@
 
 #ifdef UDFFS_DEBUG
 #define udf_debug(f, a...) \
-	{ \
+	do { \
 		printk (KERN_DEBUG "UDF-fs DEBUG %s:%d:%s: ", \
 			__FILE__, __LINE__, __FUNCTION__); \
 		printk (f, ##a); \
-	}
+	} while (0)
 #else
 #define udf_debug(f, a...) /**/
 #endif
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
