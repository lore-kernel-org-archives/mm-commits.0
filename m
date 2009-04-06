From: akpm@linux-foundation.org
Subject: [merged] bin_elf_fdpic-check-the-return-value-of-clear_user.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:36:10 -0700
Message-ID: <200904061936.n36JaA1U012352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756832AbZDFTl2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:41:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, dhowells@redhat.com, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     bin_elf_fdpic: check the return value of clear_user
has been removed from the -mm tree.  Its filename was
     bin_elf_fdpic-check-the-return-value-of-clear_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bin_elf_fdpic: check the return value of clear_user
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~bin_elf_fdpic-check-the-return-value-of-clear_user fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~bin_elf_fdpic-check-the-return-value-of-clear_user
+++ a/fs/binfmt_elf_fdpic.c
@@ -972,9 +972,12 @@ static int elf_fdpic_map_file_constdisp_
 			params->elfhdr_addr = seg->addr;
 
 		/* clear any space allocated but not loaded */
-		if (phdr->p_filesz < phdr->p_memsz)
-			clear_user((void *) (seg->addr + phdr->p_filesz),
-				   phdr->p_memsz - phdr->p_filesz);
+		if (phdr->p_filesz < phdr->p_memsz) {
+			ret = clear_user((void *) (seg->addr + phdr->p_filesz),
+					 phdr->p_memsz - phdr->p_filesz);
+			if (ret)
+				return ret;
+		}
 
 		if (mm) {
 			if (phdr->p_flags & PF_X) {
@@ -1014,7 +1017,7 @@ static int elf_fdpic_map_file_by_direct_
 	struct elf32_fdpic_loadseg *seg;
 	struct elf32_phdr *phdr;
 	unsigned long load_addr, delta_vaddr;
-	int loop, dvset;
+	int loop, dvset, ret;
 
 	load_addr = params->load_addr;
 	delta_vaddr = 0;
@@ -1114,7 +1117,9 @@ static int elf_fdpic_map_file_by_direct_
 		 * PT_LOAD */
 		if (prot & PROT_WRITE && disp > 0) {
 			kdebug("clear[%d] ad=%lx sz=%lx", loop, maddr, disp);
-			clear_user((void __user *) maddr, disp);
+			ret = clear_user((void __user *) maddr, disp);
+			if (ret)
+				return ret;
 			maddr += disp;
 		}
 
@@ -1149,15 +1154,19 @@ static int elf_fdpic_map_file_by_direct_
 		if (prot & PROT_WRITE && excess1 > 0) {
 			kdebug("clear[%d] ad=%lx sz=%lx",
 			       loop, maddr + phdr->p_filesz, excess1);
-			clear_user((void __user *) maddr + phdr->p_filesz,
-				   excess1);
+			ret = clear_user((void __user *) maddr + phdr->p_filesz,
+					 excess1);
+			if (ret)
+				return ret;
 		}
 
 #else
 		if (excess > 0) {
 			kdebug("clear[%d] ad=%lx sz=%lx",
 			       loop, maddr + phdr->p_filesz, excess);
-			clear_user((void *) maddr + phdr->p_filesz, excess);
+			ret = clear_user((void *) maddr + phdr->p_filesz, excess);
+			if (ret)
+				return ret;
 		}
 #endif
 
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch
blackfin-serial-driver-irq-funcs-take-an-unsigned-long-for-flags.patch
blackfin-serial-driver-update-kgdb-uart-config-name.patch
blackfin-serial-driver-fix-building-when-debug-is-enabled-but-serial-console-is-disabled.patch
blackfin-serial-driver-depend-on-kgdb_serial_console-being-set-to-n.patch
blackfin-serial-driver-use-the-dlab-macro-to-hide-variant-differences.patch
blackfin-serial-driver-update-path-to-gpio-header.patch
blackfin-spi-driver-ensure-cache-coherency-before-doing-dma.patch
blackfin-spi-driver-remove-useless-asm-cplbinith.patch
blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-bytes-transferred.patch
blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level.patch
blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch
blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label.patch
blackfin-spi-driver-add-a-few-more-dma-debug-messages.patch
blackfin-spi-driver-do-not-check-for-spi-errors-if-dma-itself-did-not-flag-any.patch
blackfin-spi-driver-use-the-properl-bit_ctl_xxx-defines.patch
blackfin-spi-driver-spi-slave-select-code-cleanup.patch
blackfin-spi-driver-get-dma-working-for-spi-flashes.patch
blackfin-spi-driver-add-timeout-while-waiting-for-spif-in-dma-irq-handler.patch
blackfin-spi-driver-tweak-magic-spi-dma-sequence-to-get-it-working-on-bf54x.patch
blackfin-spi-driver-use-bfin_spi_-prefix-on-all-functions.patch
blackfin-spi-driver-fix-null-pointer-crash.patch

