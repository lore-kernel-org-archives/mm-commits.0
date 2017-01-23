From: akpm@linux-foundation.org
Subject: + mn10300-fix-build-error-of-missing-fpu_save.patch added to -mm
 tree
Date: Mon, 23 Jan 2017 15:35:36 -0800
Message-ID: <58869348.JamnYu43rtOEHcPI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46376 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbdAWXfh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 18:35:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, dhowells@redhat.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: fix build error of missing fpu_save()
has been added to the -mm tree.  Its filename is
     mn10300-fix-build-error-of-missing-fpu_save.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mn10300-fix-build-error-of-missing-fpu_save.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mn10300-fix-build-error-of-missing-fpu_save.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are

mn10300-fix-build-error-of-missing-fpu_save.patch
mm-fix-filemapc-kernel-doc-warnings.patch
mm-fix-linux-pagemaph-stray-kernel-doc-notation.patch
fonts-keep-non-sparc-fonts-listed-together.patch

