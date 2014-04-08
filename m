From: akpm@linux-foundation.org
Subject: [merged]
 drivers-misc-sgi-gru-grukdumpc-cleanup-gru_dump_context-a-little.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:31:13 -0700
Message-ID: <53446aa1.iiCimDbxrDCUJUft%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbaDHVbO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:31:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sivanich@sgi.com, dan.carpenter@oracle.com

Subject: [merged] drivers-misc-sgi-gru-grukdumpc-cleanup-gru_dump_context-a-little.patch removed from -mm tree
To: dan.carpenter@oracle.com,sivanich@sgi.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:31:13 -0700


The patch titled
     Subject: drivers/misc/sgi-gru/grukdump.c: cleanup gru_dump_context() a little
has been removed from the -mm tree.  Its filename was
     drivers-misc-sgi-gru-grukdumpc-cleanup-gru_dump_context-a-little.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/misc/sgi-gru/grukdump.c: cleanup gru_dump_context() a little

"ret" is zero here so we can remove the "!ret" part of the condition.
"uhdr" is alread a __user pointer so we can remove the cast.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukdump.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/misc/sgi-gru/grukdump.c~drivers-misc-sgi-gru-grukdumpc-cleanup-gru_dump_context-a-little drivers/misc/sgi-gru/grukdump.c
--- a/drivers/misc/sgi-gru/grukdump.c~drivers-misc-sgi-gru-grukdumpc-cleanup-gru_dump_context-a-little
+++ a/drivers/misc/sgi-gru/grukdump.c
@@ -178,10 +178,10 @@ static int gru_dump_context(struct gru_s
 	hdr.cbrcnt = cbrcnt;
 	hdr.dsrcnt = dsrcnt;
 	hdr.cch_locked = cch_locked;
-	if (!ret && copy_to_user((void __user *)uhdr, &hdr, sizeof(hdr)))
-		ret = -EFAULT;
+	if (copy_to_user(uhdr, &hdr, sizeof(hdr)))
+		return -EFAULT;
 
-	return ret ? ret : bytes;
+	return bytes;
 }
 
 int gru_dump_chiplet_request(unsigned long arg)
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
ncpfs-cleanup-indenting-in-ncp_lookup.patch

