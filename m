From: akpm@linux-foundation.org
Subject: [merged] include-linux-math64h-add-div64_ul.patch removed from
 -mm tree
Date: Thu, 13 Jun 2013 11:58:14 -0700
Message-ID: <51ba1646.nbTQy26Ye5Rb0hP4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab3FMS6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:58:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@elte.hu, alex.shi@intel.com

Subject: [merged] include-linux-math64h-add-div64_ul.patch removed from -mm tree
To: alex.shi@intel.com,mingo@elte.hu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:58:14 -0700


The patch titled
     Subject: include/linux/math64.h: add div64_ul()
has been removed from the -mm tree.  Its filename was
     include-linux-math64h-add-div64_ul.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@intel.com>
Subject: include/linux/math64.h: add div64_ul()

There is div64_long() to handle the s64/long division, but no mocro do
u64/ul division.  It is necessary in some scenarios, so add this function.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/math64.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/math64.h~include-linux-math64h-add-div64_ul include/linux/math64.h
--- a/include/linux/math64.h~include-linux-math64h-add-div64_ul
+++ a/include/linux/math64.h
@@ -6,7 +6,8 @@
 
 #if BITS_PER_LONG == 64
 
-#define div64_long(x,y) div64_s64((x),(y))
+#define div64_long(x, y) div64_s64((x), (y))
+#define div64_ul(x, y)   div64_u64((x), (y))
 
 /**
  * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
@@ -47,7 +48,8 @@ static inline s64 div64_s64(s64 dividend
 
 #elif BITS_PER_LONG == 32
 
-#define div64_long(x,y) div_s64((x),(y))
+#define div64_long(x, y) div_s64((x), (y))
+#define div64_ul(x, y)   div_u64((x), (y))
 
 #ifndef div_u64_rem
 static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
_

Patches currently in -mm which might be from alex.shi@intel.com are

origin.patch
linux-next.patch

