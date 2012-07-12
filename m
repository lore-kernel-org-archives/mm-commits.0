From: akpm@linux-foundation.org
Subject: [merged] h8300-uaccess-add-mising-__clear_user.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:37:02 -0700
Message-ID: <20120712193702.AFBC3100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:49787 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934226Ab2GLThD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:03 -0400
Received: by ggeh3 with SMTP id h3so266593gge.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, tony@bakeyournoodle.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: h8300/uaccess: add mising __clear_user()
has been removed from the -mm tree.  Its filename was
     h8300-uaccess-add-mising-__clear_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
frv-kill-used-but-uninitialized-variable.patch

