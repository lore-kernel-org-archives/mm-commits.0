From: akpm@osdl.org
Subject: + docbook-add-edd-firmware-interfaces.patch added to -mm tree
Date: Wed, 10 Jan 2007 16:54:26 -0800
Message-ID: <200701110054.l0B0sQaL013004@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41876 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965286AbXAKAyc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 19:54:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, Matt_Domsch@dell.com


The patch titled
     docbook: add edd firmware interfaces
has been added to the -mm tree.  Its filename is
     docbook-add-edd-firmware-interfaces.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: docbook: add edd firmware interfaces
From: Randy Dunlap <randy.dunlap@oracle.com>

Cleanup kernel-doc notation in drivers/firmware/edd.c.

Add edd.c to DocBook/kernel-api.tmpl.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

git-alsa.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-rc-fixes.patch
megaraid-fix-kernel-doc.patch
math-emu-setcc-avoid-gcc-extension.patch
kernel-doc-allow-a-little-whitespace.patch
sysrq-showblockedtasks-is-sysrq-w.patch
sysrq-alphabetize-command-keys-doc.patch
kernel-doc-allow-more-whitespace.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
megaraid-more-kernel-doc-fixes.patch
docbook-add-edd-firmware-interfaces.patch
kernel-doc-fix-some-odd-spacing-issues.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
