From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 166/166] ipc/shm.c: make compat_ksys_shmctl()
 static
Date: Mon, 06 Apr 2020 20:12:56 -0700
Message-ID: <20200407031256.gDHc8ZETu%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgDGDM5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:12:57 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hulkci@huawei.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yanaijie@huawei.com

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
