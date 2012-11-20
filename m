From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-notify-add-procfs-fdinfo-helper-v6-fix.patch removed from -mm tree
Date: Mon, 19 Nov 2012 16:41:01 -0800
Message-ID: <20121120004101.875D482004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:58782 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2KTAlE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 19:41:04 -0500
Received: by mail-qa0-f74.google.com with SMTP id g40so76432qab.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 16:41:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, gorcunov@openvz.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-notify-add-procfs-fdinfo-helper-v6-fix
has been removed from the -mm tree.  Its filename was
     fs-notify-add-procfs-fdinfo-helper-v6-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-notify-add-procfs-fdinfo-helper-v6-fix

rationalize output formatting

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fdinfo.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/notify/fdinfo.c~fs-notify-add-procfs-fdinfo-helper-v6-fix fs/notify/fdinfo.c
--- a/fs/notify/fdinfo.c~fs-notify-add-procfs-fdinfo-helper-v6-fix
+++ a/fs/notify/fdinfo.c
@@ -50,7 +50,7 @@ static int show_mark_fhandle(struct seq_
 	f.handle.handle_bytes = sizeof(f.pad);
 	size = f.handle.handle_bytes >> 2;
 
-	ret = exportfs_encode_inode_fh(inode, (struct fid *)f.handle.f_handle, &size,  0);
+	ret = exportfs_encode_inode_fh(inode, (struct fid *)f.handle.f_handle, &size, 0);
 	if ((ret == 255) || (ret == -ENOSPC)) {
 		WARN_ONCE(1, "Can't encode file handler for inotify: %d\n", ret);
 		return 0;
@@ -59,7 +59,7 @@ static int show_mark_fhandle(struct seq_
 	f.handle.handle_type = ret;
 	f.handle.handle_bytes = size * sizeof(u32);
 
-	ret = seq_printf(m, "fhandle-bytes: %8x fhandle-type: %8x f_handle: ",
+	ret = seq_printf(m, "fhandle-bytes:%x fhandle-type:%x f_handle:",
 			 f.handle.handle_bytes, f.handle.handle_type);
 
 	for (i = 0; i < f.handle.handle_bytes; i++)
@@ -86,8 +86,8 @@ static int inotify_fdinfo(struct seq_fil
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
 	inode = igrab(mark->i.inode);
 	if (inode) {
-		ret = seq_printf(m, "inotify wd: %8d ino: %16lx sdev: %8x "
-				 "mask: %8x ignored_mask: %8x ",
+		ret = seq_printf(m, "inotify-wd:%x ino:%lx sdev:%x "
+				 "mask:%x ignored_mask:%x ",
 				 inode_mark->wd, inode->i_ino,
 				 inode->i_sb->s_dev,
 				 mark->mask, mark->ignored_mask);
@@ -120,15 +120,16 @@ static int fanotify_fdinfo(struct seq_fi
 		inode = igrab(mark->i.inode);
 		if (!inode)
 			goto out;
-		ret = seq_printf(m, "fanotify ino: %16lx sdev: %8x "
-				 "mask: %8x ignored_mask: %8x\n",
+		ret = seq_printf(m, "fanotify-ino:%x sdev:%x "
+				 "mask:%x ignored_mask:%x\n",
 				 inode->i_ino, inode->i_sb->s_dev,
 				 mark->mask, mark->ignored_mask);
 		iput(inode);
 	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT) {
 		struct mount *mnt = real_mount(mark->m.mnt);
 
-		ret = seq_printf(m, "fanotify mnt_id: %8x mask: %8x ignored_mask: %8x\n",
+		ret = seq_printf(m, "fanotify-mnt_id:%x mask:%x "
+				 "ignored_mask:%x\n",
 				 mnt->mnt_id, mark->mask, mark->ignored_mask);
 	}
 out:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-export-a-function-to-get-vm-committed-memory.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
irq-tsk-comm-is-an-array.patch
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
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

