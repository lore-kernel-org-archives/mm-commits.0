From: akpm@linux-foundation.org
Subject: + alpha-prctl-macros.patch added to -mm tree
Date: Wed, 11 Apr 2007 12:58:02 -0700
Message-ID: <200704111958.l3BJw3CO012991@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58430 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030320AbXDKT6I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 15:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, jay.estabrook@hp.com, rth@twiddle.net


The patch titled
     ALPHA: "prctl" macros
has been added to the -mm tree.  Its filename is
     alpha-prctl-macros.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 22 insertions(+)

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

account-for-module-percpu-space-separately-from-kernel.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
alpha-fix-bootp-image-creation.patch
alpha-prctl-macros.patch
alpha-fixes-for-specific-machine-types.patch
alpha-more-fixes-for-specific-machine-types.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
lutimesat-extend-do_utimes-with-flags.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
local_t-alpha-extension.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
make-sure-nobodys-leaking-resources.patch
