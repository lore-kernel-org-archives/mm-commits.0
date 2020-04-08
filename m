From: akpm@linux-foundation.org
Subject: [merged] ipc-shm-make-compat_ksys_shmctl-static.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 19:02:42 -0700
Message-ID: <20200408020242.-awVLMskv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgDHCCo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:02:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hulkci@huawei.com, mm-commits@vger.kernel.org, yanaijie@huawei.com


The patch titled
     Subject: ipc/shm.c: make compat_ksys_shmctl() static
has been removed from the -mm tree.  Its filename was
     ipc-shm-make-compat_ksys_shmctl-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Yan <yanaijie@huawei.com>
Subject: ipc/shm.c: make compat_ksys_shmctl() static

Fix the following sparse warning:

ipc/shm.c:1335:6: warning: symbol 'compat_ksys_shmctl' was not declared.
Should it be static?

Link: http://lkml.kernel.org/r/20200403063933.24785-1-yanaijie@huawei.com
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/shm.c~ipc-shm-make-compat_ksys_shmctl-static
+++ a/ipc/shm.c
@@ -1332,7 +1332,7 @@ static int copy_compat_shmid_from_user(s
 	}
 }
 
-long compat_ksys_shmctl(int shmid, int cmd, void __user *uptr, int version)
+static long compat_ksys_shmctl(int shmid, int cmd, void __user *uptr, int version)
 {
 	struct ipc_namespace *ns;
 	struct shmid64_ds sem64;
_

Patches currently in -mm which might be from yanaijie@huawei.com are
