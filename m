From: akpm@linux-foundation.org
Subject: + mtd-sst25l-check-for-null-consistently.patch added to -mm tree
Date: Tue, 25 May 2010 16:11:51 -0700
Message-ID: <201005252311.o4PNBpHS020752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903Ab0EYXMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 19:12:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, Artem.Bityutskiy@nokia.com, andre@bluewatersys.com, dwmw2@infradead.org


The patch titled
     mtd/sst25l: check for null consistently
has been added to the -mm tree.  Its filename is
     mtd-sst25l-check-for-null-consistently.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd/sst25l: check for null consistently
From: Dan Carpenter <error27@gmail.com>

The rest of the function assumes that "data" can be null.  I don't know
the code well enough to say whether it can actually be null, but there is
no harm in checking here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Andre Renaud <andre@bluewatersys.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/sst25l.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/devices/sst25l.c~mtd-sst25l-check-for-null-consistently drivers/mtd/devices/sst25l.c
--- a/drivers/mtd/devices/sst25l.c~mtd-sst25l-check-for-null-consistently
+++ a/drivers/mtd/devices/sst25l.c
@@ -454,7 +454,7 @@ static int __init sst25l_probe(struct sp
 						  parts, nr_parts);
 		}
 
-	} else if (data->nr_parts) {
+	} else if (data && data->nr_parts) {
 		dev_warn(&spi->dev, "ignoring %d default partitions on %s\n",
 			 data->nr_parts, data->name);
 	}
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
mempolicy-err_ptr-dereference-in-mpol_shared_policy_init.patch
linux-next.patch
mtd-sst25l-check-for-null-consistently.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
proc-cleanup-remove-unused-assignments.patch

