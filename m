From: akpm@linux-foundation.org
Subject: + xen-use-header-for-export_symbol_gpl.patch added to -mm tree
Date: Wed, 06 May 2009 11:58:22 -0700
Message-ID: <200905061858.n46IwMmQ006658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752991AbZEFTBD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2009 15:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jeremy@goop.org, mingo@elte.hu


The patch titled
     xen: use header for EXPORT_SYMBOL_GPL
has been added to the -mm tree.  Its filename is
     xen-use-header-for-export_symbol_gpl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xen: use header for EXPORT_SYMBOL_GPL
From: Randy Dunlap <randy.dunlap@oracle.com>

mmu.c needs to #include module.h to prevent these warnings:

arch/x86/xen/mmu.c:239: warning: data definition has no type or storage class
arch/x86/xen/mmu.c:239: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/x86/xen/mmu.c:239: warning: parameter names (without types) in function declaration

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/mmu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/xen/mmu.c~xen-use-header-for-export_symbol_gpl arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~xen-use-header-for-export_symbol_gpl
+++ a/arch/x86/xen/mmu.c
@@ -42,6 +42,7 @@
 #include <linux/highmem.h>
 #include <linux/debugfs.h>
 #include <linux/bug.h>
+#include <linux/module.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
nfsd-use-c99-struct-initializers.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
menu-fix-embedded-menu-order.patch
doc-small-kernel-parameters-updates.patch
lockd-fix-file_locking=n-build-error.patch
xen-use-header-for-export_symbol_gpl.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

