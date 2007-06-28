From: akpm@linux-foundation.org
Subject: + git-acpi-s390-struct-bin_attribute-changes.patch added to -mm tree
Date: Thu, 28 Jun 2007 15:10:45 -0700
Message-ID: <200706282210.l5SMAjvk002627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761387AbXF1WK5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 18:10:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, greg@kroah.com, len.brown@intel.com, rui.zhang@intel.com, schwidefsky@de.ibm.com


The patch titled
     git-acpi: s390: struct bin_attribute changes
has been added to the -mm tree.  Its filename is
     git-acpi-s390-struct-bin_attribute-changes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-acpi: s390: struct bin_attribute changes
From: Heiko Carstens <heiko.carstens@de.ibm.com>

git-acpi contains a patch that adds 'struct bin_attribute *' to
the read method of struct bin_attribute. This breaks s390:

  CC      arch/s390/kernel/ipl.o
arch/s390/kernel/ipl.c:317:
 warning: initialization from incompatible pointer type
arch/s390/kernel/ipl.c:340:
  warning: initialization from incompatible pointer type

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/ipl.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/s390/kernel/ipl.c~git-acpi-s390-struct-bin_attribute-changes arch/s390/kernel/ipl.c
--- a/arch/s390/kernel/ipl.c~git-acpi-s390-struct-bin_attribute-changes
+++ a/arch/s390/kernel/ipl.c
@@ -297,8 +297,9 @@ static ssize_t sys_ipl_device_show(struc
 static struct subsys_attribute sys_ipl_device_attr =
 	__ATTR(device, S_IRUGO, sys_ipl_device_show, NULL);
 
-static ssize_t ipl_parameter_read(struct kobject *kobj, char *buf, loff_t off,
-				  size_t count)
+static ssize_t ipl_parameter_read(struct kobject *kobj,
+				  struct bin_attribute *attr,
+				  char *buf, loff_t off, size_t count)
 {
 	unsigned int size = IPL_PARMBLOCK_SIZE;
 
@@ -320,8 +321,9 @@ static struct bin_attribute ipl_paramete
 	.read = &ipl_parameter_read,
 };
 
-static ssize_t ipl_scp_data_read(struct kobject *kobj, char *buf, loff_t off,
-	size_t count)
+static ssize_t ipl_scp_data_read(struct kobject *kobj,
+				 struct bin_attribute *attr,
+				 char *buf, loff_t off, size_t count)
 {
 	unsigned int size = IPL_PARMBLOCK_START->ipl_info.fcp.scp_data_len;
 	void *scp_data = &IPL_PARMBLOCK_START->ipl_info.fcp.scp_data;
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-acpi-s390-struct-bin_attribute-changes.patch
git-s390.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
x86_64-fix-smp_call_function_single-return-value.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
check_signature-needs-readb.patch
fallocate-implementation-on-i86-x86_64-and-powerpc.patch
fallocate-on-s390.patch
