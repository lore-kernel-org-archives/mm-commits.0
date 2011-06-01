From: akpm@linux-foundation.org
Subject: + cris-fix-a-build-error-in-kernel-forkc.patch added to -mm tree
Date: Wed, 01 Jun 2011 15:07:48 -0700
Message-ID: <201106012207.p51M7naR012423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033Ab1FAWIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 18:08:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, geert@linux-m68k.org, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris: fix a build error in kernel/fork.c
has been added to the -mm tree.  Its filename is
     cris-fix-a-build-error-in-kernel-forkc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: fix a build error in kernel/fork.c
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>

kernel/fork.c:267: error: implicit declaration of function
'alloc_thread_info_node'

This is due to renaming alloc_thread_info() to alloc_thread_info_node().

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/thread_info.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/cris/include/asm/thread_info.h~cris-fix-a-build-error-in-kernel-forkc arch/cris/include/asm/thread_info.h
--- a/arch/cris/include/asm/thread_info.h~cris-fix-a-build-error-in-kernel-forkc
+++ a/arch/cris/include/asm/thread_info.h
@@ -11,8 +11,6 @@
 
 #ifdef __KERNEL__
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
