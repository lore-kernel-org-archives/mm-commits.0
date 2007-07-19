From: akpm@linux-foundation.org
Subject: - coredump-masking-elf-fdpic-remove-an-unused-argument.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:22 -0700
Message-ID: <200707192002.l6JK2MX6019659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932227AbXGSUaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     coredump masking: ELF-FDPIC: remove an unused argument
has been removed from the -mm tree.  Its filename was
     coredump-masking-elf-fdpic-remove-an-unused-argument.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 4 insertions(+), 4 deletions(-)

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

origin.patch
