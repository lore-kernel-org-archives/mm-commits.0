From: akpm@linux-foundation.org
Subject: + docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch added to -mm tree
Date: Tue, 27 Nov 2012 14:48:23 -0800
Message-ID: <20121127224824.C31D6200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:40734 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab2K0Ws3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 17:48:29 -0500
Received: by mail-lb0-f202.google.com with SMTP id i15so894956lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 14:48:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, gorcunov@openvz.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix
has been added to the -mm tree.  Its filename is
     docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch

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
Subject: docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix

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

 Documentation/filesystems/proc.txt |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN Documentation/filesystems/proc.txt~docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix
+++ a/Documentation/filesystems/proc.txt
@@ -1639,7 +1639,7 @@ if precise results are needed.
 This file provides information associated with an opened file. The regular
 files have at least two fields -- 'pos' and 'flags'. The 'pos' represents
 the current offset of the opened file in decimal form [see lseek(2) for
-details] and the 'flags' denotes octal O_xxx mask the file has been
+details] and 'flags' denotes the octal O_xxx mask the file has been
 created with [see open(2) for details].
 
 A typical output is
@@ -1648,7 +1648,7 @@ A typical output is
 	flags:	0100002
 
 The files such as eventfd, fsnotify, signalfd, epoll among the regular pos/flags
-pair provide additional information peculiar to the objects they represent.
+pair provide additional information particular to the objects they represent.
 
 	Eventfd files
 	~~~~~~~~~~~~~
@@ -1687,17 +1687,18 @@ pair provide additional information pecu
 
 	where 'wd' is a watch descriptor in decimal form, ie a target file
 	descriptor number, 'ino' and 'sdev' are inode and device where the
-	target file lays on and the 'mask' is the mask of events, all in hex
+	target file resides and the 'mask' is the mask of events, all in hex
 	form [see inotify(7) for more details].
 
-	In case if the kernel built with exportfs the path to the target file
-	is encoded as a file handle. The file handle provided by three fields
-	'fhandle-bytes', 'fhandle-type' and 'f_handle', all in hex format.
+	If the kernel was built with exportfs support, the path to the target
+	file is encoded as a file handle.  The file handle is provided by three
+	fields 'fhandle-bytes', 'fhandle-type' and 'f_handle', all in hex
+	format.
 
 	If the kernel is built without exportfs support the file handle won't be
 	printed out.
 
-	For fanotify files the format is the following
+	For fanotify files the format is
 
 	pos:	0
 	flags:	02
@@ -1709,9 +1710,9 @@ pair provide additional information pecu
 	flags:	02
 	fanotify mnt_id:13 mask:1 ignored_mask:40000000
 
-	where 'ino', 'sdev' are target inode and device, 'mnt_id' is the mount point identifier,
-	'mask' is the events mask used and 'ignored_mask' is the mask of events which are
-	to be ignored. All written in hex format.
+	where 'ino', 'sdev' are target inode and device, 'mnt_id' is the mount
+	point identifier, 'mask' is the events mask used and 'ignored_mask' is
+	the mask of events which are to be ignored. All in hex format.
 
 
 ------------------------------------------------------------------------------
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
drivers-video-add-support-for-the-solomon-ssd1307-oled-controller-checkpatch-fixes.patch
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
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
thp-implement-splitting-pmd-for-huge-zero-page-fix.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
mm-introduce-new-field-managed_pages-to-struct-zone-fix.patch
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
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

