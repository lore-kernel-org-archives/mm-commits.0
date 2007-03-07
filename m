From: akpm@linux-foundation.org
Subject: + xtensa-strlcpy-is-smart-enough.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:16:21 -0800
Message-ID: <200703070116.l271GLLo015221@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41724 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161102AbXCGBQf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:16:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, chris@zankel.net


The patch titled
     xtensa: strlcpy is smart enough
has been added to the -mm tree.  Its filename is
     xtensa-strlcpy-is-smart-enough.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xtensa: strlcpy is smart enough
From: Jean Delvare <khali@linux-fr.org>

strlcpy already accounts for the trailing zero in its length
computation, so there is no need to substract one to the buffer size.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/platform-iss/network.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/xtensa/platform-iss/network.c~xtensa-strlcpy-is-smart-enough arch/xtensa/platform-iss/network.c
--- a/arch/xtensa/platform-iss/network.c~xtensa-strlcpy-is-smart-enough
+++ a/arch/xtensa/platform-iss/network.c
@@ -251,7 +251,7 @@ static int tuntap_open(struct iss_net_pr
 
 	memset(&ifr, 0, sizeof ifr);
 	ifr.ifr_flags = IFF_TAP | IFF_NO_PI;
-	strlcpy(ifr.ifr_name, dev_name, sizeof ifr.ifr_name - 1);
+	strlcpy(ifr.ifr_name, dev_name, sizeof ifr.ifr_name);
 
 	if ((err = simc_ioctl(fd, TUNSETIFF, (void*) &ifr)) < 0) {
 		printk("Failed to set interface, returned %d "
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
git-dvb.patch
scatterlisth-needs-typesh.patch
cleanup-the-includes-of-linux-pcih.patch
s390-strlcpy-is-smart-enough.patch
sound-strlcpy-is-smart-enough.patch
oss-strlcpy-is-smart-enough.patch
xtensa-strlcpy-is-smart-enough.patch
ehea-strlcpy-is-smart-enough.patch
