From: akpm@linux-foundation.org
Subject: +
 drivers-misc-sgi-gru-grukdumpc-cleanup-gru_dump_context-a-little.patch
 added to -mm tree
Date: Fri, 31 Jan 2014 13:28:38 -0800
Message-ID: <52ec1586.td+PNgGUfuDhyMnS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaAaV2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 16:28:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sivanich@sgi.com, dan.carpenter@oracle.com

Subject: + drivers-misc-sgi-gru-grukdumpc-cleanup-gru_dump_context-a-little.patch added to -mm tree
To: dan.carpenter@oracle.com,sivanich@sgi.com
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 13:28:38 -0800


The patch titled
     Subject: drivers/misc/sgi-gru/grukdump.c: cleanup gru_dump_context() a little
has been added to the -mm tree.  Its filename is
     drivers-misc-sgi-gru-grukdumpc-cleanup-gru_dump_context-a-little.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-misc-sgi-gru-grukdumpc-cleanup-gru_dump_context-a-little.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-misc-sgi-gru-grukdumpc-cleanup-gru_dump_context-a-little.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
gru-unlocking-should-be-conditional-in-gru_dump_context.patch
drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch
drivers-misc-sgi-gru-grukdumpc-cleanup-gru_dump_context-a-little.patch
linux-next.patch

