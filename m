From: akpm@linux-foundation.org
Subject: [merged]
 mm-mlockc-change-can_do_mlock-return-value-type-to-boolean.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:14:09 -0800
Message-ID: <569e9911.sMwXsEY/TjIsSq5h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangxq10@lzu.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock.c: change can_do_mlock return value type to boolean
has been removed from the -mm tree.  Its filename was
     mm-mlockc-change-can_do_mlock-return-value-type-to-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Subject: mm/mlock.c: change can_do_mlock return value type to boolean

Since can_do_mlock only return 1 or 0, so make it boolean.

No functional change.

[akpm@linux-foundation.org: update declaration in mm.h]
Signed-off-by: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/mlock.c         |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/mm.h~mm-mlockc-change-can_do_mlock-return-value-type-to-boolean include/linux/mm.h
--- a/include/linux/mm.h~mm-mlockc-change-can_do_mlock-return-value-type-to-boolean
+++ a/include/linux/mm.h
@@ -1100,7 +1100,7 @@ static inline bool shmem_mapping(struct
 }
 #endif
 
-extern int can_do_mlock(void);
+extern bool can_do_mlock(void);
 extern int user_shm_lock(size_t, struct user_struct *);
 extern void user_shm_unlock(size_t, struct user_struct *);
 
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


