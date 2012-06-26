From: akpm@linux-foundation.org
Subject: + h8300-uaccess-remove-assignment-to-__gu_val-in-unhandled-case-of-get_user.patch added to -mm tree
Date: Tue, 26 Jun 2012 16:50:30 -0700
Message-ID: <20120626235030.EDE19A0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:44456 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab2FZXuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jun 2012 19:50:32 -0400
Received: by wibhr14 with SMTP id hr14so23333wib.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Jun 2012 16:50:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, tony@bakeyournoodle.com, ysato@users.sourceforge.jp


The patch titled
     Subject: h8300/uaccess: remove assignment to __gu_val in unhandled case of get_user()
has been added to the -mm tree.  Its filename is
     h8300-uaccess-remove-assignment-to-__gu_val-in-unhandled-case-of-get_user.patch

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
Subject: h8300/uaccess: remove assignment to __gu_val in unhandled case of get_user()

__gu_val is const if the passed ptr is const, giving:

include/linux/pagemap.h: In function 'fault_in_pages_readable':
include/linux/pagemap.h:442:2: error: assignment of read-only variable '__gu_val'
include/linux/pagemap.h:448:4: error: assignment of read-only variable '__gu_val'
include/linux/pagemap.h: In function 'fault_in_multipages_readable':
include/linux/pagemap.h:499:3: error: assignment of read-only variable '__gu_val'
include/linux/pagemap.h:508:3: error: assignment of read-only variable '__gu_val'
make[4]: *** [init/main.o] Error 1

As we don't care about the actual value of __gu_val in the unhandled
case (it will cause a link error anyway), just remove the assignment.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/uaccess.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/h8300/include/asm/uaccess.h~h8300-uaccess-remove-assignment-to-__gu_val-in-unhandled-case-of-get_user arch/h8300/include/asm/uaccess.h
--- a/arch/h8300/include/asm/uaccess.h~h8300-uaccess-remove-assignment-to-__gu_val-in-unhandled-case-of-get_user
+++ a/arch/h8300/include/asm/uaccess.h
@@ -100,7 +100,6 @@ extern int __put_user_bad(void);
 	break;							\
     default:							\
 	__gu_err = __get_user_bad();				\
-	__gu_val = 0;						\
 	break;							\
     }								\
     (x) = __gu_val;						\
_
Subject: Subject: h8300/uaccess: remove assignment to __gu_val in unhandled case of get_user()

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

