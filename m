From: akpm@linux-foundation.org
Subject: + i386-and-x86_64-randomize-brk.patch added to -mm tree
Date: Thu, 13 Sep 2007 22:05:23 -0700
Message-ID: <200709140505.l8E55N6m022355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45251 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbXINFG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 01:06:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, ak@suse.de, arjan@infradead.org, mingo@elte.hu


The patch titled
     i386 and x86_64: randomize brk()
has been added to the -mm tree.  Its filename is
     i386-and-x86_64-randomize-brk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 and x86_64: randomize brk()
From: Jiri Kosina <jkosina@suse.cz>

Randomize the location of the heap (brk) for i386 and x86_64.  The range is
randomized in the range starting at current brk location up to 0x02000000
offset for both architectures.  This, together with
pie-executable-randomization.patch and
pie-executable-randomization-fix.patch, should make the address space
randomization on i386 and x86_64 complete.

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
@@ -906,3 +906,17 @@ unsigned long arch_align_stack(unsigned 
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
adbhid-produce-all-capslock-key-events.patch
keyboard-capsshift-lock.patch
console-keyboard-events-and-accessibility.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
git-ipwireless_cs.patch
pie-executable-randomization.patch
pie-executable-randomization-fix.patch
pie-executable-randomization-fix-2.patch
pie-executable-randomization-fix-3.patch
i386-and-x86_64-randomize-brk.patch
add-config_vt_unicode.patch
get-rid-of-input-bit-duplicate-defines.patch
