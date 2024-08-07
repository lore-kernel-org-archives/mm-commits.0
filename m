Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD84163;
	Wed,  7 Aug 2024 19:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723057762; cv=none; b=s2c3PxV1iHciOlt6nF7haJVqoIoDIx1IYLOn6YJLeC8BzjJuYLLETTS51vnL2pXkJscK3hsc082OIrMdeSGazz+t2HGFEjLmc5MME4DgonscOqEDeCSupHHEzBShuupbMsWP6P5VfVIKH6BsQn25Ob7N0guGTmk2/Iw0NCNxo2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723057762; c=relaxed/simple;
	bh=0mcqv887rtcsJNgnXWgevWOvmRT7YFtrgyfE9Tmgt1Y=;
	h=Date:To:From:Subject:Message-Id; b=frkciPWqqb1t8BTpSWYQlmoV6wfykpLTh1OSBXjrl0UL+r5OZIUYTO+J8+uhsICrRTyxkybrNFNMtX7/pUIsARPR/YMJ4dhbnAYQ5gFAS6rd686pA573rZonGZGyS/RBhrdaovLEpp0h1qiiQuVjxBh8dFqNQ5r5D3etk0XtzKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g3dQ66Ti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g3dQ66Ti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE915C32781;
	Wed,  7 Aug 2024 19:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723057762;
	bh=0mcqv887rtcsJNgnXWgevWOvmRT7YFtrgyfE9Tmgt1Y=;
	h=Date:To:From:Subject:From;
	b=g3dQ66TiZHD54MO+5KzjysSby0Hn0Qn31mk/bPztFNoX6SgaC1h6e5NHnIumv2ZB4
	 r4FzP7+ZloBq3XQxN0sZ/MlwoWTtj0AsO4GVPI2X93QXRzjqy7sulV/yKCw9GpqEJo
	 JIblQNErzDmRAHcjNGv6FGLQ/rXAfL0ZGE6QAdPQ=
Date: Wed, 07 Aug 2024 12:09:20 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryabinin.a.a@gmail.com,andreyknvl@google.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-double-depot_pools_cap-if-kasan-is-enabled.patch added to mm-hotfixes-unstable branch
Message-Id: <20240807190921.EE915C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/stackdepot: double DEPOT_POOLS_CAP if KASAN is enabled
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-stackdepot-double-depot_pools_cap-if-kasan-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-double-depot_pools_cap-if-kasan-is-enabled.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: lib/stackdepot: double DEPOT_POOLS_CAP if KASAN is enabled
Date: Wed, 7 Aug 2024 12:52:28 -0400

