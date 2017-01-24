From: akpm@linux-foundation.org
Subject: [patch 23/26] mn10300: fix build error of missing fpu_save()
Date: Tue, 24 Jan 2017 15:18:49 -0800
Message-ID: <5887e0d9.8WMuWRmuh2YYiJzg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41572 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdAXXSu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rdunlap@infradead.org, dhowells@redhat.com, fengguang.wu@intel.com

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mn10300: fix build error of missing fpu_save()

When CONFIG_FPU is not enabled on arch/mn10300, <asm/switch_to.h>
causes a build error with a call to fpu_save():

kernel/built-in.o: In function `.L410':
core.c:(.sched.text+0x28a): undefined reference to `fpu_save'

Fix this by including <asm/fpu.h> in <asm/switch_to.h> so that
an empty static inline fpu_save() is defined.

Link: http://lkml.kernel.org/r/dc421c4f-4842-4429-1b99-92865c2f24b6@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/switch_to.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mn10300/include/asm/switch_to.h~mn10300-fix-build-error-of-missing-fpu_save arch/mn10300/include/asm/switch_to.h
--- a/arch/mn10300/include/asm/switch_to.h~mn10300-fix-build-error-of-missing-fpu_save
+++ a/arch/mn10300/include/asm/switch_to.h
@@ -16,7 +16,7 @@
 struct task_struct;
 struct thread_struct;
 
-#if !defined(CONFIG_LAZY_SAVE_FPU)
+#if defined(CONFIG_FPU) && !defined(CONFIG_LAZY_SAVE_FPU)
 struct fpu_state_struct;
 extern asmlinkage void fpu_save(struct fpu_state_struct *);
 #define switch_fpu(prev, next)						\
_
