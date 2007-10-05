From: akpm@linux-foundation.org
Subject: - binfmt_flat-minimum-support-for-the-blackfin-relocations.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:58:36 -0700
Message-ID: <200710051958.l95JwaBk022557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763528AbXJEUBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bernd.schmidt@analog.com, bryan.wu@analog.com, davidm@snapgear.com, gerg@snapgear.com, miles.bader@necel.com, mm-commits@vger.kernel.org


The patch titled
     binfmt_flat: minimum support for the Blackfin relocations
has been removed from the -mm tree.  Its filename was
     binfmt_flat-minimum-support-for-the-blackfin-relocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: binfmt_flat: minimum support for the Blackfin relocations
From: Bernd Schmidt <bernd.schmidt@analog.com>

Add minimum support for the Blackfin relocations, since we don't have
enough space in each reloc.  The idea is to store a value with one
relocation so that subsequent ones can access it.

Actually, this patch is required for Blackfin.  Currently if BINFMT_FLAT is
enabled, git-tree kernel will fail to compile.

Signed-off-by: Bernd Schmidt <bernd.schmidt@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: David McCullough <davidm@snapgear.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Miles Bader <miles.bader@necel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/binfmt_flat.c~binfmt_flat-minimum-support-for-the-blackfin-relocations fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~binfmt_flat-minimum-support-for-the-blackfin-relocations
+++ a/fs/binfmt_flat.c
@@ -744,6 +744,7 @@ static int load_flat_file(struct linux_b
 	 * __start to address 4 so that is okay).
 	 */
 	if (rev > OLD_FLAT_VERSION) {
+		unsigned long persistent = 0;
 		for (i=0; i < relocs; i++) {
 			unsigned long addr, relval;
 
@@ -751,6 +752,8 @@ static int load_flat_file(struct linux_b
 			   relocated (of course, the address has to be
 			   relocated first).  */
 			relval = ntohl(reloc[i]);
+			if (flat_set_persistent (relval, &persistent))
+				continue;
 			addr = flat_get_relocate_addr(relval);
 			rp = (unsigned long *) calc_reloc(addr, libinfo, id, 1);
 			if (rp == (unsigned long *)RELOC_FAILED) {
@@ -759,7 +762,7 @@ static int load_flat_file(struct linux_b
 			}
 
 			/* Get the pointer's value.  */
-			addr = flat_get_addr_from_rp(rp, relval, flags);
+			addr = flat_get_addr_from_rp(rp, relval, flags, &persistent);
 			if (addr != 0) {
 				/*
 				 * Do the relocation.  PIC relocs in the data section are
diff -puN include/asm-h8300/flat.h~binfmt_flat-minimum-support-for-the-blackfin-relocations include/asm-h8300/flat.h
--- a/include/asm-h8300/flat.h~binfmt_flat-minimum-support-for-the-blackfin-relocations
+++ a/include/asm-h8300/flat.h
@@ -9,6 +9,7 @@
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		1
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
+#define	flat_set_persistent(relval, p)		0
 
 /*
  * on the H8 a couple of the relocations have an instruction in the
@@ -18,7 +19,7 @@
  */
 
 #define	flat_get_relocate_addr(rel)		(rel)
-#define flat_get_addr_from_rp(rp, relval, flags) \
+#define flat_get_addr_from_rp(rp, relval, flags, persistent) \
         (get_unaligned(rp) & ((flags & FLAT_FLAG_GOTPIC) ? 0xffffffff: 0x00ffffff))
 #define flat_put_addr_at_rp(rp, addr, rel) \
 	put_unaligned (((*(char *)(rp)) << 24) | ((addr) & 0x00ffffff), rp)
diff -puN include/asm-m32r/flat.h~binfmt_flat-minimum-support-for-the-blackfin-relocations include/asm-m32r/flat.h
--- a/include/asm-m32r/flat.h~binfmt_flat-minimum-support-for-the-blackfin-relocations
+++ a/include/asm-m32r/flat.h
@@ -15,9 +15,10 @@
 #define	flat_stack_align(sp)		(*sp += (*sp & 3 ? (4 - (*sp & 3)): 0))
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
+#define	flat_set_persistent(relval, p)		0
 #define	flat_reloc_valid(reloc, size)		\
 	(((reloc) - textlen_for_m32r_lo16_data) <= (size))
-#define flat_get_addr_from_rp(rp, relval, flags) \
+#define flat_get_addr_from_rp(rp, relval, flags, persistent) \
 	m32r_flat_get_addr_from_rp(rp, relval, (text_len) )
 
 #define flat_put_addr_at_rp(rp, addr, relval) \
diff -puN include/asm-m68knommu/flat.h~binfmt_flat-minimum-support-for-the-blackfin-relocations include/asm-m68knommu/flat.h
--- a/include/asm-m68knommu/flat.h~binfmt_flat-minimum-support-for-the-blackfin-relocations
+++ a/include/asm-m68knommu/flat.h
@@ -9,8 +9,9 @@
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
-#define	flat_get_addr_from_rp(rp, relval, flags)	get_unaligned(rp)
+#define	flat_get_addr_from_rp(rp, relval, flags, p)	get_unaligned(rp)
 #define	flat_put_addr_at_rp(rp, val, relval)	put_unaligned(val,rp)
 #define	flat_get_relocate_addr(rel)		(rel)
+#define	flat_set_persistent(relval, p)		0
 
 #endif /* __M68KNOMMU_FLAT_H__ */
diff -puN include/asm-sh/flat.h~binfmt_flat-minimum-support-for-the-blackfin-relocations include/asm-sh/flat.h
--- a/include/asm-sh/flat.h~binfmt_flat-minimum-support-for-the-blackfin-relocations
+++ a/include/asm-sh/flat.h
@@ -16,8 +16,9 @@
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
-#define	flat_get_addr_from_rp(rp, relval, flags)	get_unaligned(rp)
+#define	flat_get_addr_from_rp(rp, relval, flags, p)	get_unaligned(rp)
 #define	flat_put_addr_at_rp(rp, val, relval)	put_unaligned(val,rp)
 #define	flat_get_relocate_addr(rel)		(rel)
+#define	flat_set_persistent(relval, p)		0
 
 #endif /* __ASM_SH_FLAT_H */
diff -puN include/asm-v850/flat.h~binfmt_flat-minimum-support-for-the-blackfin-relocations include/asm-v850/flat.h
--- a/include/asm-v850/flat.h~binfmt_flat-minimum-support-for-the-blackfin-relocations
+++ a/include/asm-v850/flat.h
@@ -25,6 +25,7 @@
 #define	flat_stack_align(sp)		/* nothing needed */
 #define	flat_argvp_envp_on_stack()	0
 #define	flat_old_ram_flag(flags)	(flags)
+#define	flat_set_persistent(relval, p)	0
 
 /* We store the type of relocation in the top 4 bits of the `relval.' */
 
@@ -46,7 +47,8 @@ flat_get_relocate_addr (unsigned long re
    For the v850, RP should always be half-word aligned.  */
 static inline unsigned long flat_get_addr_from_rp (unsigned long *rp,
 						   unsigned long relval,
-						   unsigned long flags)
+						   unsigned long flags,
+						   unsigned long *persistent)
 {
 	short *srp = (short *)rp;
 
_

Patches currently in -mm which might be from bernd.schmidt@analog.com are

origin.patch
