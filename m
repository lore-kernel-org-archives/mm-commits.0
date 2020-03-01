From: akpm@linux-foundation.org
Subject: + lib-test_kmod-remove-a-null-test.patch added to -mm
 tree
Date: Sat, 29 Feb 2020 20:20:23 -0800
Message-ID: <20200301042023.TEF935SnS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgCAEUY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 23:20:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mcgrof@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_kmod.c: remove a NULL test
has been added to the -mm tree.  Its filename is
     lib-test_kmod-remove-a-null-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_kmod-remove-a-null-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_kmod-remove-a-null-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: lib/test_kmod.c: remove a NULL test

The "info" pointer has already been dereferenced so checking here is too
late.  Fortunately, we never pass NULL pointers to the
test_kmod_put_module() function so the test can simply be removed.

Link: http://lkml.kernel.org/r/20200228092452.vwkhthsn77nrxdy6@kili.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_kmod.c~lib-test_kmod-remove-a-null-test
+++ a/lib/test_kmod.c
@@ -204,7 +204,7 @@ static void test_kmod_put_module(struct
 	case TEST_KMOD_DRIVER:
 		break;
 	case TEST_KMOD_FS_TYPE:
-		if (info && info->fs_sync && info->fs_sync->owner)
+		if (info->fs_sync && info->fs_sync->owner)
 			module_put(info->fs_sync->owner);
 		break;
 	default:
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

lib-test_kmod-remove-a-null-test.patch
loop-use-worker-per-cgroup-instead-of-kworker-fix.patch
