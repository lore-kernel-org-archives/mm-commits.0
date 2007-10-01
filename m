From: akpm@linux-foundation.org
Subject: - fix-oops-in-platform-uevent.patch removed from -mm tree
Date: Mon, 01 Oct 2007 13:14:33 -0700
Message-ID: <200710012014.l91KEXIc001101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349AbXJAUOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 16:14:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, akpm@linux-foundation.org, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     fix OOPS in platform uevent
has been removed from the -mm tree.  Its filename was
     fix-oops-in-platform-uevent.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: fix OOPS in platform uevent
From: Stephen Hemminger <shemminger@linux-foundation.org>

Environment wasn't being NULL terminated.  Suggested by Kay Sievers

Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=9034

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/platform.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/base/platform.c~fix-oops-in-platform-uevent drivers/base/platform.c
--- a/drivers/base/platform.c~fix-oops-in-platform-uevent
+++ a/drivers/base/platform.c
@@ -546,6 +546,7 @@ static int platform_uevent(struct device
 	struct platform_device	*pdev = to_platform_device(dev);
 
 	envp[0] = buffer;
+	envp[1] = NULL;
 	snprintf(buffer, buffer_size, "MODALIAS=%s", pdev->name);
 	return 0;
 }
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
fix-oops-in-platform-uevent.patch
git-infiniband.patch
git-input.patch
git-net.patch
git-net-fix-ax25-build.patch
git-net-more-bustage.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
