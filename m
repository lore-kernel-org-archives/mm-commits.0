From: akpm@linux-foundation.org
Subject: [merged]
 tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:34 -0700
Message-ID: <51db14fe.Gh87JaA6ey4c0LCy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3GHThf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dyoung@redhat.com, artagnon@gmail.com, akpm@linux-foundation.org

Subject: [merged] tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts.patch removed from -mm tree
To: akpm@linux-foundation.org,artagnon@gmail.com,dyoung@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:34 -0700


The patch titled
     Subject: tools/testing/selftests: don't assume the x bit is set on scripts
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools/testing/selftests: don't assume the x bit is set on scripts

The x bit can easily get lost (patch(1) loses it, for example).

Reported-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cpu-hotplug/Makefile    |    2 +-
 tools/testing/selftests/memory-hotplug/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/cpu-hotplug/Makefile~tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts tools/testing/selftests/cpu-hotplug/Makefile
--- a/tools/testing/selftests/cpu-hotplug/Makefile~tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts
+++ a/tools/testing/selftests/cpu-hotplug/Makefile
@@ -1,6 +1,6 @@
 all:
 
 run_tests:
-	@./on-off-test.sh || echo "cpu-hotplug selftests: [FAIL]"
+	@/bin/sh ./on-off-test.sh || echo "cpu-hotplug selftests: [FAIL]"
 
 clean:
diff -puN tools/testing/selftests/memory-hotplug/Makefile~tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts tools/testing/selftests/memory-hotplug/Makefile
--- a/tools/testing/selftests/memory-hotplug/Makefile~tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts
+++ a/tools/testing/selftests/memory-hotplug/Makefile
@@ -1,6 +1,6 @@
 all:
 
 run_tests:
-	@./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
+	@/bin/sh ./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
 
 clean:
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

