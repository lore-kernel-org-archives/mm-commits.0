From: akpm@linux-foundation.org
Subject: + fix-gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse.patch added to -mm tree
Date: Tue, 13 Nov 2007 11:15:25 -0800
Message-ID: <200711131915.lADJFP0w026316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35537 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757519AbXKMTP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Nov 2007 14:15:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com, greg@kroah.com


The patch titled
     fix gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse
has been added to the -mm tree.  Its filename is
     fix-gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse.pat=
ch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: fix gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse
=46rom: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

The build fails, with the build error

drivers/pci/hotplug/rpadlpar_sysfs.c:28: warning: =CB=9Cstruct kobjet d=
eclared inside parameter list
drivers/pci/hotplug/rpadlpar_sysfs.c:28: warning: its scope is only thi=
s definition or declaration, which is probably not what you want
drivers/pci/hotplug/rpadlpar_sysfs.c:59: warning: =CB=9Cstruct kobjet d=
eclared inside parameter list
drivers/pci/hotplug/rpadlpar_sysfs.c: In function =CB=9Cremove_slot_sto=
re:
drivers/pci/hotplug/rpadlpar_sysfs.c:79: error: expected =CB=9C; before=
 =CB=9Creturn
drivers/pci/hotplug/rpadlpar_sysfs.c: At top level:
drivers/pci/hotplug/rpadlpar_sysfs.c:89: warning: initialization from i=
ncompatible pointer type
drivers/pci/hotplug/rpadlpar_sysfs.c:92: warning: initialization from i=
ncompatible pointer type
drivers/pci/hotplug/rpadlpar_sysfs.c: In function =CB=9Cremove_slot_sto=
re:
drivers/pci/hotplug/rpadlpar_sysfs.c:80: warning: control reaches end o=
f
non-void function
make[3]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
make[2]: *** [drivers/pci/hotplug] Error 2
make[1]: *** [drivers/pci] Error 2
make: *** [drivers] Error 2

This is caused by the patch gregkh-driver-kobject-clean-up-rpadlpar-hor=
rid-sysfs-abuse.patch.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/rpadlpar_sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pci/hotplug/rpadlpar_sysfs.c~fix-gregkh-driver-kobjec=
t-clean-up-rpadlpar-horrid-sysfs-abuse drivers/pci/hotplug/rpadlpar_sys=
fs.c
--- a/drivers/pci/hotplug/rpadlpar_sysfs.c~fix-gregkh-driver-kobject-cl=
ean-up-rpadlpar-horrid-sysfs-abuse
+++ a/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -54,7 +54,7 @@ static ssize_t add_slot_show(struct kobj
 	return sprintf(buf, "0\n");
 }
=20
-static ssize_t remove_slot_store(struct kobjet *kobj,
+static ssize_t remove_slot_store(struct kobject *kobj,
 				 struct kobj_attribute *attr,
 				 const char *buf, size_t nbytes)
 {
@@ -74,7 +74,7 @@ static ssize_t remove_slot_store(struct=20
=20
 	rc =3D dlpar_remove_slot(drc_name);
 	if (rc)
-		return rc
+		return rc;
=20
 	return nbytes;
 }
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.co=
m are

chipsfb-uses-depends-on-pci.patch
export-acpi_check_resource_conflict.patch
fix-gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse.patch
config_highpte-vs-sub-page-page-tables-fix.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch
