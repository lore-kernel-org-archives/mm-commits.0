From: akpm@linux-foundation.org
Subject: + bug-using-__this_cpu_add-in-preemptible-code-init-1.patch added to -mm tree
Date: Wed, 19 Mar 2014 15:33:15 -0700
Message-ID: <532a1b2b.Foxt0hwIdFpAz6Ee%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832AbaCSWdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Mar 2014 18:33:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, fengguang.wu@intel.com, cl@linux.com

Subject: + bug-using-__this_cpu_add-in-preemptible-code-init-1.patch added to -mm tree
To: cl@linux.com,fengguang.wu@intel.com,penberg@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 19 Mar 2014 15:33:15 -0700


The patch titled
     Subject: slub: use raw_cpu_inc for incrementing statistics
has been added to the -mm tree.  Its filename is
     bug-using-__this_cpu_add-in-preemptible-code-init-1.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bug-using-__this_cpu_add-in-preemptible-code-init-1.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bug-using-__this_cpu_add-in-preemptible-code-init-1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slub: use raw_cpu_inc for incrementing statistics

Statistics are not critical to the operation of the allocation
but should also not cause too much overhead.

When __this_cpu_inc is altered to check if preemption is disabled this
triggers.  Use raw_cpu_inc to avoid the checks.  Using this_cpu_ops may
cause interrupt disable/enable sequences on various arches which may
significantly impact allocator performance.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~bug-using-__this_cpu_add-in-preemptible-code-init-1 mm/slub.c
--- a/mm/slub.c~bug-using-__this_cpu_add-in-preemptible-code-init-1
+++ a/mm/slub.c
@@ -224,7 +224,7 @@ static inline void memcg_propagate_slab_
 static inline void stat(const struct kmem_cache *s, enum stat_item si)
 {
 #ifdef CONFIG_SLUB_STATS
-	__this_cpu_inc(s->cpu_slab->stat[si]);
+	raw_cpu_inc(s->cpu_slab->stat[si]);
 #endif
 }
 
_

Patches currently in -mm which might be from cl@linux.com are

slub-fix-high-order-page-allocation-problem-with-__gfp_nofail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
percpu-add-raw_cpu_ops.patch
mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
bug-using-__this_cpu_add-in-preemptible-code-init-1.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

