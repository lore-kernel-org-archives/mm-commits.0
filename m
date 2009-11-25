From: akpm@linux-foundation.org
Subject: + drivers-block-mg_diskc-use-resource_size.patch added to -mm tree
Date: Wed, 25 Nov 2009 11:20:44 -0800
Message-ID: <200911251920.nAPJKiAd008229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753727AbZKYTVf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 14:21:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, donari75@gmail.com, hsweeten@visionengravers.com, jens.axboe@oracle.com


The patch titled
     drivers/block/mg_disk.c: use resource_size()
has been added to the -mm tree.  Its filename is
     drivers-block-mg_diskc-use-resource_size.patch

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
Subject: drivers/block/mg_disk.c: use resource_size()
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

Use resource_size() for ioremap.

The ioremap appears to be passing the incorrect size for the platform
resource.  Unfortunately, I can't locate a user in mainline to verify
this.  Using resource_size should be the correct fix.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: unsik Kim <donari75@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/mg_disk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/mg_disk.c~drivers-block-mg_diskc-use-resource_size drivers/block/mg_disk.c
--- a/drivers/block/mg_disk.c~drivers-block-mg_diskc-use-resource_size
+++ a/drivers/block/mg_disk.c
@@ -860,7 +860,7 @@ static int mg_probe(struct platform_devi
 		err = -EINVAL;
 		goto probe_err_2;
 	}
-	host->dev_base = ioremap(rsc->start , rsc->end + 1);
+	host->dev_base = ioremap(rsc->start, resource_size(rsc));
 	if (!host->dev_base) {
 		printk(KERN_ERR "%s:%d ioremap fail\n",
 				__func__, __LINE__);
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
clockeventsc-fix-symbol-was-not-declared-noise.patch
drivers-block-mg_diskc-use-resource_size.patch
security-min_addrc-make-init_mmap_min_addr-static.patch
drivers-misc-add-driver-for-texas-instruments-dac7512.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
init-mainc-fix-symbol-shadows-noise.patch
kernel-sysc-fix-warning-do-while-statement-is-not-a-compound-statement-noise.patch

