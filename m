From: akpm@linux-foundation.org
Subject: + binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch added to -mm tree
Date: Tue, 06 Nov 2012 16:16:12 -0800
Message-ID: <20121107001613.B84135C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:58396 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2KGAQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 19:16:18 -0500
Received: by mail-bk0-f74.google.com with SMTP id q16so68984bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 16:16:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aedilger@gmail.com, alan@linux.intel.com, arnn@arndb.de, drepper@redhat.com, gregkh@linuxfoundation.org, jakub@redhat.com, james.l.morris@oracle.com, jeff.liu@oracle.com, john.sobecki@oracle.com, keescook@chromium.org, tytso@mit.edu, viro@zeniv.linux.org.uk


The patch titled
     Subject: binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix
has been added to the -mm tree.  Its filename is
     binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch

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

revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
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
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

