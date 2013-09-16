From: akpm@linux-foundation.org
Subject: +
 fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch added to -mm tree
Date: Mon, 16 Sep 2013 16:57:36 -0700
Message-ID: <52379af0.DrcZ23LFHvzwxAqT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3IPX5h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Sep 2013 19:57:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, alonid@stratoscale.com, akpm@linux-foundation.org

Subject: + fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch added to -mm tree
To: akpm@linux-foundation.org,alonid@stratoscale.com
From: akpm@linux-foundation.org
Date: Mon, 16 Sep 2013 16:57:36 -0700


The patch titled
     Subject: fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix
has been added to the -mm tree.  Its filename is
     fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch

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

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

