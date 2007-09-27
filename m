From: akpm@linux-foundation.org
Subject: - i386-and-x86_64-randomize-brk.patch removed from -mm tree
Date: Thu, 27 Sep 2007 15:08:01 -0700
Message-ID: <200709272208.l8RM81Vl030280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42006 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757722AbXI0WJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 18:09:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, ak@suse.de, arjan@infradead.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     i386 and x86_64: randomize brk()
has been removed from the -mm tree.  Its filename was
     i386-and-x86_64-randomize-brk.patch

This patch was dropped because an updated version will be merged

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
happened to be true (but to be honest, it'll break too if gcc does something
fancy or if the linker does a non-standard order).  Still its something we
should at least document.

Note 2: afaik it only broke the emacs *build*.  I'm not 100% sure about that
(it IS 5 years ago) though.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/process.c   |   14 ++++++++++++++
 arch/x86_64/kernel/process.c |   14 ++++++++++++++
 fs/binfmt_elf.c              |    7 +++++++
 3 files changed, 35 insertions(+)

diff -puN arch/i386/kernel/process.c~i386-and-x86_64-randomize-brk arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~i386-and-x86_64-randomize-brk
+++ a/arch/i386/kernel/process.c
@@ -973,3 +973,17 @@ unsigned long arch_align_stack(unsigned 
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+unsigned long arch_randomize_brk(unsigned long brk)
+{
+	unsigned long new_brk;
+	unsigned long range_end;
+
+	range_end = brk + 0x02000000;
+	new_brk = randomize_range(brk, range_end, 0);
+	if (new_brk)
+		return new_brk;
+	else
+		return brk;
+}
+
diff -puN arch/x86_64/kernel/process.c~i386-and-x86_64-randomize-brk arch/x86_64/kernel/process.c
--- a/arch/x86_64/kernel/process.c~i386-and-x86_64-randomize-brk
+++ a/arch/x86_64/kernel/process.c
@@ -905,3 +905,17 @@ unsigned long arch_align_stack(unsigned 
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+unsigned long arch_randomize_brk(unsigned long brk)
+{
+	unsigned long new_brk;
+	unsigned long range_end;
+
+	range_end = brk + 0x02000000;
+	new_brk = randomize_range(brk, range_end, 0);
+	if (new_brk)
+		return new_brk;
+	else
+		return brk;
+}
+
diff -puN fs/binfmt_elf.c~i386-and-x86_64-randomize-brk fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~i386-and-x86_64-randomize-brk
+++ a/fs/binfmt_elf.c
@@ -47,6 +47,9 @@ static int load_elf_binary(struct linux_
 static int load_elf_library(struct file *);
 static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);
 
+/* overriden by architectures supporting brk randomization */
+unsigned long __weak arch_randomize_brk(unsigned long brk) { return brk; }
+
 /*
  * If we don't support core dumping, then supply a NULL so we
  * don't even try.
@@ -1081,6 +1084,10 @@ static int load_elf_binary(struct linux_
 	current->mm->end_data = end_data;
 	current->mm->start_stack = bprm->p;
 
+	if (current->flags & PF_RANDOMIZE)
+		current->mm->brk = current->mm->start_brk =
+			arch_randomize_brk(current->mm->brk);
+
 	if (current->personality & MMAP_PAGE_ZERO) {
 		/* Why this, you ask???  Well SVr4 maps page 0 as read-only,
 		   and some applications "depend" upon this behavior.
_

Patches currently in -mm which might be from jkosina@suse.cz are

git-hid.patch
drivers-hid-hid-debugc-add-kern_debug-prefix-fix-typo-constify-fix.patch
adbhid-produce-all-capslock-key-events.patch
keyboard-capsshift-lock.patch
console-keyboard-events-and-accessibility.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers-fix.patch
make-wistron-btns-recognize-special-keys-on-medion-wim2160-notebooks.patch
git-ipwireless_cs.patch
pie-executable-randomization.patch
pie-executable-randomization-fix.patch
pie-executable-randomization-fix-2.patch
pie-executable-randomization-fix-3.patch
i386-and-x86_64-randomize-brk.patch
i386-and-x86_64-randomize-brk-fix.patch
add-config_vt_unicode.patch
get-rid-of-input-bit-duplicate-defines.patch
