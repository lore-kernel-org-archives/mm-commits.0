From: akpm@linux-foundation.org
Subject: + drivers-cdrom-gdromc-fix-device-number-leak.patch added to -mm
 tree
Date: Mon, 20 May 2013 15:16:03 -0700
Message-ID: <519aa0a3.VkQpCSHq0YPS/7MO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab3ETWQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 18:16:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, libo.chen@huawei.com, axboe@kernel.dk, clbchenlibo.chen@huawei.com

Subject: + drivers-cdrom-gdromc-fix-device-number-leak.patch added to -mm tree
To: clbchenlibo.chen@huawei.com,axboe@kernel.dk,libo.chen@huawei.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 15:16:03 -0700


The patch titled
     Subject: drivers/cdrom/gdrom.c: fix device number leak
has been added to the -mm tree.  Its filename is
     drivers-cdrom-gdromc-fix-device-number-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/cdrom/gdrom.c: fix device number leak

Without this patch, gdrom_major will leak when gd.cd_info alloc fails.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/gdrom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cdrom/gdrom.c~drivers-cdrom-gdromc-fix-device-number-leak drivers/cdrom/gdrom.c
--- a/drivers/cdrom/gdrom.c~drivers-cdrom-gdromc-fix-device-number-leak
+++ a/drivers/cdrom/gdrom.c
@@ -830,9 +830,9 @@ probe_fail_cdrom_register:
 	del_gendisk(gd.disk);
 probe_fail_no_disk:
 	kfree(gd.cd_info);
+probe_fail_no_mem:
 	unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
 	gdrom_major = 0;
-probe_fail_no_mem:
 	pr_warning("Probe failed - error is 0x%X\n", err);
 	return err;
 }
_

Patches currently in -mm which might be from clbchenlibo.chen@huawei.com are

origin.patch
linux-next.patch
drivers-cdrom-gdromc-fix-device-number-leak.patch

