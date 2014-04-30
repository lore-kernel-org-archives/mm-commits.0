From: akpm@linux-foundation.org
Subject: + mm-constify-nmask-argument-to-mbind.patch added to -mm tree
Date: Wed, 30 Apr 2014 11:16:19 -0700
Message-ID: <53613df3.5KX6Om1m1T4Kdw38%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759084AbaD3SQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 14:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, linux@rasmusvillemoes.dk

Subject: + mm-constify-nmask-argument-to-mbind.patch added to -mm tree
To: linux@rasmusvillemoes.dk,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 11:16:19 -0700


The patch titled
     Subject: mm: constify nmask argument to mbind()
has been added to the -mm tree.  Its filename is
     mm-constify-nmask-argument-to-mbind.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-constify-nmask-argument-to-mbind.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-constify-nmask-argument-to-mbind.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm: constify nmask argument to mbind()

The nmask argument to mbind() is const according to the userspace header
numaif.h, and since the kernel does indeed not modify it, it might as well
be declared const in the kernel.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syscalls.h |    2 +-
 mm/mempolicy.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/syscalls.h~mm-constify-nmask-argument-to-mbind include/linux/syscalls.h
--- a/include/linux/syscalls.h~mm-constify-nmask-argument-to-mbind
+++ a/include/linux/syscalls.h
@@ -723,7 +723,7 @@ asmlinkage long sys_move_pages(pid_t pid
 				int flags);
 asmlinkage long sys_mbind(unsigned long start, unsigned long len,
 				unsigned long mode,
-				unsigned long __user *nmask,
+				const unsigned long __user *nmask,
 				unsigned long maxnode,
 				unsigned flags);
 asmlinkage long sys_get_mempolicy(int __user *policy,
diff -puN mm/mempolicy.c~mm-constify-nmask-argument-to-mbind mm/mempolicy.c
--- a/mm/mempolicy.c~mm-constify-nmask-argument-to-mbind
+++ a/mm/mempolicy.c
@@ -1312,7 +1312,7 @@ static int copy_nodes_to_user(unsigned l
 }
 
 SYSCALL_DEFINE6(mbind, unsigned long, start, unsigned long, len,
-		unsigned long, mode, unsigned long __user *, nmask,
+		unsigned long, mode, const unsigned long __user *, nmask,
 		unsigned long, maxnode, unsigned, flags)
 {
 	nodemask_t nodes;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

mm-constify-nmask-argument-to-mbind.patch

