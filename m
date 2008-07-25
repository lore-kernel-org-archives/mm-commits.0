From: akpm@linux-foundation.org
Subject: - edac-core-fix-static-to-dynamic-kset.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:04:05 -0700
Message-ID: <200807252304.m6PN45GT004019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753944AbYGYXEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:04:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ajones@riverbed.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: core fix static to dynamic kset
has been removed from the -mm tree.  Its filename was
     edac-core-fix-static-to-dynamic-kset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: core fix static to dynamic kset
From: Arthur Jones <ajones@riverbed.com>

Static kobjects and ksets are not supported in Linux kernel.  Convert the
mc_kset from static to dynamic.  This patch depends on my previous patch
to remove the module parameter attributes from mc...

Signed-off-by: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc_sysfs.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN drivers/edac/edac_mc_sysfs.c~edac-core-fix-static-to-dynamic-kset drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~edac-core-fix-static-to-dynamic-kset
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -645,7 +645,7 @@ static struct kobj_type ktype_mci = {
 /* EDAC memory controller sysfs kset:
  *	/sys/devices/system/edac/mc
  */
-static struct kset mc_kset;
+static struct kset *mc_kset;
 
 /*
  * edac_mc_register_sysfs_main_kobj
@@ -676,7 +676,7 @@ int edac_mc_register_sysfs_main_kobj(str
 	}
 
 	/* this instance become part of the mc_kset */
-	kobj_mci->kset = &mc_kset;
+	kobj_mci->kset = mc_kset;
 
 	/* register the mc<id> kobject to the mc_kset */
 	err = kobject_init_and_add(kobj_mci, &ktype_mci, NULL,
@@ -906,12 +906,9 @@ int edac_sysfs_setup_mc_kset(void)
 	}
 
 	/* Init the MC's kobject */
-	kobject_set_name(&mc_kset.kobj, "mc");
-	mc_kset.kobj.parent = &edac_class->kset.kobj;
