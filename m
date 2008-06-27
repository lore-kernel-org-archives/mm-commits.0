From: akpm@linux-foundation.org
Subject: + edac-core-fix-static-to-dynamic-kset.patch added to -mm tree
Date: Fri, 27 Jun 2008 16:09:14 -0700
Message-ID: <200806272309.m5RN9E66010822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932173AbYF0XJc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jun 2008 19:09:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ajones@riverbed.com, dougthompson@xmission.com


The patch titled
     edac: core fix static to dynamic kset
has been added to the -mm tree.  Its filename is
     edac-core-fix-static-to-dynamic-kset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
-
-	/* register the mc_kset */
-	err = kset_register(&mc_kset);
-	if (err) {
+	mc_kset = kset_create_and_add("mc", NULL, &edac_class->kset.kobj);
+	if (!mc_kset) {
+		err = -ENOMEM;
 		debugf1("%s() Failed to register '.../edac/mc'\n", __func__);
 		goto fail_out;
 	}
@@ -933,6 +930,6 @@ fail_out:
  */
 void edac_sysfs_teardown_mc_kset(void)
 {
-	kset_unregister(&mc_kset);
+	kset_unregister(mc_kset);
 }
 
_

Patches currently in -mm which might be from ajones@riverbed.com are

edac-i5100-new-intel-chipset-driver.patch
edac-i5100-fix-missing-bits.patch
edac-i5100-fix-enable-ecc-hardware.patch
edac-i5100-fix-unmask-ecc-bits.patch
edac-core-fix-to-use-dynamic-kobject.patch
edac-core-fix-workq-timer.patch
edac-core-fix-redundant-sysfs-controls-to-parameters.patch
edac-core-fix-static-to-dynamic-kset.patch
edac-core-fix-added-newline-to-sysfs-dimm-labels.patch

