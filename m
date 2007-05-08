From: akpm@linux-foundation.org
Subject: - alpha-prctl-macros.patch removed from -mm tree
Date: Mon, 07 May 2007 17:05:06 -0700
Message-ID: <200705080005.l48056Ep009066@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757AbXEHAGF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, jay.estabrook@hp.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     ALPHA: "prctl" macros
has been removed from the -mm tree.  Its filename was
     alpha-prctl-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ALPHA: "prctl" macros
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Files:

include/asm-alpha/thread_info.h

	Provide "prctl" macros for ALPHA.

Signed-off-by: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/thread_info.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN include/asm-alpha/thread_info.h~alpha-prctl-macros include/asm-alpha/thread_info.h
--- a/include/asm-alpha/thread_info.h~alpha-prctl-macros
+++ a/include/asm-alpha/thread_info.h
@@ -92,5 +92,27 @@ register struct thread_info *__current_t
 #define _TIF_ALLWORK_MASK	(_TIF_WORK_MASK		\
 				 | _TIF_SYSCALL_TRACE)
 
+#define ALPHA_UAC_SHIFT		6
+#define ALPHA_UAC_MASK		(1 << TIF_UAC_NOPRINT | 1 << TIF_UAC_NOFIX | \
+				 1 << TIF_UAC_SIGBUS)
+
+#define SET_UNALIGN_CTL(task,value)	({				     \
+	(task)->thread_info->flags = (((task)->thread_info->flags &	     \
+		~ALPHA_UAC_MASK)					     \
+		| (((value) << ALPHA_UAC_SHIFT)       & (1<<TIF_UAC_NOPRINT))\
+		| (((value) << (ALPHA_UAC_SHIFT + 1)) & (1<<TIF_UAC_SIGBUS)) \
+		| (((value) << (ALPHA_UAC_SHIFT - 1)) & (1<<TIF_UAC_NOFIX)));\
+	0; })
+
+#define GET_UNALIGN_CTL(task,value)	({				\
+	put_user(((task)->thread_info->flags & (1 << TIF_UAC_NOPRINT))	\
+		  >> ALPHA_UAC_SHIFT					\
+		 | ((task)->thread_info->flags & (1 << TIF_UAC_SIGBUS))	\
+		 >> (ALPHA_UAC_SHIFT + 1)				\
+		 | ((task)->thread_info->flags & (1 << TIF_UAC_NOFIX))	\
+		 >> (ALPHA_UAC_SHIFT - 1),				\
+		 (int __user *)(value));				\
+	})
+
 #endif /* __KERNEL__ */
 #endif /* _ALPHA_THREAD_INFO_H */
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

origin.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
local_t-alpha-extension.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
make-sure-nobodys-leaking-resources.patch
