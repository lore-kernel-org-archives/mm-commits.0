From: akpm@linux-foundation.org
Subject: [patch 14/15] mm: kmemleak: scan .data.ro_after_init
Date: Thu, 10 Nov 2016 10:46:44 -0800
Message-ID: <5824c094.AO+uY4jJRfdD+g/6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49424 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755791AbcKJSqq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2016 13:46:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jakub.kicinski@netronome.com, arnd@arndb.de, catalin.marinas@arm.com, heiko.carstens@de.ibm.com, johannes@sipsolutions.net, schwidefsky@de.ibm.com, xiyou.wangcong@gmail.com

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: mm: kmemleak: scan .data.ro_after_init

Limit the number of kmemleak false positives by including
.data.ro_after_init in memory scanning.  To achieve this we need to add
symbols for start and end of the section to the linker scripts.

The problem was been uncovered by commit 56989f6d8568 ("genetlink: mark
families as __ro_after_init").

Link: http://lkml.kernel.org/r/1478274173-15218-1-git-send-email-jakub.kicinski@netronome.com
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/vmlinux.lds.S    |    2 ++
 include/asm-generic/sections.h    |    3 +++
 include/asm-generic/vmlinux.lds.h |    5 ++++-
 mm/kmemleak.c                     |    1 +
 4 files changed, 10 insertions(+), 1 deletion(-)

diff -puN arch/s390/kernel/vmlinux.lds.S~mm-kmemleak-scan-dataro_after_init arch/s390/kernel/vmlinux.lds.S
--- a/arch/s390/kernel/vmlinux.lds.S~mm-kmemleak-scan-dataro_after_init
+++ a/arch/s390/kernel/vmlinux.lds.S
@@ -62,9 +62,11 @@ SECTIONS
 
 	. = ALIGN(PAGE_SIZE);
 	__start_ro_after_init = .;
+	__start_data_ro_after_init = .;
 	.data..ro_after_init : {
 		 *(.data..ro_after_init)
 	}
+	__end_data_ro_after_init = .;
 	EXCEPTION_TABLE(16)
 	. = ALIGN(PAGE_SIZE);
 	__end_ro_after_init = .;
diff -puN include/asm-generic/sections.h~mm-kmemleak-scan-dataro_after_init include/asm-generic/sections.h
--- a/include/asm-generic/sections.h~mm-kmemleak-scan-dataro_after_init
+++ a/include/asm-generic/sections.h
@@ -14,6 +14,8 @@
  * [_sdata, _edata]: contains .data.* sections, may also contain .rodata.*
  *                   and/or .init.* sections.
  * [__start_rodata, __end_rodata]: contains .rodata.* sections
+ * [__start_data_ro_after_init, __end_data_ro_after_init]:
+ *		     contains data.ro_after_init section
  * [__init_begin, __init_end]: contains .init.* sections, but .init.text.*
  *                   may be out of this range on some architectures.
  * [_sinittext, _einittext]: contains .init.text.* sections
@@ -31,6 +33,7 @@ extern char _data[], _sdata[], _edata[];
 extern char __bss_start[], __bss_stop[];
 extern char __init_begin[], __init_end[];
 extern char _sinittext[], _einittext[];
+extern char __start_data_ro_after_init[], __end_data_ro_after_init[];
 extern char _end[];
 extern char __per_cpu_load[], __per_cpu_start[], __per_cpu_end[];
 extern char __kprobes_text_start[], __kprobes_text_end[];
diff -puN include/asm-generic/vmlinux.lds.h~mm-kmemleak-scan-dataro_after_init include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~mm-kmemleak-scan-dataro_after_init
+++ a/include/asm-generic/vmlinux.lds.h
@@ -259,7 +259,10 @@
  * own by defining an empty RO_AFTER_INIT_DATA.
  */
 #ifndef RO_AFTER_INIT_DATA
-#define RO_AFTER_INIT_DATA *(.data..ro_after_init)
+#define RO_AFTER_INIT_DATA						\
+	__start_data_ro_after_init = .;					\
+	*(.data..ro_after_init)						\
+	__end_data_ro_after_init = .;
 #endif
 
 /*
diff -puN mm/kmemleak.c~mm-kmemleak-scan-dataro_after_init mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-scan-dataro_after_init
+++ a/mm/kmemleak.c
@@ -1414,6 +1414,7 @@ static void kmemleak_scan(void)
 	/* data/bss scanning */
 	scan_large_block(_sdata, _edata);
 	scan_large_block(__bss_start, __bss_stop);
+	scan_large_block(__start_data_ro_after_init, __end_data_ro_after_init);
 
 #ifdef CONFIG_SMP
 	/* per-cpu sections scanning */
_
