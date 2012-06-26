From: akpm@linux-foundation.org
Subject: + h8300-uaccess-add-mising-__clear_user.patch added to -mm tree
Date: Tue, 26 Jun 2012 16:50:32 -0700
Message-ID: <20120626235032.B9EA6A0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:34599 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab2FZXue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jun 2012 19:50:34 -0400
Received: by bkty5 with SMTP id y5so21112bkt.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Jun 2012 16:50:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, tony@bakeyournoodle.com, ysato@users.sourceforge.jp


The patch titled
     Subject: h8300/uaccess: add mising __clear_user()
has been added to the -mm tree.  Its filename is
     h8300-uaccess-add-mising-__clear_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: h8300/uaccess: add mising __clear_user()

include/linux/regset.h: In function 'user_regset_copyout_zero':
include/linux/regset.h:289:3: error: implicit declaration of function '__clear_user' [-Werror=implicit-function-declaration]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/uaccess.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/h8300/include/asm/uaccess.h~h8300-uaccess-add-mising-__clear_user arch/h8300/include/asm/uaccess.h
--- a/arch/h8300/include/asm/uaccess.h~h8300-uaccess-add-mising-__clear_user
+++ a/arch/h8300/include/asm/uaccess.h
@@ -158,4 +158,6 @@ clear_user(void *to, unsigned long n)
 	return 0;
 }
 
+#define __clear_user	clear_user
+
 #endif /* _H8300_UACCESS_H */
_
Subject: Subject: h8300/uaccess: add mising __clear_user()

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c.patch
mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch
mn10300-kernel-internalh-needs-linux-irqreturnh.patch
mn10300-kernel-trapsc-needs-linux-exporth.patch
mn10300-mm-dma-allocc-needs-linux-exporth.patch
mn10300-use-elif-definedconfig_-instead-of-elif-config_.patch
h8300-pgtable-add-missing-include-asm-generic-pgtableh.patch
h8300-signal-fix-typo-statis.patch
h8300-time-add-missing-include-asm-irq_regsh.patch
h8300-uaccess-remove-assignment-to-__gu_val-in-unhandled-case-of-get_user.patch
h8300-uaccess-add-mising-__clear_user.patch

