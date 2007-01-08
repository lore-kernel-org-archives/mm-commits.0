From: akpm@osdl.org
Subject: + make-initkmem_list3-non-init-data-to-fix-modpost-warning.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:58:49 -0800
Message-ID: <200701082258.l08MwndJ021717@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51257 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161041AbXAHW7D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:59:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@in.ibm.com, clameter@engr.sgi.com, penberg@cs.helsinki.fi


The patch titled
     make initkmem_list3 non init data to fix modpost warning
has been added to the -mm tree.  Its filename is
     make-initkmem_list3-non-init-data-to-fix-modpost-warning.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make initkmem_list3 non init data to fix modpost warning
From: Vivek Goyal <vgoyal@in.ibm.com>

o MODPOST generates warning for i386 if kernel is compiled with
  CONFIG_RELOCATABLE=y

WARNING: vmlinux - Section mismatch: reference to .init.data:initkmem_list3 from .text between 'set_up_list3s' (at offset 0xc01536d9) and 's_start'

o I don't know the code well but looks like this is a bug.  initkmem_list3
  is of type __initdata, and it is accessed by non init functions.

	kmem_cache_create()
		setup_cpu_cache()
			set_up_list3s()
				{
					Accesses initkmem_list3[]
				}

o Somebody who knows this code well needs to review and ack.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slab.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~make-initkmem_list3-non-init-data-to-fix-modpost-warning mm/slab.c
--- a/mm/slab.c~make-initkmem_list3-non-init-data-to-fix-modpost-warning
+++ a/mm/slab.c
@@ -305,7 +305,7 @@ struct kmem_list3 {
  * Need this for bootstrapping a per node allocator.
  */
 #define NUM_INIT_LISTS (2 * MAX_NUMNODES + 1)
-struct kmem_list3 __initdata initkmem_list3[NUM_INIT_LISTS];
+struct kmem_list3 initkmem_list3[NUM_INIT_LISTS];
 #define	CACHE_CACHE 0
 #define	SIZE_AC 1
 #define	SIZE_L3 (1 + MAX_NUMNODES)
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch
kdump-documentation-update-for-2620.patch
pci-quirks-modpost-warning-fix.patch
make-initkmem_list3-non-init-data-to-fix-modpost-warning.patch
i386-sched_clock-using-init-data-tsc_disable-fix.patch
make-noirqdebug_setup-function-non-init-to-fix-modpost-warning.patch
scsi-megaraid_mmmbox-init-fix-for-kdump.patch
i386-cpu-hotplug-smpboot-misc-modpost-warning-fixes.patch
convert-some-functions-to-__init-to-avoid-modpost-warnings.patch
i386-move-startup_32-in-texthead-section.patch
break-init-in-two-parts-to-avoid-modpost-warnings.patch
i386-fix-memory-hotplug-related-modpost-generated-warning.patch
i386-make-apic-probe-function-non-init.patch
modpost-add-more-symbols-to-whitelist-pattern2.patch
modpost-whitelist-reference-to-more-symbols-pattern-3.patch
clockevents-i386-drivers.patch
