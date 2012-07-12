From: akpm@linux-foundation.org
Subject: [merged] h8300-uaccess-remove-assignment-to-__gu_val-in-unhandled-case-of-get_user.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:59 -0700
Message-ID: <20120712193659.C19C7100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60493 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab2GLThA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:00 -0400
Received: by mail-vc0-f202.google.com with SMTP id p1so16661vcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, tony@bakeyournoodle.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: h8300/uaccess: remove assignment to __gu_val in unhandled case of get_user()
has been removed from the -mm tree.  Its filename was
     h8300-uaccess-remove-assignment-to-__gu_val-in-unhandled-case-of-get_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
frv-kill-used-but-uninitialized-variable.patch

