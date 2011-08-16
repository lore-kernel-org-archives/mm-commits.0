From: akpm@linux-foundation.org
Subject: [merged] cris-fix-a-build-error-in-kernel-forkc.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:50:48 -0700
Message-ID: <201108161847.p7GIltv3015185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197Ab1HPSyu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:54:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, geert@linux-m68k.org, jesper.nilsson@axis.com, stable@kernel.org, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: fix a build error in kernel/fork.c
has been removed from the -mm tree.  Its filename was
     cris-fix-a-build-error-in-kernel-forkc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: fix a build error in kernel/fork.c
From: WANG Cong <xiyou.wangcong@gmail.com>

kernel/fork.c:267: error: implicit declaration of function
'alloc_thread_info_node'

This is due to renaming alloc_thread_info() to alloc_thread_info_node().

[akpm@linux-foundation.org: coding-style fixes]
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/thread_info.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/cris/include/asm/thread_info.h~cris-fix-a-build-error-in-kernel-forkc arch/cris/include/asm/thread_info.h
--- a/arch/cris/include/asm/thread_info.h~cris-fix-a-build-error-in-kernel-forkc
+++ a/arch/cris/include/asm/thread_info.h
@@ -11,8 +11,6 @@
 
 #ifdef __KERNEL__
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
