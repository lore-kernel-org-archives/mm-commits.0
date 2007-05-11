From: akpm@linux-foundation.org
Subject: + x86_64-use-signalfd-and-timerfd-compat-syscalls.patch added to -mm tree
Date: Fri, 11 May 2007 16:21:06 -0700
Message-ID: <200705112321.l4BNL6dT029269@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758487AbXEKXVO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 19:21:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, ak@suse.de, davidel@xmailserver.org


The patch titled
     x86_64: use signalfd and timerfd compat syscalls
has been added to the -mm tree.  Its filename is
     x86_64-use-signalfd-and-timerfd-compat-syscalls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: use signalfd and timerfd compat syscalls
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Looks like these two are wired up in a wrong way.

Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32entry.S |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/ia32/ia32entry.S~x86_64-use-signalfd-and-timerfd-compat-syscalls arch/x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~x86_64-use-signalfd-and-timerfd-compat-syscalls
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -716,7 +716,7 @@ ia32_sys_call_table:
 	.quad sys_getcpu
 	.quad sys_epoll_pwait
 	.quad compat_sys_utimensat	/* 320 */
-	.quad sys_signalfd
-	.quad sys_timerfd
+	.quad compat_sys_signalfd
+	.quad compat_sys_timerfd
 	.quad sys_eventfd
-ia32_syscall_end:		
+ia32_syscall_end:
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
compat-signalfd-and-timerfd-are-cond-syscalls.patch
x86_64-use-signalfd-and-timerfd-compat-syscalls.patch
s390-spinlock-initializer-cleanup.patch
