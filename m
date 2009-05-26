From: akpm@linux-foundation.org
Subject: [merged] xen-use-header-for-export_symbol_gpl.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:49 -0700
Message-ID: <200905261935.n4QJZnGa006613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757899AbZEZTgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:36:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jeremy@goop.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     xen: use header for EXPORT_SYMBOL_GPL
has been removed from the -mm tree.  Its filename was
     xen-use-header-for-export_symbol_gpl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
menu-fix-embedded-menu-presentation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
lockd-fix-file_locking=n-build-error.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

