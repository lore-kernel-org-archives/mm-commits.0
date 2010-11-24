From: akpm@linux-foundation.org
Subject: + bitops-rename-generic-little-endian-bitops-functions.patch added to -mm tree
Date: Wed, 24 Nov 2010 14:39:29 -0800
Message-ID: <201011242239.oAOMdTru008114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755485Ab0KXWkq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 17:40:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, andy.grover@oracle.com, arnd@arndb.de, avi@redhat.com, benh@kernel.crashing.org, davem@davemloft.net, geert@linux-m68k.org, gerg@uclinux.org, hans-christian.egtvedt@atmel.com, mtosatti@redhat.com, paulus@samba.org, schwab@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     bitops: rename generic little-endian bitops functions
has been added to the -mm tree.  Its filename is
     bitops-rename-generic-little-endian-bitops-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitops: rename generic little-endian bitops functions
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for providing little-endian bitops for all architectures,
This removes generic_ prefix from little-endian bitops function names in
asm-generic/bitops/le.h.

s/generic_find_next_le_bit/find_next_le_bit/
s/generic_find_next_zero_le_bit/find_next_zero_le_bit/
s/generic_find_first_zero_le_bit/find_first_zero_le_bit/
s/generic___test_and_set_le_bit/__test_and_set_le_bit/
s/generic___test_and_clear_le_bit/__test_and_clear_le_bit/
s/generic_test_le_bit/test_le_bit/
s/generic___set_le_bit/__set_le_bit/
s/generic___clear_le_bit/__clear_le_bit/
s/generic_test_and_set_le_bit/test_and_set_le_bit/
s/generic_test_and_clear_le_bit/test_and_clear_le_bit/

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Andy Grover <andy.grover@oracle.com>
Cc: rds-devel@oss.oracle.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/avr32_ksyms.c              |    4 +-
 arch/avr32/lib/findbit.S                     |    4 +-
 arch/m68k/include/asm/bitops_mm.h            |    8 ++---
 arch/m68k/include/asm/bitops_no.h            |    2 -
 arch/powerpc/include/asm/bitops.h            |   11 +++----
 include/asm-generic/bitops/ext2-non-atomic.h |   12 +++----
 include/asm-generic/bitops/le.h              |   26 ++++++++---------
 include/asm-generic/bitops/minix-le.h        |   10 +++---
 lib/find_next_bit.c                          |    9 ++---
 net/rds/cong.c                               |    6 +--
 virt/kvm/kvm_main.c                          |    2 -
 11 files changed, 47 insertions(+), 47 deletions(-)

diff -puN arch/avr32/kernel/avr32_ksyms.c~bitops-rename-generic-little-endian-bitops-functions arch/avr32/kernel/avr32_ksyms.c
--- a/arch/avr32/kernel/avr32_ksyms.c~bitops-rename-generic-little-endian-bitops-functions
+++ a/arch/avr32/kernel/avr32_ksyms.c
@@ -58,8 +58,8 @@ EXPORT_SYMBOL(find_first_zero_bit);
 EXPORT_SYMBOL(find_next_zero_bit);
 EXPORT_SYMBOL(find_first_bit);
 EXPORT_SYMBOL(find_next_bit);
-EXPORT_SYMBOL(generic_find_next_le_bit);
-EXPORT_SYMBOL(generic_find_next_zero_le_bit);
+EXPORT_SYMBOL(find_next_le_bit);
+EXPORT_SYMBOL(find_next_zero_le_bit);
 
 /* I/O primitives (lib/io-*.S) */
 EXPORT_SYMBOL(__raw_readsb);
diff -puN arch/avr32/lib/findbit.S~bitops-rename-generic-little-endian-bitops-functions arch/avr32/lib/findbit.S
--- a/arch/avr32/lib/findbit.S~bitops-rename-generic-little-endian-bitops-functions
+++ a/arch/avr32/lib/findbit.S
@@ -123,7 +123,7 @@ ENTRY(find_next_bit)
 	brgt	1b
 	retal	r11
 
-ENTRY(generic_find_next_le_bit)
+ENTRY(find_next_le_bit)
 	lsr	r8, r10, 5
 	sub	r9, r11, r10
 	retle	r11
@@ -153,7 +153,7 @@ ENTRY(generic_find_next_le_bit)
 	brgt	1b
 	retal	r11
 
-ENTRY(generic_find_next_zero_le_bit)
+ENTRY(find_next_zero_le_bit)
 	lsr	r8, r10, 5
 	sub	r9, r11, r10
 	retle	r11
