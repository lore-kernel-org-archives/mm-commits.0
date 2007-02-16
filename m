From: akpm@linux-foundation.org
Subject: + xen-paravirt-fix-typo-in-sync_constant_test_bits-name.patch added to -mm tree
Date: Thu, 15 Feb 2007 22:59:55 -0800
Message-ID: <200702160659.l1G6xtcG022566@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55125 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423314AbXBPHAr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 02:00:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com


The patch titled
     Xen-paravirt: fix typo in sync_constant_test_bit()s name
has been added to the -mm tree.  Its filename is
     xen-paravirt-fix-typo-in-sync_constant_test_bits-name.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Xen-paravirt: fix typo in sync_constant_test_bit()s name
From: Jeremy Fitzhardinge <jeremy@goop.org>

This patch series implements the Linux Xen guest in terms of the paravirt-ops
interface.  The features in implemented this patch series are:

 * domU only
 * UP only (most code is SMP-safe, but there's no way to create a new vcpu)
 * writable pagetables, with late pinning/early unpinning
   (no shadow pagetable support)
 * supports both PAE and non-PAE modes
 * xen console
 * virtual block device (blockfront)
 * virtual network device (netfront)


This patch:

Fix typo in sync_constant_test_bit()s name

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/sync_bitops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-i386/sync_bitops.h~xen-paravirt-fix-typo-in-sync_constant_test_bits-name include/asm-i386/sync_bitops.h
--- a/include/asm-i386/sync_bitops.h~xen-paravirt-fix-typo-in-sync_constant_test_bits-name
+++ a/include/asm-i386/sync_bitops.h
@@ -130,7 +130,7 @@ static inline int sync_test_and_change_b
 	return oldbit;
 }
 
-static __always_inline int sync_const_test_bit(int nr, const volatile unsigned long *addr)
+static __always_inline int sync_constant_test_bit(int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr & 31)) &
 		(((const volatile unsigned int *)addr)[nr >> 5])) != 0;
_

Patches currently in -mm which might be from jeremy@goop.org are

i386-probe_roms-cleanup.patch
no-need-to-use-traditional-for-processing-asm-in-i386-kernel.patch
xen-paravirt-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt-remove-ctor-for-pgd-cache.patch
xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment.patch
xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt-allocate-and-free-vmalloc-areas.patch
xen-paravirt-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch
xen-paravirt-add-xen-interface-header-files.patch
xen-paravirt-core-xen-implementation.patch
xen-paravirt-add-the-xen-virtual-console-driver.patch
xen-paravirt-add-xen-grant-table-support.patch
xen-paravirt-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt-add-xen-virtual-block-device-driver.patch
xen-paravirt-add-the-xen-virtual-network-device-driver.patch
uninline-jiffiesh-functions.patch
