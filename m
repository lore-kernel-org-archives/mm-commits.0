From: akpm@linux-foundation.org
Subject: [merged] sysdev-fix-missing-s390-conversion.patch removed from -mm tree
Date: Fri, 19 Feb 2010 10:54:49 -0800
Message-ID: <201002191854.o1JIsn8f030014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987Ab0BSS4q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Feb 2010 13:56:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, ak@linux.intel.com, greg@kroah.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysdev: fix missing s390 conversion
has been removed from the -mm tree.  Its filename was
     sysdev-fix-missing-s390-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysdev: fix missing s390 conversion
From: Heiko Carstens <heiko.carstens@de.ibm.com>

In linux-next "sysdev: Pass attribute in sysdev_class attributes show/store"
forgot to convert one place in s390 code. Here is the missing part.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/smp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/s390/kernel/smp.c~sysdev-fix-missing-s390-conversion arch/s390/kernel/smp.c
--- a/arch/s390/kernel/smp.c~sysdev-fix-missing-s390-conversion
+++ a/arch/s390/kernel/smp.c
@@ -1033,7 +1033,9 @@ static ssize_t __ref rescan_store(struct
 static SYSDEV_CLASS_ATTR(rescan, 0200, NULL, rescan_store);
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static ssize_t dispatching_show(struct sysdev_class *class, char *buf)
+static ssize_t dispatching_show(struct sysdev_class *class,
+				struct sysdev_class_attribute *attr,
+				char *buf)
 {
 	ssize_t count;
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
cpumask-let-num__cpus-function-always-return-unsigned-values.patch
add-generic-sys_old_select.patch
add-generic-sys_old_mmap.patch
add-generic-sys_ipc-wrapper.patch
add-generic-sys_ipc-wrapper-fix.patch
improve-sys_personality-for-compat-architectures.patch
improve-sys_newuname-for-compat-architectures.patch
add-generic-sys_olduname.patch

