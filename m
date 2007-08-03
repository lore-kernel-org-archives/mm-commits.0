From: akpm@linux-foundation.org
Subject: + deprecate-aout-elf-interpreters.patch added to -mm tree
Date: Fri, 03 Aug 2007 10:48:13 -0700
Message-ID: <200708031748.l73HmYVN020283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45066 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764150AbXHCRsq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 13:48:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@novell.com, ak@suse.de


The patch titled
     Deprecate a.out ELF interpreters
has been added to the -mm tree.  Its filename is
     deprecate-aout-elf-interpreters.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    9 +++++++++
 fs/binfmt_elf.c                            |    7 +++++++
 2 files changed, 16 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~deprecate-aout-elf-interpreters Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~deprecate-aout-elf-interpreters
+++ a/Documentation/feature-removal-schedule.txt
@@ -273,3 +273,12 @@ Why:	All mthca hardware also supports MS
 Who:	Roland Dreier <rolandd@cisco.com>
 
 ---------------------------
+
+What:  a.out interpreter support for ELF executables
+When:  2.6.25
+Files: fs/binfmt_elf.c
+Why:   Using a.out interpreters for ELF executables was a feature for
+       transition from a.out to ELF. But now it is unlikely to be still
+       needed anymore and removing it would simplify the hairy ELF
+       loader code.
+Who:   Andi Kleen <ak@suse.de>
diff -puN fs/binfmt_elf.c~deprecate-aout-elf-interpreters fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~deprecate-aout-elf-interpreters
+++ a/fs/binfmt_elf.c
@@ -730,6 +730,7 @@ static int load_elf_binary(struct linux_
 
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
+		static int warn;
 		interpreter_type = INTERPRETER_ELF | INTERPRETER_AOUT;
 
 		/* Now figure out which format our binary is */
@@ -741,6 +742,12 @@ static int load_elf_binary(struct linux_
 		if (memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
 			interpreter_type &= ~INTERPRETER_ELF;
 
+		if (interpreter_type == INTERPRETER_AOUT && warn < 10) {
+			printk(KERN_WARNING "a.out ELF interpreter %s is "
+	"deprecated and will not be supported anymore\n", elf_interpreter);
+			warn++;
+		}
+
 		retval = -ELIBBAD;
 		if (!interpreter_type)
 			goto out_free_dentry;
_

Patches currently in -mm which might be from ak@novell.com are

deprecate-aout-elf-interpreters.patch
deprecate-aout-elf-interpreters-fix.patch
