From: akpm@linux-foundation.org
Subject: + drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver-fix.patch added to -mm tree
Date: Thu, 21 Mar 2013 15:09:44 -0700
Message-ID: <20130321220944.C9C455A4206@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:51352 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab3CUWJp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:09:45 -0400
Received: by mail-qa0-f74.google.com with SMTP id k4so96024qaq.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:09:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haiyangz@microsoft.com, fengguang.wu@intel.com, kys@microsoft.com


The patch titled
     Subject: video: fix a type warning in hyperv_fb.c
has been added to the -mm tree.  Its filename is
     drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Haiyang Zhang <haiyangz@microsoft.com>
Subject: video: fix a type warning in hyperv_fb.c

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/hyperv_fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/hyperv_fb.c~drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver-fix drivers/video/hyperv_fb.c
--- a/drivers/video/hyperv_fb.c~drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver-fix
+++ a/drivers/video/hyperv_fb.c
@@ -624,7 +624,7 @@ static int hvfb_getmem(struct fb_info *i
 {
 	struct pci_dev *pdev;
 	ulong fb_phys;
-	void *fb_virt;
+	void __iomem *fb_virt;
 
 	pdev = pci_get_device(PCI_VENDOR_ID_MICROSOFT,
 			      PCI_DEVICE_ID_HYPERV_VIDEO, NULL);
_

Patches currently in -mm which might be from haiyangz@microsoft.com are

linux-next.patch
drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver.patch
drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver-fix.patch

