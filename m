From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch removed from -mm tree
Date: Mon, 30 Sep 2013 13:40:14 -0700
Message-ID: <5249e1ae.bnYJrRuTljt3vCjy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab3I3UkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Sep 2013 16:40:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, alonid@stratoscale.com, akpm@linux-foundation.org

Subject: [folded-merged] fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,alonid@stratoscale.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 30 Sep 2013 13:40:14 -0700


The patch titled
     Subject: fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch

This patch was dropped because it was folded into fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix

- avoid abusing E2BIG
- remove a couple of not-really-needed local variables

Cc: Dan Aloni <alonid@stratoscale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN fs/binfmt_elf.c~fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix
+++ a/fs/binfmt_elf.c
@@ -1428,7 +1428,7 @@ static int fill_files_note(struct memelf
 	names_ofs = (2 + 3 * count) * sizeof(data[0]);
  alloc:
 	if (size >= MAX_FILE_NOTE_SIZE) /* paranoia check */
-		return -E2BIG;
+		return -EINVAL;
 	size = round_up(size, PAGE_SIZE);
 	data = vmalloc(size);
 	if (!data)
@@ -1607,7 +1607,6 @@ static int fill_note_info(struct elfhdr
 	struct elf_prpsinfo *psinfo;
 	struct core_thread *ct;
 	unsigned int i;
-	int ret;
 
 	info->size = 0;
 	info->thread = NULL;
@@ -1687,8 +1686,7 @@ static int fill_note_info(struct elfhdr
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
-	ret = fill_files_note(&info->files);
-	if (!ret)
+	if (fill_files_note(&info->files) == 0)
 		info->size += notesize(&info->files);
 
 	return 1;
@@ -1853,7 +1851,6 @@ static int fill_note_info(struct elfhdr
 			  siginfo_t *siginfo, struct pt_regs *regs)
 {
 	struct list_head *t;
-	int ret;
 
 	if (!elf_note_info_init(info))
 		return 0;
@@ -1903,8 +1900,7 @@ static int fill_note_info(struct elfhdr
 	fill_auxv_note(info->notes + 3, current->mm);
 	info->numnote = 4;
 
-	ret = fill_files_note(info->notes + info->numnote);
-	if (!ret) {
+	if (fill_files_note(info->notes + info->numnote) == 0) {
 		info->notes_files = info->notes + info->numnote;
 		info->numnote++;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
include-asm-generic-vtimeh-avoid-zero-length-file.patch
mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch
ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
memblock-factor-out-of-top-down-allocation-hack.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
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
x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

