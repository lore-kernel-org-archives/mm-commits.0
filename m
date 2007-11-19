From: akpm@linux-foundation.org
Subject: - i386-and-x86_64-randomize-brk.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:16:24 -0800
Message-ID: <200711192316.lAJNGOU5001769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37000 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbXKSXRh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:17:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, arjan@infradead.org, jakub@redhat.com, mingo@elte.hu, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     i386 and x86_64: randomize brk()
has been removed from the -mm tree.  Its filename was
     i386-and-x86_64-randomize-brk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 and x86_64: randomize brk()
From: Jiri Kosina <jkosina@suse.cz>

Randomize the location of the heap (brk) for i386 and x86_64.  The range is
randomized in the range starting at current brk location up to 0x02000000
offset for both architectures.  This, together with
pie-executable-randomization.patch and
pie-executable-randomization-fix.patch, should make the address space
randomization on i386 and x86_64 complete.

Arjan says:

This is known to break older versions of some emacs variants, whose dumper
code assumed that the last variable declared in the program is equal to the
start of the dynamically allocated memory region.

(The dumper is the code where emacs effectively dumps core at the end of it's
compilation stage; this coredump is then loaded as the main program during
normal use)

iirc this was 5 years or so; we found this way back when I was at RH and we
first did the security stuff there (including this brk randomization).  It
wasn't all variants of emacs, and it got fixed as a result (I vaguely remember
that emacs already had code to deal with it for other archs/oses, just
ifdeffed wrongly).

It's a rare and wrong assumption as a general thing, just on x86 it mostly
happened to be true (but to be honest, it'll break too if gcc does
something fancy or if the linker does a non-standard order).  Still its
something we should at least document.

Note 2: afaik it only broke the emacs *build*.  I'm not 100% sure about that
(it IS 5 years ago) though.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/process_32.c |    7 +++++++
 arch/x86/kernel/process_64.c |    7 +++++++
 fs/binfmt_elf.c              |    6 ++++++
 include/asm-x86/elf.h        |    3 +++
 4 files changed, 23 insertions(+)

diff -puN arch/x86/kernel/process_32.c~i386-and-x86_64-randomize-brk arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~i386-and-x86_64-randomize-brk
+++ a/arch/x86/kernel/process_32.c
@@ -971,3 +971,10 @@ unsigned long arch_align_stack(unsigned 
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+unsigned long arch_randomize_brk(struct mm_struct *mm)
+{
+	unsigned long range_end = mm->brk + 0x02000000;
+	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+}
+
diff -puN arch/x86/kernel/process_64.c~i386-and-x86_64-randomize-brk arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~i386-and-x86_64-randomize-brk
+++ a/arch/x86/kernel/process_64.c
@@ -903,3 +903,10 @@ unsigned long arch_align_stack(unsigned 
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+unsigned long arch_randomize_brk(struct mm_struct *mm)
+{
+	unsigned long range_end = mm->brk + 0x02000000;
+	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+}
+
diff -puN fs/binfmt_elf.c~i386-and-x86_64-randomize-brk fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~i386-and-x86_64-randomize-brk
+++ a/fs/binfmt_elf.c
@@ -1021,6 +1021,12 @@ static int load_elf_binary(struct linux_
 	current->mm->end_data = end_data;
 	current->mm->start_stack = bprm->p;
 
+#ifdef ARCH_HAS_RANDOMIZE_BRK
+	if (current->flags & PF_RANDOMIZE)
+		current->mm->brk = current->mm->start_brk =
+			arch_randomize_brk(current->mm);
+#endif
+
 	if (current->personality & MMAP_PAGE_ZERO) {
 		/* Why this, you ask???  Well SVr4 maps page 0 as read-only,
 		   and some applications "depend" upon this behavior.
diff -puN include/asm-x86/elf.h~i386-and-x86_64-randomize-brk include/asm-x86/elf.h
--- a/include/asm-x86/elf.h~i386-and-x86_64-randomize-brk
+++ a/include/asm-x86/elf.h
@@ -285,6 +285,9 @@ struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 				       int executable_stack);
 
+#define ARCH_HAS_RANDOMIZE_BRK
+extern unsigned long arch_randomize_brk(struct mm_struct *mm);
+
 #endif /* __KERNEL__ */
 
 #endif
_

Patches currently in -mm which might be from jkosina@suse.cz are

git-hid.patch
make-wistron-btns-recognize-special-keys-on-medion-wim2160-notebooks.patch
fujitsu-application-panel-driver.patch
fujitsu-application-panel-driver-space-savings.patch
elantech-touchpad-driver.patch
elantech-touchpad-driver-fix.patch
usbserial-fix-inconsistent-lock-state.patch
git-ipwireless_cs.patch
git-x86.patch
rtc-convert-mutex-to-bitfield.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
