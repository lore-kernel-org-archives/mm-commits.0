From: akpm@linux-foundation.org
Subject: + score-fix-off-by-one-index-into-syscall-table.patch added to -mm tree
Date: Wed, 18 Jan 2012 15:52:40 -0800
Message-ID: <20120118235240.AFEDD10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:38913 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2ARXwl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2012 18:52:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, arnd@arndb.de, eugeneteo@kernel.sg, lennox.wu@gmail.com, liqin.chen@sunplusct.com, stable@vger.kernel.org


The patch titled
     Subject: score: fix off-by-one index into syscall table
has been added to the -mm tree.  Its filename is
     score-fix-off-by-one-index-into-syscall-table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: score: fix off-by-one index into syscall table

Patches currently in -mm which might be from drosenberg@vsecurity.com are

origin.patch
score-fix-off-by-one-index-into-syscall-table.patch

