From: akpm@linux-foundation.org
Subject: [merged] lockdep-use-new-arch_is_kernel_data.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:53:48 -0700
Message-ID: <200909231953.n8NJrmHD031892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358AbZIWTzX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:55:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, a.p.zijlstra@chello.nl, arnd@arndb.de, mingo@elte.hu, rgetz@blackfin.uclinux.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     lockdep: use new arch_is_kernel_data()
has been removed from the -mm tree.  Its filename was
     lockdep-use-new-arch_is_kernel_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -578,6 +578,9 @@ static int static_obj(void *obj)
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
linux-next.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch
linux-futexh-place-kernel-types-behind-__kernel__.patch

