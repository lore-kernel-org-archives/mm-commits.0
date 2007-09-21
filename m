From: akpm@linux-foundation.org
Subject: + fix-oops-in-platform-uevent.patch added to -mm tree
Date: Fri, 21 Sep 2007 00:36:28 -0700
Message-ID: <200709210736.l8L7aS9K024854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43526 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbXIUHhA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 03:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org, akpm@linux-foundation.org, greg@kroah.com, kay.sievers@vrfy.org


The patch titled
     fix OOPS in platform uevent
has been added to the -mm tree.  Its filename is
     fix-oops-in-platform-uevent.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
pci-x-pci-express-read-control-interfaces-e1000.patch
export-reciprocal_value-for-modules.patch
sky2-avoid-divide-in-receive-path.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
