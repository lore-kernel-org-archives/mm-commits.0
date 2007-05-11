From: akpm@linux-foundation.org
Subject: + compat-signalfd-and-timerfd-are-cond-syscalls.patch added to -mm tree
Date: Fri, 11 May 2007 16:21:04 -0700
Message-ID: <200705112321.l4BNL4Gd029266@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832AbXEKXVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 19:21:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, davidel@xmailserver.org


The patch titled
     compat signalfd and timerfd are cond syscalls
has been added to the -mm tree.  Its filename is
     compat-signalfd-and-timerfd-are-cond-syscalls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: compat signalfd and timerfd are cond syscalls
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Add missing cond_syscall statements for compat_sys_signalfd and
compat_sys_timerfd.

Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys_ni.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN kernel/sys_ni.c~compat-signalfd-and-timerfd-are-cond-syscalls kernel/sys_ni.c
--- a/kernel/sys_ni.c~compat-signalfd-and-timerfd-are-cond-syscalls
+++ a/kernel/sys_ni.c
@@ -145,4 +145,6 @@ cond_syscall(sys_ioprio_get);
 /* New file descriptors */
 cond_syscall(sys_signalfd);
 cond_syscall(sys_timerfd);
+cond_syscall(compat_sys_signalfd);
+cond_syscall(compat_sys_timerfd);
 cond_syscall(sys_eventfd);
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
compat-signalfd-and-timerfd-are-cond-syscalls.patch
x86_64-use-signalfd-and-timerfd-compat-syscalls.patch
s390-spinlock-initializer-cleanup.patch
