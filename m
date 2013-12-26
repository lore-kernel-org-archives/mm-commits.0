From: akpm@linux-foundation.org
Subject: + kernelh-define-u8-s8-u32-etc-limits.patch added to -mm tree
Date: Thu, 26 Dec 2013 14:34:46 -0800
Message-ID: <52bcaf06.z5mvF+d5UHg42/gw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3LZWer (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Dec 2013 17:34:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sage@inktank.com, elder@linaro.org, davem@davemloft.net, alex.elder@linaro.org

Subject: + kernelh-define-u8-s8-u32-etc-limits.patch added to -mm tree
To: alex.elder@linaro.org,davem@davemloft.net,elder@linaro.org,sage@inktank.com
From: akpm@linux-foundation.org
Date: Thu, 26 Dec 2013 14:34:46 -0800


The patch titled
     Subject: kernel.h: define u8, s8, u32, etc. limits
has been added to the -mm tree.  Its filename is
     kernelh-define-u8-s8-u32-etc-limits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernelh-define-u8-s8-u32-etc-limits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernelh-define-u8-s8-u32-etc-limits.patch

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

conditionally-define-u32_max.patch
kernelh-define-u8-s8-u32-etc-limits.patch
remove-extra-definitions-of-u32_max.patch
linux-next.patch

