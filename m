From: akpm@linux-foundation.org
Subject: - lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch removed from -mm tree
Date: Wed, 09 May 2007 02:44:20 -0700
Message-ID: <200705090944.l499iKnJ020246@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043AbXEIJoh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:44:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: don't use paravirt_probe, it's dying
has been removed from the -mm tree.  Its filename was
     lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch

This patch was dropped because it was folded into lguest-the-documentation-example-launcher.patch

------------------------------------------------------
Subject: lguest: don't use paravirt_probe, it's dying
From: Rusty Russell <rusty@rustcorp.com.au>

paravirt_probe() and its infrastructure proved as popular as it was
pretty.  In anticipation of its imminent demise, this switches lguest to
use a magic string to identify a different entry point.

This is not the long-term solution: that will take a new bootloader rev
and will hopefully be done in the next few months.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/lguest.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff -puN Documentation/lguest/lguest.c~lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c~lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc
+++ a/Documentation/lguest/lguest.c
@@ -96,6 +96,19 @@ static void *map_zeroed_pages(unsigned l
 	return (void *)addr;
 }
 
+/* Find magic string marking entry point, return entry point. */
+static unsigned long entry_point(void *start, void *end,
+				 unsigned long page_offset)
+{
+	void *p;
+
+	for (p = start; p < end; p++)
+		if (memcmp(p, "GenuineLguest", strlen("GenuineLguest")) == 0)
+			return (long)p + strlen("GenuineLguest") + page_offset;
+
+	err(1, "Is this image a genuine lguest?");
+}
+
 /* Returns the entry point */
 static unsigned long map_elf(int elf_fd, const Elf32_Ehdr *ehdr,
 			     unsigned long *page_offset)
@@ -103,6 +116,7 @@ static unsigned long map_elf(int elf_fd,
 	void *addr;
 	Elf32_Phdr phdr[ehdr->e_phnum];
 	unsigned int i;
+	unsigned long start = -1UL, end = 0;
 
 	/* Sanity checks. */
 	if (ehdr->e_type != ET_EXEC
@@ -132,6 +146,11 @@ static unsigned long map_elf(int elf_fd,
 		else if (*page_offset != phdr[i].p_vaddr - phdr[i].p_paddr)
 			errx(1, "Page offset of section %i different", i);
 
+		if (phdr[i].p_paddr < start)
+			start = phdr[i].p_paddr;
+		if (phdr[i].p_paddr + phdr[i].p_filesz > end)
+			end = phdr[i].p_paddr + phdr[i].p_filesz;
+
 		/* We map everything private, writable. */
 		addr = mmap((void *)phdr[i].p_paddr,
 			    phdr[i].p_filesz,
@@ -143,8 +162,7 @@ static unsigned long map_elf(int elf_fd,
 			    i, addr, (void *)phdr[i].p_paddr);
 	}
 
-	/* Entry is physical address: convert to virtual */
-	return ehdr->e_entry + *page_offset;
+	return entry_point((void *)start, (void *)end, *page_offset);
 }
 
 /* This is amazingly reliable. */
@@ -175,8 +193,7 @@ static unsigned long unpack_bzimage(int 
 	verbose("Unpacked size %i addr %p\n", len, img);
 	*page_offset = intuit_page_offset(img, len);
 
-	/* Entry is physical address: convert to virtual */
-	return (unsigned long)img + *page_offset;
+	return entry_point(img, img + len, *page_offset);
 }
 
 static unsigned long load_bzimage(int fd, unsigned long *page_offset)
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
compiler-introduce-__used-and-__maybe_unused.patch
xfs-clean-up-shrinker-games.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch
lguest-two-net-bugfixes-doc.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
