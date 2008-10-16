From: akpm@linux-foundation.org
Subject: + sysfs-fix-return-values-for-sysdev_store_ulongint.patch added to -mm tree
Date: Thu, 16 Oct 2008 13:35:42 -0700
Message-ID: <200810162035.m9GKZgek015687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155AbYJPUft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 16:35:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, greg@kroah.com


The patch titled
     sysfs: fix return values for sysdev_store_{ulong,int}
has been added to the -mm tree.  Its filename is
     sysfs-fix-return-values-for-sysdev_store_ulongint.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
make-taint-bit-reliable-v3.patch
taint-fix-kernel-doc.patch
submittingpatches-add-a-reference-to-andis-ols-paper.patch
add-kerneldoc-documentation-for-new-printk-format-extensions.patch
pnp-make-the-resource-type-an-unsigned-long.patch
sysfs-fix-return-values-for-sysdev_store_ulongint.patch
acpi-compal-laptop-use-rfkill-switch-subsystem.patch
fix-documentation-of-sysrq-q.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch
hpet-remove-the-bkl.patch
acpi-use-bcd2bin-bin2bcd.patch
profile-likely-unlikely-macros.patch

