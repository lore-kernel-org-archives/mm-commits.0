From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-shm-make-compat_ksys_shmctl-static.patch added to
 -mm tree
Date: Fri, 03 Apr 2020 16:45:55 -0700
Message-ID: <20200403234555.CoFd1leUN%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgDCXp4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 19:45:56 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hulkci@huawei.com, mm-commits@vger.kernel.org, yanaijie@huawei.com


The patch titled
     Subject: ipc/shm.c: make compat_ksys_shmctl() static
has been added to the -mm tree.  Its filename is
     ipc-shm-make-compat_ksys_shmctl-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-shm-make-compat_ksys_shmctl-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-shm-make-compat_ksys_shmctl-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ipc-shm-make-compat_ksys_shmctl-static.patch
