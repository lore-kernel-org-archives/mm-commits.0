From: akpm@linux-foundation.org
Subject: + conditionally-define-u32_max.patch added to -mm tree
Date: Thu, 26 Dec 2013 14:34:45 -0800
Message-ID: <52bcaf05.ay0BCrA66MTcLM6V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3LZWeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Dec 2013 17:34:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sage@inktank.com, elder@linaro.org, davem@davemloft.net, alex.elder@linaro.org

Subject: + conditionally-define-u32_max.patch added to -mm tree
To: alex.elder@linaro.org,davem@davemloft.net,elder@linaro.org,sage@inktank.com
From: akpm@linux-foundation.org
Date: Thu, 26 Dec 2013 14:34:45 -0800


The patch titled
     Subject: conditionally define U32_MAX
has been added to the -mm tree.  Its filename is
     conditionally-define-u32_max.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/conditionally-define-u32_max.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/conditionally-define-u32_max.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Elder <alex.elder@linaro.org>
Subject: conditionally define U32_MAX

The symbol U32_MAX is defined in several spots.  Change these definitions
to be conditional.  This is in preparation for the next patch, which
centralizes the definition in <linux/kernel.h>.

Signed-off-by: Alex Elder <elder@linaro.org>
Cc: Sage Weil <sage@inktank.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/reiserfs.h      |    2 ++
 include/linux/ceph/decode.h |    2 ++
 net/ipv4/tcp_illinois.c     |    2 ++
 3 files changed, 6 insertions(+)

diff -puN fs/reiserfs/reiserfs.h~conditionally-define-u32_max fs/reiserfs/reiserfs.h
--- a/fs/reiserfs/reiserfs.h~conditionally-define-u32_max
+++ a/fs/reiserfs/reiserfs.h
@@ -1958,7 +1958,9 @@ struct treepath var = {.path_length = IL
 #define MAX_US_INT 0xffff
 
 // reiserfs version 2 has max offset 60 bits. Version 1 - 32 bit offset
+#ifndef U32_MAX
 #define U32_MAX (~(__u32)0)
+#endif /* !U32_MAX */
 
 static inline loff_t max_reiserfs_offset(struct inode *inode)
 {
diff -puN include/linux/ceph/decode.h~conditionally-define-u32_max include/linux/ceph/decode.h
--- a/include/linux/ceph/decode.h~conditionally-define-u32_max
+++ a/include/linux/ceph/decode.h
@@ -10,6 +10,7 @@
 
 /* This seemed to be the easiest place to define these */
 
+#ifndef U32_MAX
 #define	U8_MAX	((u8)(~0U))
 #define	U16_MAX	((u16)(~0U))
 #define	U32_MAX	((u32)(~0U))
@@ -24,6 +25,7 @@
 #define	S16_MIN	((s16)(-S16_MAX - 1))
 #define	S32_MIN	((s32)(-S32_MAX - 1))
 #define	S64_MIN	((s64)(-S64_MAX - 1LL))
+#endif /* !U32_MAX */
 
 /*
  * in all cases,
diff -puN net/ipv4/tcp_illinois.c~conditionally-define-u32_max net/ipv4/tcp_illinois.c
--- a/net/ipv4/tcp_illinois.c~conditionally-define-u32_max
+++ a/net/ipv4/tcp_illinois.c
@@ -23,7 +23,9 @@
 #define ALPHA_MIN	((3*ALPHA_SCALE)/10)	/* ~0.3 */
 #define ALPHA_MAX	(10*ALPHA_SCALE)	/* 10.0 */
 #define ALPHA_BASE	ALPHA_SCALE		/* 1.0 */
+#ifndef U32_MAX
 #define U32_MAX		((u32)~0U)
+#endif /* !U32_MAX */
 #define RTT_MAX		(U32_MAX / ALPHA_MAX)	/* 3.3 secs */
 
 #define BETA_SHIFT	6
_

Patches currently in -mm which might be from alex.elder@linaro.org are

conditionally-define-u32_max.patch
kernelh-define-u8-s8-u32-etc-limits.patch
remove-extra-definitions-of-u32_max.patch
linux-next.patch

