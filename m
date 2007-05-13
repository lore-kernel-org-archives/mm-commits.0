From: akpm@linux-foundation.org
Subject: - compat-signalfd-and-timerfd-are-cond-syscalls.patch removed from -mm tree
Date: Sat, 12 May 2007 22:14:53 -0700
Message-ID: <200705130514.l4D5EqGV022732@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756507AbXEMFPA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 01:15:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     compat signalfd and timerfd are cond syscalls
has been removed from the -mm tree.  Its filename was
     compat-signalfd-and-timerfd-are-cond-syscalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+)

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

s390-spinlock-initializer-cleanup.patch
