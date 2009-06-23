From: akpm@linux-foundation.org
Subject: + lockdep-use-new-arch_is_kernel_data.patch added to -mm tree
Date: Tue, 23 Jun 2009 15:40:37 -0700
Message-ID: <200906232240.n5NMebjc008336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752913AbZFWWmZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 18:42:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, a.p.zijlstra@chello.nl, arnd@arndb.de, mingo@elte.hu, rgetz@blackfin.uclinux.org, sam@ravnborg.org


The patch titled
     lockdep: use new arch_is_kernel_data()
has been added to the -mm tree.  Its filename is
     lockdep-use-new-arch_is_kernel_data.patch

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
Subject: lockdep: use new arch_is_kernel_data()
From: Mike Frysinger <vapier@gentoo.org>

This allows lockdep to locate symbols that are in arch-specific data
sections (such as data in Blackfin on-chip SRAM regions).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/lockdep.c~lockdep-use-new-arch_is_kernel_data kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-use-new-arch_is_kernel_data
+++ a/kernel/lockdep.c
@@ -636,6 +636,9 @@ static int static_obj(void *obj)
 	if ((addr >= start) && (addr < end))
 		return 1;
 
+	if (arch_is_kernel_data(addr))
+		return 1;
+
 #ifdef CONFIG_SMP
 	/*
 	 * percpu var?
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

