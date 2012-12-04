From: akpm@linux-foundation.org
Subject: + block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch added to -mm tree
Date: Mon, 03 Dec 2012 16:06:58 -0800
Message-ID: <20121204000659.1BF8B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:37935 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2LDAHC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2012 19:07:02 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so243087wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 03 Dec 2012 16:07:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johunt@akamai.com, axboe@kernel.dk, kay.sievers@vrfy.org, tj@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: block: restore /proc/partitions to not display non-partitionable removable devices
has been added to the -mm tree.  Its filename is
     block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Hunt <johunt@akamai.com>
Subject: block: restore /proc/partitions to not display non-partitionable removable devices

We found with newer kernels we started seeing the cdrom device showing
up in /proc/partitions, but it was not there before.

Looking into this I found that commit d27769ec ("block: add
GENHD_FL_NO_PART_SCAN") introduces this change in behavior.  It's not
clear to me from the commit's changelog if this change was intentional or
not.  This comment still remains: /* Don't show non-partitionable
removeable devices or empty devices */ so I've decided to send a patch to
restore the behavior of not printing unpartitionable removable devices.

Signed-off-by: Josh Hunt <johunt@akamai.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/genhd.c~block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices block/genhd.c
--- a/block/genhd.c~block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices
+++ a/block/genhd.c
@@ -845,7 +845,7 @@ static int show_partition(struct seq_fil
 	char buf[BDEVNAME_SIZE];
 
 	/* Don't show non-partitionable removeable devices or empty devices */
-	if (!get_capacity(sgp) || (!disk_max_parts(sgp) &&
+	if (!get_capacity(sgp) || (!(disk_max_parts(sgp) > 1) &&
 				   (sgp->flags & GENHD_FL_REMOVABLE)))
 		return 0;
 	if (sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)
_

Patches currently in -mm which might be from johunt@akamai.com are

linux-next.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch

