From: akpm@linux-foundation.org
Subject: - fix-elf_core_dump-when-writing-arch-specific-notes-spu-coredumps.patch removed from -mm tree
Date: Sun, 08 Jul 2007 01:11:07 -0700
Message-ID: <200707080811.l688B7af014744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41521 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026AbXGHIL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jul 2007 04:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@ellerman.id.au, arnd@arndb.de, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Fix elf_core_dump() when writing arch specific notes (spu coredumps)
has been removed from the -mm tree.  Its filename was
     fix-elf_core_dump-when-writing-arch-specific-notes-spu-coredumps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix elf_core_dump() when writing arch specific notes (spu coredumps)
From: Michael Ellerman <michael@ellerman.id.au>

elf_core_dump() supports dumping arch specific ELF notes, via the #define
ELF_CORE_WRITE_EXTRA_NOTES.  Currently the only user of this is the powerpc
spu coredump code.

There is a bug in the handling of foffset WRT the arch notes, which causes
us to erroneously increment foffset by the size of the arch notes, leaving
a block of zeroes in the file, and causing all subsequent data in the file
to be at <supposed position> + <arch note size>.  eg:

  LOAD  0x050000 0x00100000 0x00000000 0x20000 0x20000 R E 0x10000

Tells us we should have a chunk of data at 0x50000.  The truth is the data
is at 0x90dbc = 0x50000 + 0x40dbc (the size of the arch notes).

This bug prevents gdb from reading the core file correctly.

The simplest fix is to simply remember the size of the arch notes, and add
it to foffset after we've written the arch notes.  The only drawback is
that if the arch code doesn't write as many bytes as it said it would, we
end up with a broken core dump again.  For now I think that's a reasonable
requirement.

Tested on a Cell blade, gdb no longer complains about the core file being
bogus.

While I'm here I should point out that the spu coredump code does not work
if we're dumping to a pipe - we'll have to wait for 23 to fix that.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~fix-elf_core_dump-when-writing-arch-specific-notes-spu-coredumps fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fix-elf_core_dump-when-writing-arch-specific-notes-spu-coredumps
+++ a/fs/binfmt_elf.c
@@ -1499,6 +1499,9 @@ static int elf_core_dump(long signr, str
 #endif
 	int thread_status_size = 0;
 	elf_addr_t *auxv;
+#ifdef ELF_CORE_WRITE_EXTRA_NOTES
+	int extra_notes_size;
+#endif
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1628,7 +1631,8 @@ static int elf_core_dump(long signr, str
 		sz += thread_status_size;
 
 #ifdef ELF_CORE_WRITE_EXTRA_NOTES
-		sz += ELF_CORE_EXTRA_NOTES_SIZE;
+		extra_notes_size = ELF_CORE_EXTRA_NOTES_SIZE;
+		sz += extra_notes_size;
 #endif
 
 		fill_elf_note_phdr(&phdr, sz, offset);
@@ -1674,6 +1678,7 @@ static int elf_core_dump(long signr, str
 
 #ifdef ELF_CORE_WRITE_EXTRA_NOTES
 	ELF_CORE_WRITE_EXTRA_NOTES;
+	foffset += extra_notes_size;
 #endif
 
 	/* write out the thread status notes section */
_

Patches currently in -mm which might be from michael@ellerman.id.au are

origin.patch
git-powerpc.patch
jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch
jprobes-make-jprobes-a-little-safer-for-users-fix.patch
