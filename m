From: akpm@linux-foundation.org
Subject: [merged] kernelh-define-u8-s8-u32-etc-limits.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 11:00:23 -0800
Message-ID: <52e2b847.wPv3zzJ2ym7iMAvN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sage@inktank.com, elder@linaro.org, davem@davemloft.net, alex.elder@linaro.org

Subject: [merged] kernelh-define-u8-s8-u32-etc-limits.patch removed from -mm tree
To: alex.elder@linaro.org,davem@davemloft.net,elder@linaro.org,sage@inktank.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:23 -0800


The patch titled
     Subject: kernel.h: define u8, s8, u32, etc. limits
has been removed from the -mm tree.  Its filename was
     kernelh-define-u8-s8-u32-etc-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Elder <alex.elder@linaro.org>
Subject: kernel.h: define u8, s8, u32, etc. limits

Create constants that define the maximum and minimum values
representable by the kernel types u8, s8, u16, s16, and so on.

Signed-off-by: Alex Elder <elder@linaro.org>
Cc: Sage Weil <sage@inktank.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN include/linux/kernel.h~kernelh-define-u8-s8-u32-etc-limits include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-define-u8-s8-u32-etc-limits
+++ a/include/linux/kernel.h
@@ -29,6 +29,19 @@
 #define ULLONG_MAX	(~0ULL)
 #define SIZE_MAX	(~(size_t)0)
 
+#define U8_MAX		((u8)~0U)
+#define S8_MAX		((s8)(U8_MAX>>1))
+#define S8_MIN		((s8)(-S8_MAX - 1))
+#define U16_MAX		((u16)~0U)
+#define S16_MAX		((s16)(U16_MAX>>1))
+#define S16_MIN		((s16)(-S16_MAX - 1))
+#define U32_MAX		((u32)~0U)
+#define S32_MAX		((s32)(U32_MAX>>1))
+#define S32_MIN		((s32)(-S32_MAX - 1))
+#define U64_MAX		((u64)~0ULL)
+#define S64_MAX		((s64)(U64_MAX>>1))
+#define S64_MIN		((s64)(-S64_MAX - 1))
+
 #define STACK_MAGIC	0xdeadbeef
 
 #define REPEAT_BYTE(x)	((~0ul / 0xff) * (x))
_

Patches currently in -mm which might be from alex.elder@linaro.org are

origin.patch
linux-next.patch

