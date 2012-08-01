From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-v4l2-ioctlc-fix-build.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:11:20 -0700
Message-ID: <20120801201120.AF4561E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41190 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2HAULV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:11:21 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5410915obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:11:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/media/video/v4l2-ioctl.c: fix build
has been removed from the -mm tree.  Its filename was
     drivers-media-video-v4l2-ioctlc-fix-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
mm-slab_commonc-fix-warning.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

