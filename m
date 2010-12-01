From: akpm@linux-foundation.org
Subject: + cramfs-hide-function-prototypes-behind-__kernel__-macro.patch added to -mm tree
Date: Wed, 01 Dec 2010 14:56:01 -0800
Message-ID: <201012012256.oB1Mu147016600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756233Ab0LAW4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2010 17:56:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: virtuoso@slind.org


The patch titled
     cramfs: hide function prototypes behind __KERNEL__ macro
has been added to the -mm tree.  Its filename is
     cramfs-hide-function-prototypes-behind-__kernel__-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cramfs: hide function prototypes behind __KERNEL__ macro
From: Alexander Shishkin <virtuoso@slind.org>

Currently, 3 kernel function prototypes are present in a header
file exported to userland. This patch fixes it.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cramfs_fs.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/cramfs_fs.h~cramfs-hide-function-prototypes-behind-__kernel__-macro include/linux/cramfs_fs.h
--- a/include/linux/cramfs_fs.h~cramfs-hide-function-prototypes-behind-__kernel__-macro
+++ a/include/linux/cramfs_fs.h
@@ -84,9 +84,11 @@ struct cramfs_super {
 				| CRAMFS_FLAG_WRONG_SIGNATURE \
 				| CRAMFS_FLAG_SHIFTED_ROOT_OFFSET )
 
+#ifdef __KERNEL__
 /* Uncompression interfaces to the underlying zlib */
 int cramfs_uncompress_block(void *dst, int dstlen, void *src, int srclen);
 int cramfs_uncompress_init(void);
 void cramfs_uncompress_exit(void);
+#endif /* __KERNEL__ */
 
 #endif
_

Patches currently in -mm which might be from virtuoso@slind.org are

headers_check-better-search-for-functions-in-headers.patch
headers_check-better-search-for-functions-in-headers-fix.patch
headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes.patch
scsi-fix-a-header-to-include-linux-typesh.patch
toshibah-hide-a-function-prototypes-behind-__kernel__-macro.patch
cramfs-hide-function-prototypes-behind-__kernel__-macro.patch

