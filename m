From: akpm@linux-foundation.org
Subject: [to-be-updated] binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch removed from -mm tree
Date: Wed, 14 Nov 2012 14:39:19 -0800
Message-ID: <20121114223919.DADE2100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:39080 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153Ab2KNWjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 17:39:22 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so104951vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 14:39:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aedilger@gmail.com, alan@linux.intel.com, arnn@arndb.de, drepper@redhat.com, gregkh@linuxfoundation.org, jakub@redhat.com, james.l.morris@oracle.com, jeff.liu@oracle.com, john.sobecki@oracle.com, keescook@chromium.org, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix
has been removed from the -mm tree.  Its filename was
     binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix

tweak code comment

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Andreas Dilger <aedilger@gmail.com>
Cc: Arnd Bergmann <arnn@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Jeff Liu <jeff.liu@oracle.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: John Sobecki <john.sobecki@oracle.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix
+++ a/fs/binfmt_elf.c
@@ -560,10 +560,8 @@ static unsigned long randomize_stack_top
 }
 
 /*
- * A wrapper of get_random_int() to generate random bytes which has lower
- * overhead than call get_random_bytes() directly.
- * create_elf_tables() call this function to generate 16 random bytes for
- * userspace PRNG seeding.
+ * Use get_random_int() to implement AT_RANDOM while avoiding depletion of
+ * the entropy pool.
  */
 static void randomize_stack_user(unsigned char *buf, size_t nbytes)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
swapfile-fix-name-leak-in-swapoff-fix.patch
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
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-adjust-address_space_operationsmigratepage-return-code-fix.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-export-a-function-to-get-vm-committed-memory-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
maintainers-add-joe-to-checkpatch-maintainers.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
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

