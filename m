From: akpm@linux-foundation.org
Subject: + edac-core-fix-to-use-dynamic-kobject.patch added to -mm tree
Date: Fri, 27 Jun 2008 16:09:08 -0700
Message-ID: <200806272309.m5RN99bo010813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932169AbYF0XJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jun 2008 19:09:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ajones@riverbed.com, dougthompson@xmission.com, greg@kroah.com, gregkh@suse.de


The patch titled
     edac: core fix to use dynamic kobject
has been added to the -mm tree.  Its filename is
     edac-core-fix-to-use-dynamic-kobject.patch

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
Subject: edac: core fix to use dynamic kobject
From: Arthur Jones <ajones@riverbed.com>

Static kobjects are not supported in linux kernel.  Convert the
edac_pci_top_main_kobj from static to dynamic.  This avoids the double
free of the edac_pci_top_main_kobj.name that we see on module reload of
the e752x edac driver (and probably others as well).

In addition Greg KH <greg@kroah.com> has pointed out that this code may be
cleaned up significantly.  I will look at that as a follow-on patch, for
now, I just want the minimum fix to get this double-free oops bug
squashed...

Many thanks to Greg KH for his patience in showing me what the
Documentation/kobject.txt already said (oops)...

Signed-off-by: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_pci_sysfs.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff -puN drivers/edac/edac_pci_sysfs.c~edac-core-fix-to-use-dynamic-kobject drivers/edac/edac_pci_sysfs.c
--- a/drivers/edac/edac_pci_sysfs.c~edac-core-fix-to-use-dynamic-kobject
+++ a/drivers/edac/edac_pci_sysfs.c
@@ -28,7 +28,7 @@ static int edac_pci_poll_msec = 1000;	/*
 static atomic_t pci_parity_count = ATOMIC_INIT(0);
 static atomic_t pci_nonparity_count = ATOMIC_INIT(0);
 
-static struct kobject edac_pci_top_main_kobj;
+static struct kobject *edac_pci_top_main_kobj;
 static atomic_t edac_pci_sysfs_refcount = ATOMIC_INIT(0);
 
 /* getter functions for the data variables */
@@ -83,7 +83,7 @@ static void edac_pci_instance_release(st
 	pci = to_instance(kobj);
 
 	/* decrement reference count on top main kobj */
-	kobject_put(&edac_pci_top_main_kobj);
+	kobject_put(edac_pci_top_main_kobj);
 
 	kfree(pci);	/* Free the control struct */
 }
@@ -166,7 +166,7 @@ static int edac_pci_create_instance_kobj
 	 * track the number of PCI instances we have, and thus nest
 	 * properly on keeping the module loaded
 	 */
-	main_kobj = kobject_get(&edac_pci_top_main_kobj);
+	main_kobj = kobject_get(edac_pci_top_main_kobj);
 	if (!main_kobj) {
 		err = -ENODEV;
 		goto error_out;
@@ -174,11 +174,11 @@ static int edac_pci_create_instance_kobj
 
 	/* And now register this new kobject under the main kobj */
 	err = kobject_init_and_add(&pci->kobj, &ktype_pci_instance,
-				   &edac_pci_top_main_kobj, "pci%d", idx);
+				   edac_pci_top_main_kobj, "pci%d", idx);
 	if (err != 0) {
 		debugf2("%s() failed to register instance pci%d\n",
 			__func__, idx);
-		kobject_put(&edac_pci_top_main_kobj);
+		kobject_put(edac_pci_top_main_kobj);
 		goto error_out;
 	}
 
@@ -316,9 +316,10 @@ static struct edac_pci_dev_attribute *ed
  */
 static void edac_pci_release_main_kobj(struct kobject *kobj)
 {
-
 	debugf0("%s() here to module_put(THIS_MODULE)\n", __func__);
 
+	kfree(kobj);
+
 	/* last reference to top EDAC PCI kobject has been removed,
 	 * NOW release our ref count on the core module
 	 */
@@ -369,8 +370,16 @@ static int edac_pci_main_kobj_setup(void
 		goto decrement_count_fail;
 	}
 
+	edac_pci_top_main_kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
+	if (!edac_pci_top_main_kobj) {
+		debugf1("Failed to allocate\n");
+		err = -ENOMEM;
+		goto kzalloc_fail;
+	}
+
 	/* Instanstiate the pci object */
-	err = kobject_init_and_add(&edac_pci_top_main_kobj, &ktype_edac_pci_main_kobj,
+	err = kobject_init_and_add(edac_pci_top_main_kobj,
+				   &ktype_edac_pci_main_kobj,
 				   &edac_class->kset.kobj, "pci");
 	if (err) {
 		debugf1("Failed to register '.../edac/pci'\n");
@@ -381,13 +390,16 @@ static int edac_pci_main_kobj_setup(void
 	 * for EDAC PCI, then edac_pci_main_kobj_teardown()
 	 * must be used, for resources to be cleaned up properly
 	 */
-	kobject_uevent(&edac_pci_top_main_kobj, KOBJ_ADD);
+	kobject_uevent(edac_pci_top_main_kobj, KOBJ_ADD);
 	debugf1("Registered '.../edac/pci' kobject\n");
 
 	return 0;
 
 	/* Error unwind statck */
 kobject_init_and_add_fail:
+	kfree(edac_pci_top_main_kobj);
+
+kzalloc_fail:
 	module_put(THIS_MODULE);
 
 decrement_count_fail:
@@ -414,7 +426,7 @@ static void edac_pci_main_kobj_teardown(
 	if (atomic_dec_return(&edac_pci_sysfs_refcount) == 0) {
 		debugf0("%s() called kobject_put on main kobj\n",
 			__func__);
-		kobject_put(&edac_pci_top_main_kobj);
+		kobject_put(edac_pci_top_main_kobj);
 	}
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

