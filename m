From: akpm@linux-foundation.org
Subject: [folded-merged]
 slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch removed from -mm tree
Date: Mon, 07 Apr 2014 15:19:28 -0700
Message-ID: <53432470.XHgKeLAXpa9Bi0qf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaDGWT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:19:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, fengguang.wu@intel.com, cl@linux.com, akpm@linux-foundation.org

Subject: [folded-merged] slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,cl@linux.com,fengguang.wu@intel.com,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:19:28 -0700


The patch titled
     Subject: slub-use-raw_cpu_inc-for-incrementing-statistics-fix
has been removed from the -mm tree.  Its filename was
     slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch

This patch was dropped because it was folded into slub-use-raw_cpu_inc-for-incrementing-statistics.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slub-use-raw_cpu_inc-for-incrementing-statistics-fix

add comment

Cc: Christoph Lameter <cl@linux.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/slub.c~slub-use-raw_cpu_inc-for-incrementing-statistics-fix mm/slub.c
--- a/mm/slub.c~slub-use-raw_cpu_inc-for-incrementing-statistics-fix
+++ a/mm/slub.c
@@ -224,6 +224,10 @@ static inline void memcg_propagate_slab_
 static inline void stat(const struct kmem_cache *s, enum stat_item si)
 {
 #ifdef CONFIG_SLUB_STATS
+	/*
+	 * The rmw is racy on a preemptible kernel but this is acceptable, so
+	 * avoid this_cpu_add()'s irq-disable overhead.
+	 */
 	raw_cpu_inc(s->cpu_slab->stat[si]);
 #endif
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
mm-use-macros-from-compilerh-instead-of-__attribute__.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends.patch
zram-return-error-valued-pointer-from-zcomp_create.patch
zram-propagate-error-to-user.patch
zram-support-req_discard.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
initramfs-debug-detected-compression-method.patch
slub-use-raw_cpu_inc-for-incrementing-statistics.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

