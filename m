From: akpm@linux-foundation.org
Subject: [merged] sound-soc-codecs-si476xc-dont-use-0bnnn.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:22:56 -0700
Message-ID: <51db1190.9zdiNLAdRtZo1yOV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3GHTW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:22:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tiwai@suse.de, broonie@opensource.wolfsonmicro.com, andrey.smirnov@convergeddevices.net, akpm@linux-foundation.org

Subject: [merged] sound-soc-codecs-si476xc-dont-use-0bnnn.patch removed from -mm tree
To: akpm@linux-foundation.org,andrey.smirnov@convergeddevices.net,broonie@opensource.wolfsonmicro.com,tiwai@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:22:56 -0700


The patch titled
     Subject: sound/soc/codecs/si476x.c: don't use 0bNNN
has been removed from the -mm tree.  Its filename was
     sound-soc-codecs-si476xc-dont-use-0bnnn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sound/soc/codecs/si476x.c: don't use 0bNNN

spacr64 gcc-3.4.5 (at least) spits this back.

Cc: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/codecs/si476x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN sound/soc/codecs/si476x.c~sound-soc-codecs-si476xc-dont-use-0bnnn sound/soc/codecs/si476x.c
--- a/sound/soc/codecs/si476x.c~sound-soc-codecs-si476xc-dont-use-0bnnn
+++ a/sound/soc/codecs/si476x.c
@@ -38,9 +38,9 @@ enum si476x_digital_io_output_format {
 	SI476X_DIGITAL_IO_SAMPLE_SIZE_SHIFT	= 8,
 };
 
-#define SI476X_DIGITAL_IO_OUTPUT_WIDTH_MASK	((0b111 << SI476X_DIGITAL_IO_SLOT_SIZE_SHIFT) | \
-						  (0b111 << SI476X_DIGITAL_IO_SAMPLE_SIZE_SHIFT))
-#define SI476X_DIGITAL_IO_OUTPUT_FORMAT_MASK	(0b1111110)
+#define SI476X_DIGITAL_IO_OUTPUT_WIDTH_MASK	((0x7 << SI476X_DIGITAL_IO_SLOT_SIZE_SHIFT) | \
+						  (0x7 << SI476X_DIGITAL_IO_SAMPLE_SIZE_SHIFT))
+#define SI476X_DIGITAL_IO_OUTPUT_FORMAT_MASK	(0x7e)
 
 enum si476x_daudio_formats {
 	SI476X_DAUDIO_MODE_I2S		= (0x0 << 1),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
mm.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix-fix.patch
include-linux-mmzoneh-cleanups.patch
drop_caches-add-some-documentation-and-info-messsge.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

