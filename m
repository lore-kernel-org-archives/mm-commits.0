From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 123/166] lib/test_kmod.c: remove a NULL test
Date: Mon, 06 Apr 2020 20:10:35 -0700
Message-ID: <20200407031035.zJGc4rJaA%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgDGDKg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:10:36 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.carpenter@oracle.com, linux-mm@kvack.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
