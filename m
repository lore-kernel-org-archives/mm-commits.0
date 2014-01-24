From: akpm@linux-foundation.org
Subject: [merged] remove-extra-definitions-of-u32_max.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 11:00:25 -0800
Message-ID: <52e2b849.euSC1y7zAbb3QRt/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sage@inktank.com, elder@linaro.org, davem@davemloft.net, alex.elder@linaro.org

Subject: [merged] remove-extra-definitions-of-u32_max.patch removed from -mm tree
To: alex.elder@linaro.org,davem@davemloft.net,elder@linaro.org,sage@inktank.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:25 -0800


The patch titled
     Subject: remove extra definitions of U32_MAX
has been removed from the -mm tree.  Its filename was
     remove-extra-definitions-of-u32_max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Elder <alex.elder@linaro.org>
Subject: remove extra definitions of U32_MAX

Now that the definition is centralized in <linux/kernel.h>, the
definitions of U32_MAX (and related) elsewhere in the kernel can be
removed.

Signed-off-by: Alex Elder <elder@linaro.org>
Acked-by: Sage Weil <sage@inktank.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/reiserfs.h      |    4 ----
 include/linux/ceph/decode.h |   19 -------------------
 net/ipv4/tcp_illinois.c     |    3 ---
 3 files changed, 26 deletions(-)

diff -puN fs/reiserfs/reiserfs.h~remove-extra-definitions-of-u32_max fs/reiserfs/reiserfs.h
--- a/fs/reiserfs/reiserfs.h~remove-extra-definitions-of-u32_max
+++ a/fs/reiserfs/reiserfs.h
@@ -1958,10 +1958,6 @@ struct treepath var = {.path_length = IL
 #define MAX_US_INT 0xffff
 
 // reiserfs version 2 has max offset 60 bits. Version 1 - 32 bit offset
-#ifndef U32_MAX
-#define U32_MAX (~(__u32)0)
-#endif /* !U32_MAX */
-
 static inline loff_t max_reiserfs_offset(struct inode *inode)
 {
 	if (get_inode_item_key_version(inode) == KEY_FORMAT_3_5)
diff -puN include/linux/ceph/decode.h~remove-extra-definitions-of-u32_max include/linux/ceph/decode.h
--- a/include/linux/ceph/decode.h~remove-extra-definitions-of-u32_max
+++ a/include/linux/ceph/decode.h
@@ -8,25 +8,6 @@
 
 #include <linux/ceph/types.h>
 
-/* This seemed to be the easiest place to define these */
-
-#ifndef U32_MAX
-#define	U8_MAX	((u8)(~0U))
-#define	U16_MAX	((u16)(~0U))
-#define	U32_MAX	((u32)(~0U))
-#define	U64_MAX	((u64)(~0ULL))
-
-#define	S8_MAX	((s8)(U8_MAX >> 1))
-#define	S16_MAX	((s16)(U16_MAX >> 1))
-#define	S32_MAX	((s32)(U32_MAX >> 1))
-#define	S64_MAX	((s64)(U64_MAX >> 1LL))
-
-#define	S8_MIN	((s8)(-S8_MAX - 1))
-#define	S16_MIN	((s16)(-S16_MAX - 1))
-#define	S32_MIN	((s32)(-S32_MAX - 1))
-#define	S64_MIN	((s64)(-S64_MAX - 1LL))
-#endif /* !U32_MAX */
