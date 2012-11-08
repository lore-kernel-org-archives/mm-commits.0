From: akpm@linux-foundation.org
Subject: [folded-merged] revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch removed from -mm tree
Date: Thu, 08 Nov 2012 15:51:29 -0800
Message-ID: <20121108235130.A25385C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:34567 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2KHXvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 18:51:33 -0500
Received: by mail-ea0-f202.google.com with SMTP id q10so213239eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 15:51:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mtk.manpages@gmail.com, palewis@adobe.com, mm-commits@vger.kernel.org


The patch titled
     Subject: revert-tools-testing-selftests-epoll-test_epollc-fix-build
has been removed from the -mm tree.  Its filename was
     revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch

This patch was dropped because it was folded into revert-epoll-support-for-disabling-items-and-a-self-test-app.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert-tools-testing-selftests-epoll-test_epollc-fix-build

To include in revert-epoll-support-for-disabling-items-and-a-self-test-app.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/epoll/test_epoll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/epoll/test_epoll.c~revert-tools-testing-selftests-epoll-test_epollc-fix-build tools/testing/selftests/epoll/test_epoll.c
--- a/tools/testing/selftests/epoll/test_epoll.c~revert-tools-testing-selftests-epoll-test_epollc-fix-build
+++ a/tools/testing/selftests/epoll/test_epoll.c
@@ -162,14 +162,14 @@ void *write_thread_function(void *functi
 	int index;
 	struct write_thread_data *thread_data =
 		(struct write_thread_data *)function_data;
-	while (!thread_data->stop)
+	while (!write_thread_data->stop)
 		for (index = 0;
 		     !thread_data->stop && (index < thread_data->n_fds);
 		     ++index)
 			if ((write(thread_data->fds[index], &data, 1) < 1) &&
 				(errno != EAGAIN) &&
 				(errno != EWOULDBLOCK)) {
-				thread_data->status = errno;
+				write_thread_data->status = errno;
 				return;
 			}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
irq-tsk-comm-is-an-array-fix.patch
drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
slub-slub-specific-propagation-changes-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-adjust-address_space_operationsmigratepage-return-code-fix.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

