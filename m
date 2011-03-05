From: akpm@linux-foundation.org
Subject: + mm-add-__gfp_other_node-flag-checkpatch-fixes.patch added to -mm tree
Date: Fri, 04 Mar 2011 16:07:49 -0800
Message-ID: <201103050007.p2507okm011930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759880Ab1CEAHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 19:07:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com


The patch titled
     mm-add-__gfp_other_node-flag-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-add-__gfp_other_node-flag-checkpatch-fixes.patch

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
Subject: mm-add-__gfp_other_node-flag-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#46: FILE: include/linux/gfp.h:87:
+#define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */

ERROR: space required after that ',' (ctx:VxV)
#64: FILE: include/linux/vmstat.h:228:
+#define zone_statistics(_zl,_z, gfp) do { } while (0)
                            ^

ERROR: trailing whitespace
#87: FILE: mm/vmstat.c:503:
+ * $

ERROR: trailing whitespace
#102: FILE: mm/vmstat.c:516:
+^Iif (z->node == ((flags & __GFP_OTHER_NODE) ? $

total: 3 errors, 1 warnings, 58 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-add-__gfp_other_node-flag.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +-
 mm/vmstat.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/vmstat.h~mm-add-__gfp_other_node-flag-checkpatch-fixes include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-add-__gfp_other_node-flag-checkpatch-fixes
+++ a/include/linux/vmstat.h
@@ -225,7 +225,7 @@ extern void zone_statistics(struct zone 
 #else
 
 #define node_page_state(node, item) global_page_state(item)
-#define zone_statistics(_zl,_z, gfp) do { } while (0)
+#define zone_statistics(_zl, _z, gfp) do { } while (0)
 
 #endif /* CONFIG_NUMA */
 
diff -puN mm/vmstat.c~mm-add-__gfp_other_node-flag-checkpatch-fixes mm/vmstat.c
--- a/mm/vmstat.c~mm-add-__gfp_other_node-flag-checkpatch-fixes
+++ a/mm/vmstat.c
@@ -500,7 +500,7 @@ void refresh_cpu_vm_stats(int cpu)
  * z 	    = the zone from which the allocation occurred.
  *
  * Must be called with interrupts disabled.
- * 
+ *
  * When __GFP_OTHER_NODE is set assume the node of the preferred
  * zone is the local node. This is useful for daemons who allocate
  * memory on behalf of other processes.
@@ -513,7 +513,7 @@ void zone_statistics(struct zone *prefer
 		__inc_zone_state(z, NUMA_MISS);
 		__inc_zone_state(preferred_zone, NUMA_FOREIGN);
 	}
-	if (z->node == ((flags & __GFP_OTHER_NODE) ? 
+	if (z->node == ((flags & __GFP_OTHER_NODE) ?
 			preferred_zone->node : numa_node_id()))
 		__inc_zone_state(z, NUMA_LOCAL);
 	else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cpuset-add-a-missing-unlock-in-cpuset_write_resmask-fix.patch
mm-use-correct-numa-policy-node-for-transparent-hugepages-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-usb-serial-usb_wwanc-unbork.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
lib-vsprintf-optimised-put_dec-function-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

