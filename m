From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:16:20 -0800
Message-ID: <200702282316.l1SNGKmA030053@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47268 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbXB1XRP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:17:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     From: Jeremy Fitzhardinge <jeremy@goop.org>
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: From: Jeremy Fitzhardinge <jeremy@goop.org>


Allocate a fixmap slot for use by a paravirt_ops implementation.  Xen
uses this to map the hypervisor's shared info page, which doesn't have
a pseudo-physical page number, and therefore can't be mapped
ordinarily.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

--
 1 file changed, 3 insertions(+)

===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/fixmap.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/asm-i386/fixmap.h~xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot include/asm-i386/fixmap.h
--- a/include/asm-i386/fixmap.h~xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot
+++ a/include/asm-i386/fixmap.h
@@ -88,6 +88,9 @@ enum fixed_addresses {
 #ifdef CONFIG_PCI_MMCONFIG
 	FIX_PCIE_MCFG,
 #endif
+#ifdef CONFIG_PARAVIRT
+	FIX_PARAVIRT,
+#endif
 	__end_of_permanent_fixed_addresses,
 	/* temporary boot-time mappings, used before ioremap() is functional */
 #define NR_FIX_BTMAPS	16
_

Patches currently in -mm which might be from jeremy@goop.org are

make-hvc_consolec-compile-on-non-powerpc-remove-no_irq.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-some-generic-early-printk-boot-console-fixups.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
