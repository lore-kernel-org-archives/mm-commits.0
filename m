From: akpm@linux-foundation.org
Subject: + frv-remove-some-dead-code.patch added to -mm tree
Date: Thu, 05 Jul 2007 14:42:49 -0700
Message-ID: <200707052142.l65LgnrX021329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35879 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760837AbXGEVni (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 17:43:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, rpjday@mindspring.com


The patch titled
     FRV: Remove some dead code
has been added to the -mm tree.  Its filename is
     frv-remove-some-dead-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: FRV: Remove some dead code
From: David Howells <dhowells@redhat.com>

Remove some dead chunks of code that are bounded by preprocessor conditionals
controlled by apparently no-longer available config options.

These are:

	CONFIG_BLK_DEV_BLKMEM
	CONFIG_CHR_DEV_FLASH
	CONFIG_BLK_DEV_FLASH
	CONFIG_CONSOLE

[Found by Robert P. J. Day <rpjday@mindspring.com>]

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/setup.c |   16 ----------------
 1 files changed, 16 deletions(-)

diff -puN arch/frv/kernel/setup.c~frv-remove-some-dead-code arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c~frv-remove-some-dead-code
+++ a/arch/frv/kernel/setup.c
@@ -60,10 +60,6 @@ static void __init setup_linux_memory(vo
 static void __init setup_uclinux_memory(void);
 #endif
 
-#ifdef CONFIG_CONSOLE
-extern struct consw *conswitchp;
-#endif
-
 #ifdef CONFIG_MB93090_MB00
 static char __initdata mb93090_banner[] = "FJ/RH FR-V Linux";
 static char __initdata mb93090_version[] = UTS_RELEASE;
@@ -795,13 +791,6 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 
-#if defined(CONFIG_CHR_DEV_FLASH) || defined(CONFIG_BLK_DEV_FLASH)
-	/* we need to initialize the Flashrom device here since we might
-	 * do things with flash early on in the boot
-	 */
-	flash_probe();
-#endif
-
 	/* deal with the command line - RedBoot may have passed one to the kernel */
 	memcpy(command_line, boot_command_line, sizeof(command_line));
 	*cmdline_p = &command_line[0];
@@ -837,11 +826,6 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 
-#ifdef CONFIG_BLK_DEV_BLKMEM
-	ROOT_DEV = MKDEV(BLKMEM_MAJOR,0);
-#endif
-	/*rom_length = (unsigned long)&_flashend - (unsigned long)&_romvec;*/
-
 #ifdef CONFIG_MMU
 	setup_linux_memory();
 #else
_

Patches currently in -mm which might be from dhowells@redhat.com are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
document-page_mkwrite-locking.patch
frv-connect-up-new-syscalls.patch
frv-be-self-consistent-and-use-config_gdb_console-everywhere.patch
frv-remove-some-dead-code.patch
nommu-stub-expand_stack-for-nommu-case.patch
afs-implement-file-locking.patch
afs-drop-explicit-extern.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
mutex-subsystem-synchro-test-module.patch
