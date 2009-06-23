From: akpm@linux-foundation.org
Subject: + kallsyms-use-new-arch_is_kernel_text.patch added to -mm tree
Date: Tue, 23 Jun 2009 15:40:35 -0700
Message-ID: <200906232240.n5NMeZk7008333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757501AbZFWWmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 18:42:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, a.p.zijlstra@chello.nl, arnd@arndb.de, mingo@elte.hu, rgetz@blackfin.uclinux.org, sam@ravnborg.org


The patch titled
     kallsyms: use new arch_is_kernel_text()
has been added to the -mm tree.  Its filename is
     kallsyms-use-new-arch_is_kernel_text.patch

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
rmap-fixup-page_referenced-for-nommu-systems.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch

