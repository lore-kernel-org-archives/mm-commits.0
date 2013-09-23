From: akpm@linux-foundation.org
Subject: +
 fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch added to -mm tree
Date: Mon, 23 Sep 2013 15:20:05 -0700
Message-ID: <5240be95.nFTjFNYqeISQa5Z8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3IWWUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 18:20:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@gmail.com, alonid@stratoscale.com, akpm@linux-foundation.org

Subject: + fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch added to -mm tree
To: akpm@linux-foundation.org,alonid@stratoscale.com,fengguang.wu@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 15:20:05 -0700


The patch titled
     Subject: fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix
has been added to the -mm tree.  Its filename is
     fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch

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
Subject: fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix

fix sparse warning

Cc: Dan Aloni <alonid@stratoscale.com>
Reported-by: Fengguang Wu <fengguang.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix
+++ a/fs/binfmt_elf.c
@@ -2050,7 +2050,7 @@ static int elf_core_dump(struct coredump
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff, foffset;
-	struct elf_note_info info = {0, };
+	struct elf_note_info info = { };
 	struct elf_phdr *phdr4note = NULL;
 	struct elf_shdr *shdr4extnum = NULL;
 	Elf_Half e_phnum;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
watchdog-update-watchdog_tresh-properly-fix.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
sound-soc-atmel-atmel-pcmc-fix-warning.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

