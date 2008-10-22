From: akpm@linux-foundation.org
Subject: - sysfs-fix-return-values-for-sysdev_store_ulongint.patch removed from -mm tree
Date: Wed, 22 Oct 2008 13:08:52 -0700
Message-ID: <200810222008.m9MK8qbX013857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872AbYJVUJB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 16:09:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: fix return values for sysdev_store_{ulong,int}
has been removed from the -mm tree.  Its filename was
     sysfs-fix-return-values-for-sysdev_store_ulongint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: fix return values for sysdev_store_{ulong,int}
From: Andi Kleen <andi@firstfloor.org>

Always return the full size instead of the consumed length of the string
in sysdev_store_{ulong,int}

This avoids EINVAL errors in some echo versions.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/sys.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/base/sys.c~sysfs-fix-return-values-for-sysdev_store_ulongint drivers/base/sys.c
--- a/drivers/base/sys.c~sysfs-fix-return-values-for-sysdev_store_ulongint
+++ a/drivers/base/sys.c
@@ -488,7 +488,8 @@ ssize_t sysdev_store_ulong(struct sys_de
 	if (end == buf)
 		return -EINVAL;
 	*(unsigned long *)(ea->var) = new;
-	return end - buf;
+	/* Always return full write size even if we didn't consume all */
+	return size;
 }
 EXPORT_SYMBOL_GPL(sysdev_store_ulong);
 
@@ -511,7 +512,8 @@ ssize_t sysdev_store_int(struct sys_devi
 	if (end == buf || new > INT_MAX || new < INT_MIN)
 		return -EINVAL;
 	*(int *)(ea->var) = new;
-	return end - buf;
+	/* Always return full write size even if we didn't consume all */
+	return size;
 }
 EXPORT_SYMBOL_GPL(sysdev_store_int);
 
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
linux-next.patch
acpi-compal-laptop-use-rfkill-switch-subsystem.patch
profile-likely-unlikely-macros.patch

