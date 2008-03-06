From: akpm@linux-foundation.org
Subject: - fix-gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:30:44 -0800
Message-ID: <200803062230.m26MUiAo021678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758311AbYCFWb0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:31:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamalesh@linux.vnet.ibm.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     fix gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse
has been removed from the -mm tree.  Its filename was
     fix-gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse.pat=
ch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

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

git-x86.patch
git-md-accel.patch
hugetlb-correct-page-count-for-surplus-huge-pages-fix.patch
slab-pass-correct-flags-to-kmem_getpages.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
