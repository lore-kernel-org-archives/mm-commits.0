From: akpm@linux-foundation.org
Subject: +
 drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error.patch added
 to -mm tree
Date: Mon, 13 Jan 2014 13:36:21 -0800
Message-ID: <52d45c55.YT1FlX6tSvZYIs6w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaAMVgW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 16:36:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, florian@openwrt.org, dan.carpenter@oracle.com

Subject: + drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error.patch added to -mm tree
To: dan.carpenter@oracle.com,florian@openwrt.org
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 13:36:21 -0800


The patch titled
     Subject: drivers/vlynq/vlynq.c: fix another resource size off by 1 error
has been added to the -mm tree.  Its filename is
     drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error.patch

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
Subject: drivers/vlynq/vlynq.c: fix another resource size off by 1 error

We fixed the call to request_mem_region() patch 3354f73
("drivers/vlynq/vlynq.c: fix resource size off by 1 error").  But we need
to fix the call the release_mem_region() as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vlynq/vlynq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/vlynq/vlynq.c~drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error drivers/vlynq/vlynq.c
--- a/drivers/vlynq/vlynq.c~drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error
+++ a/drivers/vlynq/vlynq.c
@@ -762,7 +762,8 @@ static int vlynq_remove(struct platform_
 
 	device_unregister(&dev->dev);
 	iounmap(dev->local);
-	release_mem_region(dev->regs_start, dev->regs_end - dev->regs_start);
+	release_mem_region(dev->regs_start,
+			   dev->regs_end - dev->regs_start + 1);
 
 	kfree(dev);
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch
ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace-fix.patch
drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch
drivers-block-paride-pgc-underflow-bug-in-pg_write.patch
fs-compat_ioctlc-fix-an-underflow-issue-harmless.patch
drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch
drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
linux-next.patch

