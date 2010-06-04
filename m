From: akpm@linux-foundation.org
Subject: + drivers-mfd-introduce-missing-kfree.patch added to -mm tree
Date: Fri, 04 Jun 2010 13:10:25 -0700
Message-ID: <201006042010.o54KAPRD014704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554Ab0FDULA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 16:11:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, sameo@linux.intel.com


The patch titled
     drivers/mfd/davinci_voicecodec.c: introduce missing kfree
has been added to the -mm tree.  Its filename is
     drivers-mfd-introduce-missing-kfree.patch

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
Subject: drivers/mfd/davinci_voicecodec.c: introduce missing kfree
From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/davinci_voicecodec.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/mfd/davinci_voicecodec.c~drivers-mfd-introduce-missing-kfree drivers/mfd/davinci_voicecodec.c
--- a/drivers/mfd/davinci_voicecodec.c~drivers-mfd-introduce-missing-kfree
+++ a/drivers/mfd/davinci_voicecodec.c
@@ -94,7 +94,8 @@ static int __init davinci_vc_probe(struc
 	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "no DMA resource\n");
-		return -ENXIO;
+		ret = -ENXIO;
+		goto fail4;
 	}
 
 	davinci_vc->davinci_vcif.dma_tx_channel = res->start;
@@ -104,7 +105,8 @@ static int __init davinci_vc_probe(struc
 	res = platform_get_resource(pdev, IORESOURCE_DMA, 1);
 	if (!res) {
 		dev_err(&pdev->dev, "no DMA resource\n");
-		return -ENXIO;
+		ret = -ENXIO;
+		goto fail4;
 	}
 
 	davinci_vc->davinci_vcif.dma_rx_channel = res->start;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-dma-eliminate-a-null-pointer-dereference.patch
drivers-media-use-memdup_user.patch
drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
arch-ia64-kvm-add-missing-spin_unlock.patch
drivers-ide-use-memdup_user.patch
drivers-mfd-kzalloc-doesnt-return-err_ptr.patch
fs-ubifs-use-err_cast.patch
fs-ocfs2-dlm-add-missing-spin_unlock.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
arch-sparc-kernel-eliminate-what-looks-like-a-null-pointer-dereference.patch
drivers-staging-dream-camera-use-memdup_user.patch
drivers-staging-vme-bridges-add-missing-unlocks.patch
drivers-staging-eliminate-a-null-pointer-dereference.patch
drivers-usb-gadget-use-memdup_user.patch
drivers-usb-serial-eliminate-a-null-pointer-dereference.patch
mm-use-memdup_user.patch
mm-use-err_cast.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch
drivers-mfd-introduce-missing-kfree.patch
drivers-scsi-arcmsr-introduce-missing-kfree.patch

