From: akpm@linux-foundation.org
Subject: +
 vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch added
 to -mm tree
Date: Thu, 23 May 2013 15:25:12 -0700
Message-ID: <519e9748.t8ykD3DwspUDPRmS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759846Ab3EWWZV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 18:25:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vgoyal@redhat.com, lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp, kosaki.motohiro@jp.fujitsu.com, d.hatayama@jp.fujitsu.com, akpm@linux-foundation.org

Subject: + vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch added to -mm tree
To: akpm@linux-foundation.org,d.hatayama@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,kumagai-atsushi@mxc.nes.nec.co.jp,lisa.mitchell@hp.com,vgoyal@redhat.com,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 15:25:12 -0700


The patch titled
     Subject: vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix
has been added to the -mm tree.  Its filename is
     vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch

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
Subject: vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix

use the conventional comment layout format

Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lisa Mitchell <lisa.mitchell@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix
+++ a/fs/proc/vmcore.c
@@ -386,8 +386,10 @@ static int __init merge_note_headers_elf
 	if (!*notes_buf)
 		return -ENOMEM;
 
-	/* Allow users to remap ELF note segment buffer on vmalloc
-	 * memory using remap_vmalloc_range. */
+	/*
+	 * Allow users to remap ELF note segment buffer on vmalloc memory using
+	 * remap_vmalloc_range.()
+	 */
 	vm = find_vm_area(*notes_buf);
 	BUG_ON(!vm);
 	vm->flags |= VM_USERMAP;
@@ -572,8 +574,10 @@ static int __init merge_note_headers_elf
 	if (!*notes_buf)
 		return -ENOMEM;
 
-	/* Allow users to remap ELF note segment buffer on vmalloc
-	 * memory using remap_vmalloc_range. */
+	/*
+	 * Allow users to remap ELF note segment buffer on vmalloc memory using
+	 * remap_vmalloc_range()
+	 */
 	vm = find_vm_area(*notes_buf);
 	BUG_ON(!vm);
 	vm->flags |= VM_USERMAP;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
revert-selftest-add-simple-test-for-soft-dirty-bit.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

