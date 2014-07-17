From: akpm@linux-foundation.org
Subject: + vmstat-on-demand-vmstat-workers-v8-fix.patch added to -mm tree
Date: Thu, 17 Jul 2014 13:23:38 -0700
Message-ID: <53c830ca.NF/YNv04jW4nunWV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:45866 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaGQUXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 16:23:39 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so296773oac.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 13:23:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, cl@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cpu_stat_off can be static
has been added to the -mm tree.  Its filename is
     vmstat-on-demand-vmstat-workers-v8-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-on-demand-vmstat-workers-v8-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-on-demand-vmstat-workers-v8-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: cpu_stat_off can be static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~vmstat-on-demand-vmstat-workers-v8-fix mm/vmstat.c
--- a/mm/vmstat.c~vmstat-on-demand-vmstat-workers-v8-fix
+++ a/mm/vmstat.c
@@ -1245,7 +1245,7 @@ static const struct file_operations proc
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
-struct cpumask *cpu_stat_off;
+static struct cpumask *cpu_stat_off;
 
 static void vmstat_update(struct work_struct *w)
 {
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
sh-also-try-passing-m4-nofpu-for-sh2a-builds.patch
mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch
slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-vmallocc-clean-up-map_vm_area-third-argument-v2.patch
vmstat-on-demand-vmstat-workers-v8-fix.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix.patch
add-lib-globc-fix.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch
debugging-keep-track-of-page-owners.patch

