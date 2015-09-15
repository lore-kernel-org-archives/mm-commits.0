From: akpm@linux-foundation.org
Subject: +
 mm-memory-hot-add-memory-can-not-be-added-to-movable-zone-defaultly-fix.patch added to -mm tree
Date: Tue, 15 Sep 2015 14:49:57 -0700
Message-ID: <55f89285.UDXsRxGDQdfNcCoV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbbIOVt6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 17:49:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave.hansen@intel.com, fandd@inspur.com, guz.fnst@cn.fujitsu.com, hutao@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com, liuchangcheng@inspur.com, qiuxishi@huawei.com, tangchen@cn.fujitsu.com, toshi.kani@hp.com, wangnan0@huawei.com, yanxiaofeng@inspur.com, yinghai@kernel.org, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-hot-add-memory-can-not-be-added-to-movable-zone-defaultly-fix
has been added to the -mm tree.  Its filename is
     mm-memory-hot-add-memory-can-not-be-added-to-movable-zone-defaultly-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-hot-add-memory-can-not-be-added-to-movable-zone-defaultly-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-hot-add-memory-can-not-be-added-to-movable-zone-defaultly-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-hot-add-memory-can-not-be-added-to-movable-zone-defaultly-fix

fix comment, fix code layout

Cc: Changsheng Liu <liuchangcheng@inspur.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dongdong Fan <fandd@inspur.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Hu Tao <hutao@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Wang Nan <wangnan0@huawei.com>
Cc: Xiaofeng Yan <yanxiaofeng@inspur.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory-hot-add-memory-can-not-be-added-to-movable-zone-defaultly-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory-hot-add-memory-can-not-be-added-to-movable-zone-defaultly-fix
+++ a/mm/memory_hotplug.c
@@ -1201,10 +1201,10 @@ static int check_hotplug_memory_range(u6
 /*
  * If movable zone has already been setup, newly added memory should be check.
  * If its address is higher than movable zone, it should be added as movable.
- * And if system boots up with movable_node and config CONFIG_MOVABLE_NOD and
- * added memory does not overlap the zone before MOVABLE_ZONE,
- * the memory is added as movable
- * Without this check, movable zone may overlap with other zone.
+ * And if system boots up with movable_node and config CONFIG_MOVABLE_NODE and
+ * added memory does not overlap the zone before MOVABLE_ZONE, the memory is
+ * added as movable.  Without this check, movable zone may overlap with other
+ * zone.
  */
 static int should_add_memory_movable(int nid, u64 start, u64 size)
 {
@@ -1213,8 +1213,7 @@ static int should_add_memory_movable(int
 	struct zone *movable_zone = pgdat->node_zones + ZONE_MOVABLE;
 	struct zone *pre_zone = pgdat->node_zones + (ZONE_MOVABLE - 1);
 
-	if (movable_node_is_enabled()
-	&& zone_end_pfn(pre_zone) <= start_pfn)
+	if (movable_node_is_enabled() && zone_end_pfn(pre_zone) <= start_pfn)
 		return 1;
 
 	if (zone_is_empty(movable_zone))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
mm-memory-hot-add-memory-can-not-be-added-to-movable-zone-defaultly-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

