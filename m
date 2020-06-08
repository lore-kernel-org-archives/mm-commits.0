From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 lib-lz4-lz4_decompressc-document-deliberate-use-of.patch added to -mm tree
Date: Sun, 07 Jun 2020 18:24:38 -0700
Message-ID: <20200608012438.Iln83c7Rk%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbgFHBYj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 7 Jun 2020 21:24:39 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyan@fb.com, hsiangkao@aol.com, joe@perches.com, mm-commits@vger.kernel.org, vvs@virtuozzo.com


The patch titled
     Subject: lib/lz4/lz4_decompress.c: document deliberate use of `&'
has been added to the -mm tree.  Its filename is
     lib-lz4-lz4_decompressc-document-deliberate-use-of.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-lz4-lz4_decompressc-document-deliberate-use-of.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-lz4-lz4_decompressc-document-deliberate-use-of.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-lz4-lz4_decompressc-document-deliberate-use-of.patch
checkpatch-test-git_dir-changes.patch
checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_.patch
