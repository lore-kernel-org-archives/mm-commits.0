From: akpm@linux-foundation.org
Subject: - lib-iomapcbad_io_access-print-0x-hex-prefix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:00:25 -0700
Message-ID: <200710180700.l9I70PQq031098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760243AbXJRHPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rene.herman@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib/iomap.c:bad_io_access(): print 0x hex prefix
has been removed from the -mm tree.  Its filename was
     lib-iomapcbad_io_access-print-0x-hex-prefix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lib/iomap.c:bad_io_access(): print 0x hex prefix
From: Rene Herman <rene.herman@gmail.com>

Be explicit about printing hex.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/iomap.c~lib-iomapcbad_io_access-print-0x-hex-prefix lib/iomap.c
--- a/lib/iomap.c~lib-iomapcbad_io_access-print-0x-hex-prefix
+++ a/lib/iomap.c
@@ -40,7 +40,7 @@ static void bad_io_access(unsigned long 
 	static int count = 10;
 	if (count) {
 		count--;
-		printk(KERN_ERR "Bad IO access at port %lx (%s)\n", port, access);
+		printk(KERN_ERR "Bad IO access at port %#lx (%s)\n", port, access);
 		WARN_ON(1);
 	}
 }
_

Patches currently in -mm which might be from rene.herman@gmail.com are

origin.patch
