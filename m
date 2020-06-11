From: akpm@linux-foundation.org
Subject: [merged]
 lib-lz4-lz4_decompressc-document-deliberate-use-of.patch removed from -mm
 tree
Date: Thu, 11 Jun 2020 15:22:51 -0700
Message-ID: <20200611222251.dqGq2p5q7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgFKWWv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Jun 2020 18:22:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyan@fb.com, hsiangkao@aol.com, joe@perches.com, mm-commits@vger.kernel.org, vvs@virtuozzo.com


The patch titled
     Subject: lib/lz4/lz4_decompress.c: document deliberate use of `&'
has been removed from the -mm tree.  Its filename was
     lib-lz4-lz4_decompressc-document-deliberate-use-of.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: lib/lz4/lz4_decompress.c: document deliberate use of `&'

This operation was intentional, but tools such as smatch will warn that it
might not have been.

Link: http://lkml.kernel.org/r/3bf931c6ea0cae3e23f3485801986859851b4f04.camel@perches.com
Cc: Yann Collet <cyan@fb.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Gao Xiang <hsiangkao@aol.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_decompress.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/lz4/lz4_decompress.c~lib-lz4-lz4_decompressc-document-deliberate-use-of
+++ a/lib/lz4/lz4_decompress.c
@@ -141,6 +141,9 @@ static FORCE_INLINE int LZ4_decompress_g
 		 * space in the output for those 18 bytes earlier, upon
 		 * entering the shortcut (in other words, there is a
 		 * combined check for both stages).
+		 *
+		 * The & in the likely() below is intentionally not && so that
+		 * some compilers can produce better parallelized runtime code
 		 */
 		if ((endOnInput ? length != RUN_MASK : length <= 8)
 		   /*
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_.patch
