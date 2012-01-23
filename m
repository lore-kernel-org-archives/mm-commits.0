From: akpm@linux-foundation.org
Subject: [merged] score-fix-off-by-one-index-into-syscall-table.patch removed from -mm tree
Date: Mon, 23 Jan 2012 12:22:04 -0800
Message-ID: <20120123202204.B82A61E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61933 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab2AWUWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 15:22:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drosenberg@vsecurity.com, arnd@arndb.de, eugeneteo@kernel.sg, lennox.wu@gmail.com, liqin.chen@sunplusct.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: score: fix off-by-one index into syscall table
has been removed from the -mm tree.  Its filename was
     score-fix-off-by-one-index-into-syscall-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>
Subject: score: fix off-by-one index into syscall table

If the provided system call number is equal to __NR_syscalls, the current
check will pass and a function pointer just after the system call table
may be called, since sys_call_table is an array with total size
__NR_syscalls.

Whether or not this is a security bug depends on what the compiler puts
immediately after the system call table.  It's likely that this won't do
anything bad because there is an additional NULL check on the syscall
entry, but if there happens to be a non-NULL value immediately after the
system call table, this may result in local privilege escalation.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: <stable@vger.kernel.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/score/kernel/entry.S~score-fix-off-by-one-index-into-syscall-table arch/score/kernel/entry.S
--- a/arch/score/kernel/entry.S~score-fix-off-by-one-index-into-syscall-table
+++ a/arch/score/kernel/entry.S
@@ -408,7 +408,7 @@ ENTRY(handle_sys)
 	sw	r9, [r0, PT_EPC]
 
 	cmpi.c	r27, __NR_syscalls 	# check syscall number
-	bgtu	illegal_syscall
+	bgeu	illegal_syscall
 
 	slli	r8, r27, 2		# get syscall routine
 	la	r11, sys_call_table
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

origin.patch

