From: akpm@linux-foundation.org
Subject: - cris-v10-kernel-timec-needs-to-include-linux-vmstath-to-compile.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:38:44 -0800
Message-ID: <200801160138.m0G1cife013931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36881 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755179AbYAPBis (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:38:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, mikael.starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRIS v10: kernel/time.c needs to include linux/vmstat.h to compile
has been removed from the -mm tree.  Its filename was
     cris-v10-kernel-timec-needs-to-include-linux-vmstath-to-compile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CRIS v10: kernel/time.c needs to include linux/vmstat.h to compile
From: Jesper Nilsson <jesper.nilsson@axis.com>

This fixes compile error when nr_free_pages() from linux/swap.h
expands to global_page_state(NR_FREE_PAGES), but linux/vmstat.h isn't
included to declare global_page_state().

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/cris/arch-v10/kernel/time.c~cris-v10-kernel-timec-needs-to-include-linux-vmstath-to-compile arch/cris/arch-v10/kernel/time.c
--- a/arch/cris/arch-v10/kernel/time.c~cris-v10-kernel-timec-needs-to-include-linux-vmstath-to-compile
+++ a/arch/cris/arch-v10/kernel/time.c
@@ -13,6 +13,7 @@
 #include <linux/swap.h>
 #include <linux/sched.h>
 #include <linux/init.h>
+#include <linux/vmstat.h>
 #include <asm/arch/svinto.h>
 #include <asm/types.h>
 #include <asm/signal.h>
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-v10-vmlinuxldss-fix-kernel-oops-on-boot-and-use-common-defines.patch
git-kbuild.patch
git-mtd.patch
cris-avoid-using-arch-links-in-kconfig.patch
cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch
avoid-overflows-in-kernel-timec.patch
