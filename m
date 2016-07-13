From: akpm@linux-foundation.org
Subject: + binfmt_elf-fix-calculations-for-bss-padding.patch added to -mm
 tree
Date: Wed, 13 Jul 2016 15:12:57 -0700
Message-ID: <5786bce9.aENlqHKxjUwEDG18%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbcGMWM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 18:12:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, aarcange@redhat.com, aryabinin@virtuozzo.com, gang.chen.5i5j@gmail.com, hecmargi@upv.es, iripoll@upv.es, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mhocko@suse.com, oleg@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elf: fix calculations for bss padding
has been added to the -mm tree.  Its filename is
     binfmt_elf-fix-calculations-for-bss-padding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/binfmt_elf-fix-calculations-for-bss-padding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_elf-fix-calculations-for-bss-padding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: binfmt_elf: fix calculations for bss padding

A double-bug exists in the bss calculation code, where an overflow can
happen in the "last_bss - elf_bss" calculation, but vm_brk internally
aligns the argument, underflowing it, wrapping back around safe.  We
shouldn't depend on these bugs staying in sync, so this cleans up the bss
padding handling to avoid the overflow.

This moves the bss padzero() before the last_bss > elf_bss case, since the
zero-filling of the ELF_PAGE should have nothing to do with the
relationship of last_bss and elf_bss: any trailing portion should be
zeroed, and a zero size is already handled by padzero().

Then it handles the math on elf_bss vs last_bss correctly.  These need to
both be ELF_PAGE aligned to get the comparison correct, since that's the
expected granularity of the mappings.  Since elf_bss already had
alignment-based padding happen in padzero(), the "start" of the new
vm_brk() should be moved forward as done in the original code.  However,
since the "end" of the vm_brk() area will already become PAGE_ALIGNed in
vm_brk() then last_bss should get aligned here to avoid hiding it as a
side-effect.

Additionally makes a cosmetic change to the initial last_bss calculation
so it's easier to read in comparison to the load_addr calculation above it
(i.e.  the only difference is p_filesz vs p_memsz).

Link: http://lkml.kernel.org/r/1468014494-25291-2-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: Ismael Ripoll Ripoll <iripoll@upv.es>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-fix-calculations-for-bss-padding fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-fix-calculations-for-bss-padding
+++ a/fs/binfmt_elf.c
@@ -605,28 +605,30 @@ static unsigned long load_elf_interp(str
 			 * Do the same thing for the memory mapping - between
 			 * elf_bss and last_bss is the bss section.
 			 */
-			k = load_addr + eppnt->p_memsz + eppnt->p_vaddr;
+			k = load_addr + eppnt->p_vaddr + eppnt->p_memsz;
 			if (k > last_bss)
 				last_bss = k;
 		}
 	}
 
+	/*
+	 * Now fill out the bss section: first pad the last page from
+	 * the file up to the page boundary, and zero it from elf_bss
+	 * up to the end of the page.
+	 */
+	if (padzero(elf_bss)) {
+		error = -EFAULT;
+		goto out;
+	}
+	/*
+	 * Next, align both the file and mem bss up to the page size,
+	 * since this is where elf_bss was just zeroed up to, and where
+	 * last_bss will end after the vm_brk() below.
+	 */
+	elf_bss = ELF_PAGEALIGN(elf_bss);
+	last_bss = ELF_PAGEALIGN(last_bss);
+	/* Finally, if there is still more bss to allocate, do it. */
 	if (last_bss > elf_bss) {
-		/*
-		 * Now fill out the bss section.  First pad the last page up
-		 * to the page boundary, and then perform a mmap to make sure
-		 * that there are zero-mapped pages up to and including the
-		 * last bss page.
-		 */
-		if (padzero(elf_bss)) {
-			error = -EFAULT;
-			goto out;
-		}
-
-		/* What we have mapped so far */
-		elf_bss = ELF_PAGESTART(elf_bss + ELF_MIN_ALIGN - 1);
