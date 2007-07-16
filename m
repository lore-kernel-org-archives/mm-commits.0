From: akpm@linux-foundation.org
Subject: - git-acpi-s390-struct-bin_attribute-changes.patch removed from -mm tree
Date: Mon, 16 Jul 2007 14:00:00 -0700
Message-ID: <200707162100.l6GL00j1002472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759356AbXGPVZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:25:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, greg@kroah.com, len.brown@intel.com, rui.zhang@intel.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     git-acpi: s390: struct bin_attribute changes
has been removed from the -mm tree.  Its filename was
     git-acpi-s390-struct-bin_attribute-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-s390.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-put-allocated-elf-notes-in-read-only-data-segment.patch
s390-put-allocated-elf-notes-in-read-only-data-segment.patch
add-sys-kernel-notes.patch
use-build-id-ld-option.patch
