From: akpm@linux-foundation.org
Subject: - uaccess-fix-parameters-inversion-for-__copy_from_user_inatomic.patch removed from -mm tree
Date: Fri, 19 Sep 2008 15:06:36 -0700
Message-ID: <200809192206.m8JM6a6N008838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbYISWGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 18:06:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: h-shimamoto@ct.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     uaccess: fix parameters inversion for __copy_from_user_inatomic()
has been removed from the -mm tree.  Its filename was
     uaccess-fix-parameters-inversion-for-__copy_from_user_inatomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uaccess: fix parameters inversion for __copy_from_user_inatomic()
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

The following patch changes to use __copy_from_user_inatomic(),
but the passing parameters incorrect.

    x86: some lock annotations for user copy paths, v3

    - add annotation back to clear_user()
    - change probe_kernel_address() to _inatomic*() method

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/uaccess.h~uaccess-fix-parameters-inversion-for-__copy_from_user_inatomic include/linux/uaccess.h
--- a/include/linux/uaccess.h~uaccess-fix-parameters-inversion-for-__copy_from_user_inatomic
+++ a/include/linux/uaccess.h
@@ -78,7 +78,7 @@ static inline unsigned long __copy_from_
 							\
 		set_fs(KERNEL_DS);			\
 		pagefault_disable();			\
-		ret = __copy_from_user_inatomic((__force typeof(retval) __user *)(addr), &(retval), sizeof(retval));		\
+		ret = __copy_from_user_inatomic(&(retval), (__force typeof(retval) __user *)(addr), sizeof(retval));		\
 		pagefault_enable();			\
 		set_fs(old_fs);				\
 		ret;					\
_

Patches currently in -mm which might be from h-shimamoto@ct.jp.nec.com are

linux-next.patch
net-fix-compilation-ng-when-config_module.patch
unevictable-lru-page-statistics.patch

