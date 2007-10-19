From: akpm@linux-foundation.org
Subject: - extended-crashkernel-command-line-update.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:30:51 -0700
Message-ID: <200710190430.l9J4Uq9H015170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44547 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966574AbXJSEa4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:30:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, mm-commits@vger.kernel.org


The patch titled
     Extended crashkernel command line (update)
has been removed from the -mm tree.  Its filename was
     extended-crashkernel-command-line-update.patch

This patch was dropped because it was folded into extended-crashkernel-command-line.patch

------------------------------------------------------
Subject: Extended crashkernel command line (update)
From: Bernhard Walle <bwalle@suse.de>

This is the generic part of the patch. It adds a parse_crashkernel() function
in kernel/kexec.c that is called by the architecture specific code that
actually reserves the memory. That function takes the whole command line and
looks itself for "crashkernel=" in it.

If there are multiple occurrences, then the last one is taken.  The advantage
is that if you have a bootloader like lilo or elilo which allows you to append
a command line parameter but not to remove one (like in GRUB), then you can add
another crashkernel value for testing at the boot command line and this one
overwrites the command line in the configuration then.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    1 +
 kernel/kexec.c        |    7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/kexec.h~extended-crashkernel-command-line-update include/linux/kexec.h
--- a/include/linux/kexec.h~extended-crashkernel-command-line-update
+++ a/include/linux/kexec.h
@@ -186,6 +186,7 @@ extern note_buf_t *crash_notes;
 extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
 extern size_t vmcoreinfo_size;
 extern size_t vmcoreinfo_max_size;
+
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
 
diff -puN kernel/kexec.c~extended-crashkernel-command-line-update kernel/kexec.c
--- a/kernel/kexec.c~extended-crashkernel-command-line-update
+++ a/kernel/kexec.c
@@ -1162,9 +1162,9 @@ module_init(crash_notes_memory_init)
  * The function returns 0 on success and -EINVAL on failure.
  */
 static int __init parse_crashkernel_mem(char 			*cmdline,
-					unsigned long 		system_ram,
-					unsigned long long 	*crash_size,
-					unsigned long long 	*crash_base)
+					unsigned long long	system_ram,
+					unsigned long long	*crash_size,
+					unsigned long long	*crash_base)
 {
 	char *cur = cmdline;
 
@@ -1254,6 +1254,7 @@ int __init parse_crashkernel(char 		 *cm
 	char 	*p = cmdline, *ck_cmdline = NULL;
 	char	*first_colon, *first_space;
 
+	BUG_ON(!crash_size || !crash_base);
 	*crash_size = 0;
 	*crash_base = 0;
 
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
extended-crashkernel-command-line.patch
extended-crashkernel-command-line-update.patch
extended-crashkernel-command-line-comment-fix.patch
extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-i386-update.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-x86_64-update.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ia64-update.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-ppc64-update.patch
use-extended-crashkernel-command-line-on-sh.patch
use-extended-crashkernel-command-line-on-sh-update.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
