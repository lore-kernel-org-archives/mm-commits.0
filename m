From: akpm@linux-foundation.org
Subject: + coredump-masking-elf-fdpic-remove-an-unused-argument.patch added to -mm tree
Date: Tue, 29 May 2007 14:40:24 -0700
Message-ID: <200705292140.l4TLeOuD012326@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbXE2Vki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:40:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidehiro.kawai.ez@hitachi.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     coredump masking: ELF-FDPIC: remove an unused argument
has been added to the -mm tree.  Its filename is
     coredump-masking-elf-fdpic-remove-an-unused-argument.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coredump masking: ELF-FDPIC: remove an unused argument
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>

This patch removes an unused argument from elf_fdpic_dump_segments().

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~coredump-masking-elf-fdpic-remove-an-unused-argument fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~coredump-masking-elf-fdpic-remove-an-unused-argument
+++ a/fs/binfmt_elf_fdpic.c
@@ -1456,8 +1456,8 @@ static int elf_dump_thread_status(long s
  * dump the segments for an MMU process
  */
 #ifdef CONFIG_MMU
-static int elf_fdpic_dump_segments(struct file *file, struct mm_struct *mm,
-				   size_t *size, unsigned long *limit)
+static int elf_fdpic_dump_segments(struct file *file, size_t *size,
+				   unsigned long *limit)
 {
 	struct vm_area_struct *vma;
 
@@ -1511,8 +1511,8 @@ end_coredump:
  * dump the segments for a NOMMU process
  */
 #ifndef CONFIG_MMU
-static int elf_fdpic_dump_segments(struct file *file, struct mm_struct *mm,
-				   size_t *size, unsigned long *limit)
+static int elf_fdpic_dump_segments(struct file *file, size_t *size,
+				   unsigned long *limit)
 {
 	struct vm_list_struct *vml;
 
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
