From: akpm@linux-foundation.org
Subject: + missing-null-termination-in-power-supply-uevent.patch added to -mm tree
Date: Fri, 21 Sep 2007 00:39:07 -0700
Message-ID: <200709210739.l8L7d78T024949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbXIUHji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 03:39:38 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l8L7d7gO019957
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 21 Sep 2007 00:39:08 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org


The patch titled
     missing null termination in power supply uevent
has been added to the -mm tree.  Its filename is
     missing-null-termination-in-power-supply-uevent.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: missing null termination in power supply uevent
From: Stephen Hemminger <shemminger@linux-foundation.org>

Need to null terminate environment. Found by inspection
while looking for similar problems to platform uevent bug

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/power_supply_sysfs.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/power/power_supply_sysfs.c~missing-null-termination-in-power-supply-uevent drivers/power/power_supply_sysfs.c
--- a/drivers/power/power_supply_sysfs.c~missing-null-termination-in-power-supply-uevent
+++ a/drivers/power/power_supply_sysfs.c
@@ -283,6 +283,7 @@ int power_supply_uevent(struct device *d
 		if (ret)
 			goto out;
 	}
+	envp[i] = NULL;
 
 out:
 	free_page((unsigned long)prop_buf);
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
missing-null-termination-in-power-supply-uevent.patch
