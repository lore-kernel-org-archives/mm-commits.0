From: akpm@linux-foundation.org
Subject: [merged] mm-constify-nmask-argument-to-set_mempolicy.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:56 -0700
Message-ID: <5390ca20.2DfH7+4l9QsAEPFU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaFETu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux@rasmusvillemoes.dk

Subject: [merged] mm-constify-nmask-argument-to-set_mempolicy.patch removed from -mm tree
To: linux@rasmusvillemoes.dk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:56 -0700


The patch titled
     Subject: mm: constify nmask argument to set_mempolicy()
has been removed from the -mm tree.  Its filename was
     mm-constify-nmask-argument-to-set_mempolicy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm: constify nmask argument to set_mempolicy()

The nmask argument to set_mempolicy() is const according to the user-space
header numaif.h, and since the kernel does indeed not modify it, it might
as well be declared const in the kernel.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syscalls.h |    2 +-
 mm/mempolicy.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/syscalls.h~mm-constify-nmask-argument-to-set_mempolicy include/linux/syscalls.h
--- a/include/linux/syscalls.h~mm-constify-nmask-argument-to-set_mempolicy
+++ a/include/linux/syscalls.h
@@ -711,7 +711,7 @@ asmlinkage long sys_keyctl(int cmd, unsi
 
 asmlinkage long sys_ioprio_set(int which, int who, int ioprio);
 asmlinkage long sys_ioprio_get(int which, int who);
-asmlinkage long sys_set_mempolicy(int mode, unsigned long __user *nmask,
+asmlinkage long sys_set_mempolicy(int mode, const unsigned long __user *nmask,
 				unsigned long maxnode);
 asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
 				const unsigned long __user *from,
diff -puN mm/mempolicy.c~mm-constify-nmask-argument-to-set_mempolicy mm/mempolicy.c
--- a/mm/mempolicy.c~mm-constify-nmask-argument-to-set_mempolicy
+++ a/mm/mempolicy.c
@@ -1383,7 +1383,7 @@ SYSCALL_DEFINE6(mbind, unsigned long, st
 }
 
 /* Set the process memory policy */
-SYSCALL_DEFINE3(set_mempolicy, int, mode, unsigned long __user *, nmask,
+SYSCALL_DEFINE3(set_mempolicy, int, mode, const unsigned long __user *, nmask,
 		unsigned long, maxnode)
 {
 	int err;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

