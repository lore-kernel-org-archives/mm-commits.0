From: akpm@linux-foundation.org
Subject: + include-linux-math64h-add-div64_ul.patch added to -mm tree
Date: Mon, 10 Jun 2013 15:31:18 -0700
Message-ID: <51b653b6.0J5c/EiPzpm8GxO2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3FJWbT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 18:31:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@elte.hu, alex.shi@intel.com

Subject: + include-linux-math64h-add-div64_ul.patch added to -mm tree
To: alex.shi@intel.com,mingo@elte.hu
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 15:31:18 -0700


The patch titled
     Subject: include/linux/math64.h: add div64_ul()
has been added to the -mm tree.  Its filename is
     include-linux-math64h-add-div64_ul.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@intel.com>
Subject: include/linux/math64.h: add div64_ul()

There is div64_long() to handle the s64/long division, but no mocro do
u64/ul division.  It is necessary in some scenarios, so add this function.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/math64.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/math64.h~include-linux-math64h-add-div64_ul include/linux/math64.h
--- a/include/linux/math64.h~include-linux-math64h-add-div64_ul
+++ a/include/linux/math64.h
@@ -7,6 +7,7 @@
 #if BITS_PER_LONG == 64
 
 #define div64_long(x,y) div64_s64((x),(y))
+#define div64_ul(x,y)   div64_u64((x),(y))
 
 /**
  * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
@@ -48,6 +49,7 @@ static inline s64 div64_s64(s64 dividend
 #elif BITS_PER_LONG == 32
 
 #define div64_long(x,y) div_s64((x),(y))
+#define div64_ul(x,y)   div_u64((x),(y))
 
 #ifndef div_u64_rem
 static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
_

Patches currently in -mm which might be from alex.shi@intel.com are

linux-next.patch
include-linux-math64h-add-div64_ul.patch

