From: akpm@linux-foundation.org
Subject: + drivers-media-video-v4l2-ioctlc-fix-build.patch added to -mm tree
Date: Tue, 31 Jul 2012 14:51:40 -0700
Message-ID: <20120731223843.BB84A1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:34918 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab2GaWip (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 18:38:45 -0400
Received: by obbwc20 with SMTP id wc20so4794537obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 15:38:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mchehab@infradead.org


The patch titled
     Subject: drivers/media/video/v4l2-ioctl.c: fix build
has been added to the -mm tree.  Its filename is
     drivers-media-video-v4l2-ioctlc-fix-build.patch

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
Subject: drivers/media/video/v4l2-ioctl.c: fix build

Fix zillions of these:

drivers/media/video/v4l2-ioctl.c:1848: error: unknown field 'func' specified in initializer
drivers/media/video/v4l2-ioctl.c:1848: warning: missing braces around initializer
drivers/media/video/v4l2-ioctl.c:1848: warning: (near initialization for 'v4l2_ioctls[0].<anonymous>')
drivers/media/video/v4l2-ioctl.c:1848: warning: initialization makes integer from pointer without a cast
drivers/media/video/v4l2-ioctl.c:1848: error: initializer element is not computable at load time
drivers/media/video/v4l2-ioctl.c:1848: error: (near initialization for 'v4l2_ioctls[0].<anonymous>.offset')

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/v4l2-ioctl.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/v4l2-ioctl.c~drivers-media-video-v4l2-ioctlc-fix-build drivers/media/video/v4l2-ioctl.c
--- a/drivers/media/video/v4l2-ioctl.c~drivers-media-video-v4l2-ioctlc-fix-build
+++ a/drivers/media/video/v4l2-ioctl.c
@@ -1831,7 +1831,9 @@ struct v4l2_ioctl_info {
 		.ioctl = _ioctl,					\
 		.flags = _flags | INFO_FL_STD,				\
 		.name = #_ioctl,					\
-		.offset = offsetof(struct v4l2_ioctl_ops, _vidioc),	\
+		{							\
+			.offset = offsetof(struct v4l2_ioctl_ops, _vidioc),\
+		},							\
 		.debug = _debug,					\
 	}
 
@@ -1840,7 +1842,9 @@ struct v4l2_ioctl_info {
 		.ioctl = _ioctl,					\
 		.flags = _flags | INFO_FL_FUNC,				\
 		.name = #_ioctl,					\
-		.func = _func,						\
+		{							\
+			.func = _func,					\
+		},							\
 		.debug = _debug,					\
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm-slab_commonc-fix-warning.patch
mm.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
drivers-media-video-v4l2-ioctlc-fix-build.patch

