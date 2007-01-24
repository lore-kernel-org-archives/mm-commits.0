From: akpm@osdl.org
Subject: + extend-the-set-of-__attribute__-shortcut-macros.patch added to -mm tree
Date: Tue, 23 Jan 2007 23:57:13 -0800
Message-ID: <200701240757.l0O7vDpf012140@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56931 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933197AbXAXIAc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 03:00:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, ralf@linux-mips.org


The patch titled
     extend the set of "__attribute__" shortcut macros
has been added to the -mm tree.  Its filename is
     extend-the-set-of-__attribute__-shortcut-macros.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: extend the set of "__attribute__" shortcut macros
From: "Robert P. J. Day" <rpjday@mindspring.com>

Extend the set of "__attribute__" shortcut macros, and remove identical
(and now superfluous) definitions from a couple of source files.

based on a page at robert love's blog:

	http://rlove.org/log/2005102601

extend the set of shortcut macros defined in compiler-gcc.h with the
following:

#define __packed                       __attribute__((packed))
#define __weak                         __attribute__((weak))
#define __naked                        __attribute__((naked))
#define __noreturn                     __attribute__((noreturn))
#define __pure                         __attribute__((pure))
#define __aligned(x)                   __attribute__((aligned(x)))
#define __printf(a,b)                  __attribute__((format(printf,a,b)))

Once these are in place, it's up to subsystem maintainers to decide if they
want to take advantage of them.  there is already a strong precedent for
using shortcuts like this in the source tree.

The ones that might give people pause are "__aligned" and "__printf", but
shortcuts for both of those are already in use, and in some ways very
confusingly.  note the two very different definitions for a macro named
"ALIGNED":

  drivers/net/sgiseeq.c:#define ALIGNED(x) ((((unsigned long)(x)) + 0xf) & ~(0xf))
  drivers/scsi/ultrastor.c:#define ALIGNED(x) __attribute__((aligned(x)))

also:

  include/acpi/platform/acgcc.h:
    #define ACPI_PRINTF_LIKE(c) __attribute__ ((__format__ (__printf__, c, c+1)))

Given the precedent, then, it seems logical to at least standardize on a
consistent set of these macros.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/mips/mm/cache.c         |    2 --
 fs/hfs/hfs.h                 |    2 --
 fs/hfsplus/hfsplus_raw.h     |    2 --
 include/linux/compiler-gcc.h |    7 +++++++
 4 files changed, 7 insertions(+), 6 deletions(-)

diff -puN arch/mips/mm/cache.c~extend-the-set-of-__attribute__-shortcut-macros arch/mips/mm/cache.c
--- a/arch/mips/mm/cache.c~extend-the-set-of-__attribute__-shortcut-macros
+++ a/arch/mips/mm/cache.c
@@ -107,8 +107,6 @@ void __update_cache(struct vm_area_struc
 	}
 }
 
-#define __weak __attribute__((weak))
-
 static char cache_panic[] __initdata = "Yeee, unsupported cache architecture.";
 
 void __init cpu_cache_init(void)
diff -puN fs/hfs/hfs.h~extend-the-set-of-__attribute__-shortcut-macros fs/hfs/hfs.h
--- a/fs/hfs/hfs.h~extend-the-set-of-__attribute__-shortcut-macros
+++ a/fs/hfs/hfs.h
@@ -83,8 +83,6 @@
 
 /*======== HFS structures as they appear on the disk ========*/
 
-#define __packed __attribute__ ((packed))
-
 /* Pascal-style string of up to 31 characters */
 struct hfs_name {
 	u8 len;
diff -puN fs/hfsplus/hfsplus_raw.h~extend-the-set-of-__attribute__-shortcut-macros fs/hfsplus/hfsplus_raw.h
--- a/fs/hfsplus/hfsplus_raw.h~extend-the-set-of-__attribute__-shortcut-macros
+++ a/fs/hfsplus/hfsplus_raw.h
@@ -15,8 +15,6 @@
 
 #include <linux/types.h>
 
-#define __packed __attribute__ ((packed))
-
 /* Some constants */
 #define HFSPLUS_SECTOR_SIZE        512
 #define HFSPLUS_SECTOR_SHIFT         9
diff -puN include/linux/compiler-gcc.h~extend-the-set-of-__attribute__-shortcut-macros include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~extend-the-set-of-__attribute__-shortcut-macros
+++ a/include/linux/compiler-gcc.h
@@ -27,6 +27,13 @@
 #define __inline__	__inline__	__attribute__((always_inline))
 #define __inline	__inline	__attribute__((always_inline))
 #define __deprecated			__attribute__((deprecated))
+#define __packed			__attribute__((packed))
+#define __weak				__attribute__((weak))
+#define __naked				__attribute__((naked))
+#define __noreturn			__attribute__((noreturn))
+#define __pure				__attribute__((pure))
+#define __aligned(x)			__attribute__((aligned(x)))
+#define __printf(a,b)			__attribute__((format(printf,a,b)))
 #define  noinline			__attribute__((noinline))
 #define __attribute_pure__		__attribute__((pure))
 #define __attribute_const__		__attribute__((__const__))
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
