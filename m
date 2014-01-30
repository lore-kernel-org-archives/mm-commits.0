From: akpm@linux-foundation.org
Subject: [merged]
 s390-compat-change-parameter-types-from-unsigned-long-to-compat_ulong_t.patch removed from -mm tree
Date: Thu, 30 Jan 2014 12:05:14 -0800
Message-ID: <52eab07a.wbE3V7OlH3854lC6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaA3UFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 15:05:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, schwidefsky@de.ibm.com, mingo@kernel.org, hpa@zytor.com, brueckner@linux.vnet.ibm.com, heiko.carstens@de.ibm.com

Subject: [merged] s390-compat-change-parameter-types-from-unsigned-long-to-compat_ulong_t.patch removed from -mm tree
To: heiko.carstens@de.ibm.com,brueckner@linux.vnet.ibm.com,hpa@zytor.com,mingo@kernel.org,schwidefsky@de.ibm.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 12:05:14 -0800


The patch titled
     Subject: s390/compat: change parameter types from unsigned long to compat_ulong_t
has been removed from the -mm tree.  Its filename was
     s390-compat-change-parameter-types-from-unsigned-long-to-compat_ulong_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: s390/compat: change parameter types from unsigned long to compat_ulong_t

Change parameter types of s390's compat ipc syscall from unsigned long to
compat_ulong_t to enforce zero extension of these parameters.

This is not really a bug, since s390_ipc compat syscall is only a wrapper
to the generic compat_sys_ipc() syscall, which performs correct zero and
sign extension.

This was introduced with 56e41d3c5aa84 "merge compat sys_ipc instances".

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/compat_linux.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/s390/kernel/compat_linux.c~s390-compat-change-parameter-types-from-unsigned-long-to-compat_ulong_t arch/s390/kernel/compat_linux.c
--- a/arch/s390/kernel/compat_linux.c~s390-compat-change-parameter-types-from-unsigned-long-to-compat_ulong_t
+++ a/arch/s390/kernel/compat_linux.c
@@ -286,8 +286,8 @@ asmlinkage long sys32_getegid16(void)
 }
 
 #ifdef CONFIG_SYSVIPC
-COMPAT_SYSCALL_DEFINE5(s390_ipc, uint, call, int, first, unsigned long, second,
-		unsigned long, third, compat_uptr_t, ptr)
+COMPAT_SYSCALL_DEFINE5(s390_ipc, uint, call, int, first, compat_ulong_t, second,
+		compat_ulong_t, third, compat_uptr_t, ptr)
 {
 	if (call >> 16)		/* hack for backward compatibility */
 		return -EINVAL;
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch

