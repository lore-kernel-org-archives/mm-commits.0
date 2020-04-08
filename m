From: akpm@linux-foundation.org
Subject: [merged] lib-test_kmod-remove-a-null-test.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 19:01:19 -0700
Message-ID: <20200408020119.2So5zsDmD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgDHCBU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mcgrof@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_kmod.c: remove a NULL test
has been removed from the -mm tree.  Its filename was
     lib-test_kmod-remove-a-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
