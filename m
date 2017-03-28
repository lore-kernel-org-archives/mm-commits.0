From: akpm@linux-foundation.org
Subject: + mm-fix-section-name-for-dataro_after_init.patch added to -mm
 tree
Date: Tue, 28 Mar 2017 13:55:36 -0700
Message-ID: <58dacdc8.LjF5xZ3L8SQf4tvQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35590 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752605AbdC1Uzi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 16:55:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ewk@edkovsky.org, heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix section name for .data..ro_after_init
has been added to the -mm tree.  Its filename is
     mm-fix-section-name-for-dataro_after_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-section-name-for-dataro_after_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-section-name-for-dataro_after_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm: fix section name for .data..ro_after_init

A section name for .data..ro_after_init was added by both:

    commit d07a980c1b8d ("s390: add proper __ro_after_init support")

and

    commit d7c19b066dcf ("mm: kmemleak: scan .data.ro_after_init")

The latter adds incorrect wrapping around the existing s390 section, and
came later.  I'd prefer the s390 naming, so this moves the s390-specific
name up to the asm-generic/sections.h and renames the section as used by
kmemleak (and in the future, kernel/extable.c).

Link: http://lkml.kernel.org/r/20170327192213.GA129375@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>	[s390 parts]
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Eddie Kovsky <ewk@edkovsky.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/sections.h  |    1 -
 arch/s390/kernel/vmlinux.lds.S    |    2 --
 include/asm-generic/sections.h    |    6 +++---
 include/asm-generic/vmlinux.lds.h |    4 ++--
 mm/kmemleak.c                     |    2 +-
 5 files changed, 6 insertions(+), 9 deletions(-)

diff -puN arch/s390/include/asm/sections.h~mm-fix-section-name-for-dataro_after_init arch/s390/include/asm/sections.h
--- a/arch/s390/include/asm/sections.h~mm-fix-section-name-for-dataro_after_init
+++ a/arch/s390/include/asm/sections.h
@@ -4,6 +4,5 @@
 #include <asm-generic/sections.h>
 
 extern char _eshared[], _ehead[];
-extern char __start_ro_after_init[], __end_ro_after_init[];
 
 #endif
diff -puN arch/s390/kernel/vmlinux.lds.S~mm-fix-section-name-for-dataro_after_init arch/s390/kernel/vmlinux.lds.S
--- a/arch/s390/kernel/vmlinux.lds.S~mm-fix-section-name-for-dataro_after_init
+++ a/arch/s390/kernel/vmlinux.lds.S
@@ -63,11 +63,9 @@ SECTIONS
 
 	. = ALIGN(PAGE_SIZE);
 	__start_ro_after_init = .;
-	__start_data_ro_after_init = .;
 	.data..ro_after_init : {
 		 *(.data..ro_after_init)
 	}
-	__end_data_ro_after_init = .;
 	EXCEPTION_TABLE(16)
 	. = ALIGN(PAGE_SIZE);
 	__end_ro_after_init = .;
diff -puN include/asm-generic/sections.h~mm-fix-section-name-for-dataro_after_init include/asm-generic/sections.h
--- a/include/asm-generic/sections.h~mm-fix-section-name-for-dataro_after_init
+++ a/include/asm-generic/sections.h
@@ -14,8 +14,8 @@
  * [_sdata, _edata]: contains .data.* sections, may also contain .rodata.*
  *                   and/or .init.* sections.
  * [__start_rodata, __end_rodata]: contains .rodata.* sections
- * [__start_data_ro_after_init, __end_data_ro_after_init]:
- *		     contains data.ro_after_init section
+ * [__start_ro_after_init, __end_ro_after_init]:
+ *		     contains .data..ro_after_init section
  * [__init_begin, __init_end]: contains .init.* sections, but .init.text.*
  *                   may be out of this range on some architectures.
  * [_sinittext, _einittext]: contains .init.text.* sections
@@ -33,7 +33,7 @@ extern char _data[], _sdata[], _edata[];
 extern char __bss_start[], __bss_stop[];
 extern char __init_begin[], __init_end[];
 extern char _sinittext[], _einittext[];
-extern char __start_data_ro_after_init[], __end_data_ro_after_init[];
+extern char __start_ro_after_init[], __end_ro_after_init[];
 extern char _end[];
 extern char __per_cpu_load[], __per_cpu_start[], __per_cpu_end[];
 extern char __kprobes_text_start[], __kprobes_text_end[];
diff -puN include/asm-generic/vmlinux.lds.h~mm-fix-section-name-for-dataro_after_init include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~mm-fix-section-name-for-dataro_after_init
+++ a/include/asm-generic/vmlinux.lds.h
@@ -260,9 +260,9 @@
  */
 #ifndef RO_AFTER_INIT_DATA
 #define RO_AFTER_INIT_DATA						\
-	__start_data_ro_after_init = .;					\
+	__start_ro_after_init = .;					\
 	*(.data..ro_after_init)						\
-	__end_data_ro_after_init = .;
+	__end_ro_after_init = .;
 #endif
 
 /*
diff -puN mm/kmemleak.c~mm-fix-section-name-for-dataro_after_init mm/kmemleak.c
--- a/mm/kmemleak.c~mm-fix-section-name-for-dataro_after_init
+++ a/mm/kmemleak.c
@@ -1416,7 +1416,7 @@ static void kmemleak_scan(void)
 	/* data/bss scanning */
 	scan_large_block(_sdata, _edata);
 	scan_large_block(__bss_start, __bss_stop);
-	scan_large_block(__start_data_ro_after_init, __end_data_ro_after_init);
+	scan_large_block(__start_ro_after_init, __end_ro_after_init);
 
 #ifdef CONFIG_SMP
 	/* per-cpu sections scanning */
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-fix-section-name-for-dataro_after_init.patch
mm-remove-rodata_test_data-export-add-pr_fmt.patch