When a wide variety of workloads are run on a debug kernel with KASAN
enabled, the following warning may sometimes be printed.

 [ 6818.650674] Stack depot reached limit capacity
 [ 6818.650730] WARNING: CPU: 1 PID: 272741 at lib/stackdepot.c:252 depot_alloc_stack+0x39e/0x3d0
   :
 [ 6818.650907] Call Trace:
 [ 6818.650909]  [<00047dd453d84b92>] depot_alloc_stack+0x3a2/0x3d0
 [ 6818.650916]  [<00047dd453d85254>] stack_depot_save_flags+0x4f4/0x5c0
 [ 6818.650920]  [<00047dd4535872c6>] kasan_save_stack+0x56/0x70
 [ 6818.650924]  [<00047dd453587328>] kasan_save_track+0x28/0x40
 [ 6818.650927]  [<00047dd45358a27a>] kasan_save_free_info+0x4a/0x70
 [ 6818.650930]  [<00047dd45358766a>] __kasan_slab_free+0x12a/0x1d0
 [ 6818.650933]  [<00047dd45350deb4>] kmem_cache_free+0x1b4/0x580
 [ 6818.650938]  [<00047dd452c520da>] __put_task_struct+0x24a/0x320
 [ 6818.650945]  [<00047dd452c6aee4>] delayed_put_task_struct+0x294/0x350
 [ 6818.650949]  [<00047dd452e9066a>] rcu_do_batch+0x6ea/0x2090
 [ 6818.650953]  [<00047dd452ea60f4>] rcu_core+0x474/0xa90
 [ 6818.650956]  [<00047dd452c780c0>] handle_softirqs+0x3c0/0xf90
 [ 6818.650960]  [<00047dd452c76fbe>] __irq_exit_rcu+0x35e/0x460
 [ 6818.650963]  [<00047dd452c79992>] irq_exit_rcu+0x22/0xb0
 [ 6818.650966]  [<00047dd454bd8128>] do_ext_irq+0xd8/0x120
 [ 6818.650972]  [<00047dd454c0ddd0>] ext_int_handler+0xb8/0xe8
 [ 6818.650979]  [<00047dd453589cf6>] kasan_check_range+0x236/0x2f0
 [ 6818.650982]  [<00047dd453378cf0>] filemap_get_pages+0x190/0xaa0
 [ 6818.650986]  [<00047dd453379940>] filemap_read+0x340/0xa70
 [ 6818.650989]  [<00047dd3d325d226>] xfs_file_buffered_read+0x2c6/0x400 [xfs]
 [ 6818.651431]  [<00047dd3d325dfe2>] xfs_file_read_iter+0x2c2/0x550 [xfs]
 [ 6818.651663]  [<00047dd45364710c>] vfs_read+0x64c/0x8c0
 [ 6818.651669]  [<00047dd453648ed8>] ksys_read+0x118/0x200
 [ 6818.651672]  [<00047dd452b6cf5a>] do_syscall+0x27a/0x380
 [ 6818.651676]  [<00047dd454bd7e74>] __do_syscall+0xf4/0x1a0
 [ 6818.651680]  [<00047dd454c0db58>] system_call+0x70/0x98

As KASAN is a big user of stackdepot, the current DEPOT_POOLS_CAP of
8192 may not be enough. Double DEPOT_POOLS_CAP if KASAN is enabled to
avoid hitting this problem.

Also use the MIN() macro for defining DEPOT_MAX_POOLS to clarify the
intention.

Link: https://lkml.kernel.org/r/20240807165228.1116831-1-longman@redhat.com
Fixes: 02754e0a484a ("lib/stackdepot.c: bump stackdepot capacity from 16MB to 128MB")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-double-depot_pools_cap-if-kasan-is-enabled
+++ a/lib/stackdepot.c
@@ -36,11 +36,12 @@
 #include <linux/memblock.h>
 #include <linux/kasan-enabled.h>
 
-#define DEPOT_POOLS_CAP 8192
+/* KASAN is a big user of stackdepot, double the cap if KASAN is enabled */
+#define DEPOT_POOLS_CAP (8192 * (IS_ENABLED(CONFIG_KASAN) ? 2 : 1))
+
 /* The pool_index is offset by 1 so the first record does not have a 0 handle. */
 #define DEPOT_MAX_POOLS \
-	(((1LL << (DEPOT_POOL_INDEX_BITS)) - 1 < DEPOT_POOLS_CAP) ? \
-	 (1LL << (DEPOT_POOL_INDEX_BITS)) - 1 : DEPOT_POOLS_CAP)
+	MIN((1LL << (DEPOT_POOL_INDEX_BITS)) - 1, DEPOT_POOLS_CAP)
 
 static bool stack_depot_disabled;
 static bool __stack_depot_early_init_requested __initdata = IS_ENABLED(CONFIG_STACKDEPOT_ALWAYS_INIT);
_

Patches currently in -mm which might be from longman@redhat.com are

padata-fix-possible-divide-by-0-panic-in-padata_mt_helper.patch
mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu.patch
mm-memory-failure-use-raw_spinlock_t-in-struct-memory_failure_cpu-v3.patch
lib-stackdepot-double-depot_pools_cap-if-kasan-is-enabled.patch
watchdog-handle-the-enodev-failure-case-of-lockup_detector_delay_init-separately.patch

