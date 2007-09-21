From: akpm@linux-foundation.org
Subject: - missing-null-termination-in-power-supply-uevent.patch removed from -mm tree
Date: Fri, 21 Sep 2007 14:08:26 -0700
Message-ID: <200709212108.l8LL8QV2023575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762136AbXIUVJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 17:09:18 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l8LL8Q3W003579
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 21 Sep 2007 14:08:27 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     missing null termination in power supply uevent
has been removed from the -mm tree.  Its filename was
     missing-null-termination-in-power-supply-uevent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
missing-null-termination-in-one-wire-uevent.patch
fix-oops-in-platform-uevent.patch
git-infiniband.patch
git-input.patch
git-net.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
export-reciprocal_value-for-modules.patch
sky2-avoid-divide-in-receive-path.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
git-battery.patch
