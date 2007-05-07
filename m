From: akpm@linux-foundation.org
Subject: + lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch added to -mm tree
Date: Mon, 07 May 2007 16:18:40 -0700
Message-ID: <200705072318.l47NIe9M008039@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967196AbXEGXSq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 19:18:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest: use standard bootloader format, fix badly-sized initrds
has been added to the -mm tree.  Its filename is
     lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: use standard bootloader format, fix badly-sized initrds
From: Rusty Russell <rusty@rustcorp.com.au>

Eric Biederman complained that lguest doesn't use the Linux standard boot
header format.  He's got a good point.

This also simplifies the code: the example launcher writes the header
directly, rather than lguest writing into it during boot.

While we're touching this code, we also fix the problem of initrd's which
don't have a page-aligned size.

This anticipates changing the paravirt-finding routines to use a "platform
type" field from %esi, rather than a "probe all until one succeeds"
routine, but doesn't actually change that code.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/lguest.c |   48 ++++++++++++++++++++------------
 1 files changed, 31 insertions(+), 17 deletions(-)

diff -puN Documentation/lguest/lguest.c~lguest-use-standard-bootloader-format-fix-badly-sized-doc Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c~lguest-use-standard-bootloader-format-fix-badly-sized-doc
+++ a/Documentation/lguest/lguest.c
@@ -30,10 +30,12 @@
 #include <termios.h>
 #include <getopt.h>
 #include <zlib.h>
+typedef unsigned long long u64;
 typedef uint32_t u32;
 typedef uint16_t u16;
 typedef uint8_t u8;
 #include "../../include/linux/lguest_launcher.h"
+#include "../../include/asm-i386/e820.h"
 
 #define PAGE_PRESENT 0x7 	/* Present, RW, Execute */
 #define NET_PEERNUM 1
@@ -241,31 +243,33 @@ static unsigned long load_kernel(int fd,
 	return load_bzimage(fd, page_offset);
 }
 
+static inline unsigned long page_align(unsigned long addr)
+{
+	return ((addr + getpagesize()-1) & ~(getpagesize()-1));
+}
+
 /* initrd gets loaded at top of memory: return length. */
 static unsigned long load_initrd(const char *name, unsigned long mem)
 {
 	int ifd;
 	struct stat st;
+	unsigned long len;
 	void *iaddr;
 
 	ifd = open_or_die(name, O_RDONLY);
 	if (fstat(ifd, &st) < 0)
 		err(1, "fstat() on initrd '%s'", name);
 
-	iaddr = mmap((void *)mem - st.st_size, st.st_size,
+	len = page_align(st.st_size);
+	iaddr = mmap((void *)mem - len, st.st_size,
 		     PROT_READ|PROT_EXEC|PROT_WRITE,
 		     MAP_FIXED|MAP_PRIVATE, ifd, 0);
-	if (iaddr != (void *)mem - st.st_size)
+	if (iaddr != (void *)mem - len)
 		err(1, "Mmaping initrd '%s' returned %p not %p",
-		    name, iaddr, (void *)mem - st.st_size);
+		    name, iaddr, (void *)mem - len);
 	close(ifd);
 	verbose("mapped initrd %s size=%lu @ %p\n", name, st.st_size, iaddr);
-	return st.st_size;
-}
-
-static inline unsigned long page_align(unsigned long addr)
-{
-	return ((addr + getpagesize()-1) & ~(getpagesize()-1));
+	return len;
 }
 
 static unsigned long setup_pagetables(unsigned long mem,
@@ -933,10 +937,10 @@ static void usage(void)
 
 int main(int argc, char *argv[])
 {
-	unsigned long mem, pgdir, start, page_offset;
+	unsigned long mem, pgdir, start, page_offset, initrd_size = 0;
 	int c, lguest_fd, waker_fd;
 	struct device_list device_list;
-	struct lguest_boot_info *boot = (void *)0;
+	void *boot = (void *)0;
 	const char *initrd_name = NULL;
 
 	device_list.max_infd = -1;
@@ -984,15 +988,25 @@ int main(int argc, char *argv[])
 	map_device_descriptors(&device_list, mem);
 
 	/* Map the initrd image if requested */
-	if (initrd_name)
-		boot->initrd_size = load_initrd(initrd_name, mem);
+	if (initrd_name) {
+		initrd_size = load_initrd(initrd_name, mem);
+		*(unsigned long *)(boot+0x218) = mem - initrd_size;
+		*(unsigned long *)(boot+0x21c) = initrd_size;
+		*(unsigned char *)(boot+0x210) = 0xFF;
+	}
 
 	/* Set up the initial linar pagetables. */
-	pgdir = setup_pagetables(mem, boot->initrd_size, page_offset);
+	pgdir = setup_pagetables(mem, initrd_size, page_offset);
 
-	/* Give the guest the boot information it needs. */
-	concat(boot->cmdline, argv+optind+2);
-	boot->max_pfn = mem/getpagesize();
+	/* E820 memory map: ours is a simple, single region. */
+	*(char*)(boot+E820NR) = 1;
+	*((struct e820entry *)(boot+E820MAP))
+		= ((struct e820entry) { 0, mem, E820_RAM });
+	/* Command line pointer and command line (at 4096) */
+	*(void **)(boot + 0x228) = boot + 4096;
+	concat(boot + 4096, argv+optind+2);
+	/* Paravirt type: 1 == lguest */
+	*(int *)(boot + 0x23c) = 1;
 
 	lguest_fd = tell_kernel(pgdir, start, page_offset);
 	waker_fd = setup_waker(&device_list);
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
array_size-check-for-type.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
module-use-krealloc.patch
get_futex_key-get_key_refs-and-drop_key_refs.patch
futex-restartable-futex_wait.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda-lguest-2621-mm1-update.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch
lguest-the-guest-code-dont-use-paravirt_probe-its-dying.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch
lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch
lguest-the-host-code-fix-obscure-but-nasty-cow-bug.patch
lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
compiler-introduce-__used-and-__maybe_unused.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
