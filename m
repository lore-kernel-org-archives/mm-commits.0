From: akpm@linux-foundation.org
Subject: - docbook-add-edd-firmware-interfaces.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:53:56 -0800
Message-ID: <200702112253.l1BMruLE016149@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60499 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932862AbXBKWyb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:54:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, Matt_Domsch@dell.com, mm-commits@vger.kernel.org


The patch titled
     docbook: add edd firmware interfaces
has been removed from the -mm tree.  Its filename was
     docbook-add-edd-firmware-interfaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: docbook: add edd firmware interfaces
From: Randy Dunlap <randy.dunlap@oracle.com>

Cleanup kernel-doc notation in drivers/firmware/edd.c.

Add edd.c to DocBook/kernel-api.tmpl.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    3 +++
 drivers/firmware/edd.c                |    8 +++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~docbook-add-edd-firmware-interfaces Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~docbook-add-edd-firmware-interfaces
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -316,6 +316,9 @@ X!Earch/i386/kernel/mca.c
      <sect1><title>DMI Interfaces</title>
 !Edrivers/firmware/dmi_scan.c
      </sect1>
+     <sect1><title>EDD Interfaces</title>
+!Idrivers/firmware/edd.c
+     </sect1>
   </chapter>
 
   <chapter id="security">
diff -puN drivers/firmware/edd.c~docbook-add-edd-firmware-interfaces drivers/firmware/edd.c
--- a/drivers/firmware/edd.c~docbook-add-edd-firmware-interfaces
+++ a/drivers/firmware/edd.c
@@ -233,6 +233,8 @@ edd_show_interface(struct edd_device *ed
 
 /**
  * edd_show_raw_data() - copies raw data to buffer for userspace to parse
+ * @edev: target edd_device
+ * @buf: output buffer
  *
  * Returns: number of bytes written, or -EINVAL on failure
  */
@@ -634,8 +636,8 @@ static decl_subsys(edd,&ktype_edd,NULL);
 
 /**
  * edd_dev_is_type() - is this EDD device a 'type' device?
- * @edev
- * @type - a host bus or interface identifier string per the EDD spec
+ * @edev: target edd_device
+ * @type: a host bus or interface identifier string per the EDD spec
  *
  * Returns 1 (TRUE) if it is a 'type' device, 0 otherwise.
  */
@@ -657,7 +659,7 @@ edd_dev_is_type(struct edd_device *edev,
 
 /**
  * edd_get_pci_dev() - finds pci_dev that matches edev
- * @edev - edd_device
+ * @edev: edd_device
  *
  * Returns pci_dev if found, or NULL
  */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-drm.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
git-mtd.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
ueagle-atmc-needs-schedh.patch
com20020-build-fix.patch
drivers-telephony-ixj-convert-to-generic-boolean.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
