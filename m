From: akpm@linux-foundation.org
Subject: [merged] kallsyms-use-new-arch_is_kernel_text.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:53:45 -0700
Message-ID: <200909231953.n8NJrjEH031799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352AbZIWTzX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:55:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, a.p.zijlstra@chello.nl, arnd@arndb.de, mingo@elte.hu, rgetz@blackfin.uclinux.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kallsyms: use new arch_is_kernel_text()
has been removed from the -mm tree.  Its filename was
     kallsyms-use-new-arch_is_kernel_text.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kallsyms: use new arch_is_kernel_text()
From: Mike Frysinger <vapier@gentoo.org>

This allows kallsyms to locate symbols that are in arch-specific text
sections (such as text in Blackfin on-chip SRAM regions).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/kallsyms.c~kallsyms-use-new-arch_is_kernel_text kernel/kallsyms.c
--- a/kernel/kallsyms.c~kallsyms-use-new-arch_is_kernel_text
+++ a/kernel/kallsyms.c
@@ -59,7 +59,8 @@ static inline int is_kernel_inittext(uns
 
 static inline int is_kernel_text(unsigned long addr)
 {
-	if (addr >= (unsigned long)_stext && addr <= (unsigned long)_etext)
+	if ((addr >= (unsigned long)_stext && addr <= (unsigned long)_etext) ||
+	    arch_is_kernel_text(addr))
 		return 1;
 	return in_gate_area_no_task(addr);
 }
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch
linux-futexh-place-kernel-types-behind-__kernel__.patch

