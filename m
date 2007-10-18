From: akpm@linux-foundation.org
Subject: - deprecate-aout-elf-interpreters.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:09 -0700
Message-ID: <200710180655.l9I6t94j030583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756809AbXJRHUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@novell.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Deprecate a.out ELF interpreters
has been removed from the -mm tree.  Its filename was
     deprecate-aout-elf-interpreters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Deprecate a.out ELF interpreters
From: Andi Kleen <ak@novell.com>

The Linux ELF loader is quite complicated and messy code (that could
probably need a rewrite, but that's a different chapter).  One particular
messy part in it is the support for non ELF a.out ld.sos.  This was
originally added to make transition from a.out to ELF easier because an
a.out ELF ld.so could be still build using an older a.out toolkit.  But by
now that should be fully obsolete and removing it would clean up
binfmt_elf.c up a bit.

I propose to deprecate this support and remove for 2.6.25.

Drawback is that someone still runs their system with a.out ld.so
they would need to update the ld.so when updating to a new kernel.

This patch just adds an entry to the deprecation file and a printk
warning users.

[akpm@linux-foundation.org: better warning message]
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   11 +++++++++++
 fs/binfmt_elf.c                            |    8 ++++++++
 2 files changed, 19 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~deprecate-aout-elf-interpreters Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~deprecate-aout-elf-interpreters
+++ a/Documentation/feature-removal-schedule.txt
@@ -82,6 +82,17 @@ Who:	Dominik Brodowski <linux@brodo.de>
 
 ---------------------------
 
+What:  a.out interpreter support for ELF executables
+When:  2.6.25
+Files: fs/binfmt_elf.c
+Why:   Using a.out interpreters for ELF executables was a feature for
+       transition from a.out to ELF. But now it is unlikely to be still
+       needed anymore and removing it would simplify the hairy ELF
+       loader code.
+Who:   Andi Kleen <ak@suse.de>
+
+---------------------------
+
 What:	remove EXPORT_SYMBOL(kernel_thread)
 When:	August 2006
 Files:	arch/*/kernel/*_ksyms.c
diff -puN fs/binfmt_elf.c~deprecate-aout-elf-interpreters fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~deprecate-aout-elf-interpreters
+++ a/fs/binfmt_elf.c
@@ -730,6 +730,7 @@ static int load_elf_binary(struct linux_
 
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
+		static int warn;
 		interpreter_type = INTERPRETER_ELF | INTERPRETER_AOUT;
 
 		/* Now figure out which format our binary is */
@@ -741,6 +742,13 @@ static int load_elf_binary(struct linux_
 		if (memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
 			interpreter_type &= ~INTERPRETER_ELF;
 
+		if (interpreter_type == INTERPRETER_AOUT && warn < 10) {
+			printk(KERN_WARNING "a.out ELF interpreter %s is "
+				"deprecated and will not be supported "
+				"after Linux 2.6.25\n", elf_interpreter);
+			warn++;
+		}
+
 		retval = -ELIBBAD;
 		if (!interpreter_type)
 			goto out_free_dentry;
_

Patches currently in -mm which might be from ak@novell.com are

origin.patch
