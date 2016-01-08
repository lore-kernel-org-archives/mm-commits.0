From: akpm@linux-foundation.org
Subject: +
 mm-mlockc-change-can_do_mlock-return-value-type-to-boolean.patch added to
 -mm tree
Date: Fri, 08 Jan 2016 14:17:43 -0800
Message-ID: <56903587.J/63IYV8NZvDIrYF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbcAHWRo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 17:17:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangxq10@lzu.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock.c: change can_do_mlock return value type to boolean
has been added to the -mm tree.  Its filename is
     mm-mlockc-change-can_do_mlock-return-value-type-to-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlockc-change-can_do_mlock-return-value-type-to-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlockc-change-can_do_mlock-return-value-type-to-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Subject: mm/mlock.c: change can_do_mlock return value type to boolean

Since can_do_mlock only return 1 or 0, so make it boolean.

No functional change.

Signed-off-by: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/mlock.c~mm-mlockc-change-can_do_mlock-return-value-type-to-boolean mm/mlock.c
--- a/mm/mlock.c~mm-mlockc-change-can_do_mlock-return-value-type-to-boolean
+++ a/mm/mlock.c
@@ -24,13 +24,13 @@
 
 #include "internal.h"
 
-int can_do_mlock(void)
+bool can_do_mlock(void)
 {
 	if (rlimit(RLIMIT_MEMLOCK) != 0)
-		return 1;
+		return true;
 	if (capable(CAP_IPC_LOCK))
-		return 1;
-	return 0;
+		return true;
+	return false;
 }
 EXPORT_SYMBOL(can_do_mlock);
 
_

Patches currently in -mm which might be from wangxq10@lzu.edu.cn are

mm-page_isolation-do-some-cleanup-in-undo_isolate_page_range.patch
mm-vmallocc-use-micro-is_aligned-to-judge-the-aligment.patch
mm-mlockc-change-can_do_mlock-return-value-type-to-boolean.patch

