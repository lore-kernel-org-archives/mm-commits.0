From: akpm@linux-foundation.org
Subject: [merged] fs-affs-filec-remove-obsolete-pagesize-check.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:09:47 -0800
Message-ID: <548d0d8b.iFU4fh4JcONCD0FX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaLNEJj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:09:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/file.c: remove obsolete pagesize check
has been removed from the -mm tree.  Its filename was
     fs-affs-filec-remove-obsolete-pagesize-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/file.c: remove obsolete pagesize check

linux kernel doesn't manage page sizes below 4kb.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/affs/file.c~fs-affs-filec-remove-obsolete-pagesize-check fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-filec-remove-obsolete-pagesize-check
+++ a/fs/affs/file.c
@@ -15,10 +15,6 @@
 #include <linux/aio.h>
 #include "affs.h"
 
-#if PAGE_SIZE < 4096
-#error PAGE_SIZE must be at least 4096
-#endif