diff -puN arch/m68k/include/asm/bitops_mm.h~bitops-rename-generic-little-endian-bitops-functions arch/m68k/include/asm/bitops_mm.h
--- a/arch/m68k/include/asm/bitops_mm.h~bitops-rename-generic-little-endian-bitops-functions
+++ a/arch/m68k/include/asm/bitops_mm.h
@@ -366,9 +366,9 @@ static inline int minix_test_bit(int nr,
 #define ext2_clear_bit(nr, addr)		__test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
 #define ext2_clear_bit_atomic(lock, nr, addr)	test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
 #define ext2_find_next_zero_bit(addr, size, offset) \
-	generic_find_next_zero_le_bit((unsigned long *)addr, size, offset)
+	find_next_zero_le_bit((unsigned long *)addr, size, offset)
 #define ext2_find_next_bit(addr, size, offset) \
-	generic_find_next_le_bit((unsigned long *)addr, size, offset)
+	find_next_le_bit((unsigned long *)addr, size, offset)
 
 static inline int ext2_test_bit(int nr, const void *vaddr)
 {
@@ -398,7 +398,7 @@ static inline int ext2_find_first_zero_b
 	return (p - addr) * 32 + res;
 }
 
-static inline unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
+static inline unsigned long find_next_zero_le_bit(const unsigned long *addr,
 		unsigned long size, unsigned long offset)
 {
 	const unsigned long *p = addr + (offset >> 5);
@@ -440,7 +440,7 @@ static inline int ext2_find_first_bit(co
 	return (p - addr) * 32 + res;
 }
 
-static inline unsigned long generic_find_next_le_bit(const unsigned long *addr,
+static inline unsigned long find_next_le_bit(const unsigned long *addr,
 		unsigned long size, unsigned long offset)
 {
 	const unsigned long *p = addr + (offset >> 5);
diff -puN arch/m68k/include/asm/bitops_no.h~bitops-rename-generic-little-endian-bitops-functions arch/m68k/include/asm/bitops_no.h
--- a/arch/m68k/include/asm/bitops_no.h~bitops-rename-generic-little-endian-bitops-functions
+++ a/arch/m68k/include/asm/bitops_no.h
@@ -325,7 +325,7 @@ found_middle:
 }
 
 #define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
+	find_next_le_bit((unsigned long *)(addr), (size), (off))
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
diff -puN arch/powerpc/include/asm/bitops.h~bitops-rename-generic-little-endian-bitops-functions arch/powerpc/include/asm/bitops.h
--- a/arch/powerpc/include/asm/bitops.h~bitops-rename-generic-little-endian-bitops-functions
+++ a/arch/powerpc/include/asm/bitops.h
@@ -294,11 +294,12 @@ static __inline__ int test_le_bit(unsign
 #define __test_and_clear_le_bit(nr, addr) \
 	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define find_first_zero_le_bit(addr, size) generic_find_next_zero_le_bit((addr), (size), 0)
-unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
+#define find_first_zero_le_bit(addr, size) \
+	find_next_zero_le_bit((addr), (size), 0)
+unsigned long find_next_zero_le_bit(const unsigned long *addr,
 				    unsigned long size, unsigned long offset);
 
-unsigned long generic_find_next_le_bit(const unsigned long *addr,
+unsigned long find_next_le_bit(const unsigned long *addr,
 				    unsigned long size, unsigned long offset);
 /* Bitmap functions for the ext2 filesystem */
 
@@ -317,10 +318,10 @@ unsigned long generic_find_next_le_bit(c
 #define ext2_find_first_zero_bit(addr, size) \
 	find_first_zero_le_bit((unsigned long*)addr, size)
 #define ext2_find_next_zero_bit(addr, size, off) \
-	generic_find_next_zero_le_bit((unsigned long*)addr, size, off)
+	find_next_zero_le_bit((unsigned long *)addr, size, off)
 
 #define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)addr, size, off)
+	find_next_le_bit((unsigned long *)addr, size, off)
 /* Bitmap functions for the minix filesystem.  */
 
 #define minix_test_and_set_bit(nr,addr) \
diff -puN include/asm-generic/bitops/ext2-non-atomic.h~bitops-rename-generic-little-endian-bitops-functions include/asm-generic/bitops/ext2-non-atomic.h
--- a/include/asm-generic/bitops/ext2-non-atomic.h~bitops-rename-generic-little-endian-bitops-functions
+++ a/include/asm-generic/bitops/ext2-non-atomic.h
@@ -4,17 +4,17 @@
 #include <asm-generic/bitops/le.h>
 
 #define ext2_set_bit(nr,addr)	\
-	generic___test_and_set_le_bit((nr),(unsigned long *)(addr))
+	__test_and_set_le_bit((nr), (unsigned long *)(addr))
 #define ext2_clear_bit(nr,addr)	\
-	generic___test_and_clear_le_bit((nr),(unsigned long *)(addr))
+	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
 
 #define ext2_test_bit(nr,addr)	\
-	generic_test_le_bit((nr),(unsigned long *)(addr))
+	test_le_bit((nr), (unsigned long *)(addr))
 #define ext2_find_first_zero_bit(addr, size) \
-	generic_find_first_zero_le_bit((unsigned long *)(addr), (size))
+	find_first_zero_le_bit((unsigned long *)(addr), (size))
 #define ext2_find_next_zero_bit(addr, size, off) \
-	generic_find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
+	find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
 #define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
+	find_next_le_bit((unsigned long *)(addr), (size), (off))
 
 #endif /* _ASM_GENERIC_BITOPS_EXT2_NON_ATOMIC_H_ */
diff -puN include/asm-generic/bitops/le.h~bitops-rename-generic-little-endian-bitops-functions include/asm-generic/bitops/le.h
--- a/include/asm-generic/bitops/le.h~bitops-rename-generic-little-endian-bitops-functions
+++ a/include/asm-generic/bitops/le.h
@@ -8,42 +8,42 @@
 
 #define BITOP_LE_SWIZZLE	0
 
-#define generic_find_next_zero_le_bit(addr, size, offset) \
+#define find_next_zero_le_bit(addr, size, offset) \
 	find_next_zero_bit(addr, size, offset)
-#define generic_find_next_le_bit(addr, size, offset) \
+#define find_next_le_bit(addr, size, offset) \
 	find_next_bit(addr, size, offset)
 
 #elif defined(__BIG_ENDIAN)
 
 #define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
-extern unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
+extern unsigned long find_next_zero_le_bit(const unsigned long *addr,
 		unsigned long size, unsigned long offset);
-extern unsigned long generic_find_next_le_bit(const unsigned long *addr,
+extern unsigned long find_next_le_bit(const unsigned long *addr,
 		unsigned long size, unsigned long offset);
 
 #else
 #error "Please fix <asm/byteorder.h>"
 #endif
 
-#define generic_test_le_bit(nr, addr) \
+#define test_le_bit(nr, addr) \
 	test_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic___set_le_bit(nr, addr) \
+#define __set_le_bit(nr, addr) \
 	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic___clear_le_bit(nr, addr) \
+#define __clear_le_bit(nr, addr) \
 	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define generic_test_and_set_le_bit(nr, addr) \
+#define test_and_set_le_bit(nr, addr) \
 	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic_test_and_clear_le_bit(nr, addr) \
+#define test_and_clear_le_bit(nr, addr) \
 	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define generic___test_and_set_le_bit(nr, addr) \
+#define __test_and_set_le_bit(nr, addr) \
 	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic___test_and_clear_le_bit(nr, addr) \
+#define __test_and_clear_le_bit(nr, addr) \
 	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define generic_find_first_zero_le_bit(addr, size) \
-        generic_find_next_zero_le_bit((addr), (size), 0)
+#define find_first_zero_le_bit(addr, size) \
+	find_next_zero_le_bit((addr), (size), 0)
 
 #endif /* _ASM_GENERIC_BITOPS_LE_H_ */
diff -puN include/asm-generic/bitops/minix-le.h~bitops-rename-generic-little-endian-bitops-functions include/asm-generic/bitops/minix-le.h
--- a/include/asm-generic/bitops/minix-le.h~bitops-rename-generic-little-endian-bitops-functions
+++ a/include/asm-generic/bitops/minix-le.h
@@ -4,14 +4,14 @@
 #include <asm-generic/bitops/le.h>
 
 #define minix_test_and_set_bit(nr,addr)	\
-	generic___test_and_set_le_bit((nr),(unsigned long *)(addr))
+	__test_and_set_le_bit((nr), (unsigned long *)(addr))
 #define minix_set_bit(nr,addr)		\
-	generic___set_le_bit((nr),(unsigned long *)(addr))
+	__set_le_bit((nr), (unsigned long *)(addr))
 #define minix_test_and_clear_bit(nr,addr) \
-	generic___test_and_clear_le_bit((nr),(unsigned long *)(addr))
+	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
 #define minix_test_bit(nr,addr)		\
-	generic_test_le_bit((nr),(unsigned long *)(addr))
+	test_le_bit((nr), (unsigned long *)(addr))
 #define minix_find_first_zero_bit(addr,size) \
-	generic_find_first_zero_le_bit((unsigned long *)(addr),(size))
+	find_first_zero_le_bit((unsigned long *)(addr), (size))
 
 #endif /* _ASM_GENERIC_BITOPS_MINIX_LE_H_ */
diff -puN lib/find_next_bit.c~bitops-rename-generic-little-endian-bitops-functions lib/find_next_bit.c
--- a/lib/find_next_bit.c~bitops-rename-generic-little-endian-bitops-functions
+++ a/lib/find_next_bit.c
@@ -185,7 +185,7 @@ static inline unsigned long ext2_swab(co
 #endif
 }
 
-unsigned long generic_find_next_zero_le_bit(const unsigned long *addr, unsigned
+unsigned long find_next_zero_le_bit(const unsigned long *addr, unsigned
 		long size, unsigned long offset)
 {
 	const unsigned long *p = addr + BITOP_WORD(offset);
@@ -226,10 +226,9 @@ found_middle:
 found_middle_swap:
 	return result + ffz(ext2_swab(tmp));
 }
+EXPORT_SYMBOL(find_next_zero_le_bit);
 
-EXPORT_SYMBOL(generic_find_next_zero_le_bit);
-
-unsigned long generic_find_next_le_bit(const unsigned long *addr, unsigned
+unsigned long find_next_le_bit(const unsigned long *addr, unsigned
 		long size, unsigned long offset)
 {
 	const unsigned long *p = addr + BITOP_WORD(offset);
@@ -271,5 +270,5 @@ found_middle:
 found_middle_swap:
 	return result + __ffs(ext2_swab(tmp));
 }
-EXPORT_SYMBOL(generic_find_next_le_bit);
+EXPORT_SYMBOL(find_next_le_bit);
 #endif /* __BIG_ENDIAN */
diff -puN net/rds/cong.c~bitops-rename-generic-little-endian-bitops-functions net/rds/cong.c
--- a/net/rds/cong.c~bitops-rename-generic-little-endian-bitops-functions
+++ a/net/rds/cong.c
@@ -285,7 +285,7 @@ void rds_cong_set_bit(struct rds_cong_ma
 	i = be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
 	off = be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
 
-	generic___set_le_bit(off, (void *)map->m_page_addrs[i]);
+	__set_le_bit(off, (void *)map->m_page_addrs[i]);
 }
 
 void rds_cong_clear_bit(struct rds_cong_map *map, __be16 port)
@@ -299,7 +299,7 @@ void rds_cong_clear_bit(struct rds_cong_
 	i = be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
 	off = be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
 
-	generic___clear_le_bit(off, (void *)map->m_page_addrs[i]);
+	__clear_le_bit(off, (void *)map->m_page_addrs[i]);
 }
 
 static int rds_cong_test_bit(struct rds_cong_map *map, __be16 port)
@@ -310,7 +310,7 @@ static int rds_cong_test_bit(struct rds_
 	i = be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
 	off = be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
 
-	return generic_test_le_bit(off, (void *)map->m_page_addrs[i]);
+	return test_le_bit(off, (void *)map->m_page_addrs[i]);
 }
 
 void rds_cong_add_socket(struct rds_sock *rs)
diff -puN virt/kvm/kvm_main.c~bitops-rename-generic-little-endian-bitops-functions virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~bitops-rename-generic-little-endian-bitops-functions
+++ a/virt/kvm/kvm_main.c
@@ -1388,7 +1388,7 @@ void mark_page_dirty_in_slot(struct kvm 
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 
-		generic___set_le_bit(rel_gfn, memslot->dirty_bitmap);
+		__set_le_bit(rel_gfn, memslot->dirty_bitmap);
 	}
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
bitops-rename-generic-little-endian-bitops-functions.patch
s390-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops.patch
m68knommu-introduce-little-endian-bitops.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
rds-stop-including-asm-generic-bitops-leh.patch
kvm-stop-including-asm-generic-bitops-leh.patch
asm-generic-use-little-endian-bitops.patch
ext3-use-little-endian-bitops.patch
ext4-use-little-endian-bitops.patch
ocfs2-use-little-endian-bitops.patch
nilfs2-use-little-endian-bitops.patch
reiserfs-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
ufs-use-little-endian-bitops.patch
md-use-little-endian-bit-operations.patch
dm-use-little-endian-bit-operations.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch

