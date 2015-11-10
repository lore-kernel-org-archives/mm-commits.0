From: akpm@linux-foundation.org
Subject: + lib-string-add-ull-suffix-to-the-constant-definition.patch
 added to -mm tree
Date: Tue, 10 Nov 2015 12:58:02 -0800
Message-ID: <56425a5a.a4PHueuhMQeJVEx0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbbKJU6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:58:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string.c: add ULL suffix to the constant definition
has been added to the -mm tree.  Its filename is
     lib-string-add-ull-suffix-to-the-constant-definition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string-add-ull-suffix-to-the-constant-definition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string-add-ull-suffix-to-the-constant-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/string.c: add ULL suffix to the constant definition

8-byte constant is too big for long and compiler complains about this.

lib/string.c:907:20: warning: constant 0x0101010101010101 is so big it is long

Append ULL suffix to explicitly show its type.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/string.c~lib-string-add-ull-suffix-to-the-constant-definition lib/string.c
--- a/lib/string.c~lib-string-add-ull-suffix-to-the-constant-definition
+++ a/lib/string.c
@@ -904,7 +904,7 @@ void *memchr_inv(const void *start, int
 
 	value64 = value;
 #if defined(CONFIG_ARCH_HAS_FAST_MULTIPLIER) && BITS_PER_LONG == 64
-	value64 *= 0x0101010101010101;
+	value64 *= 0x0101010101010101ULL;
 #elif defined(CONFIG_ARCH_HAS_FAST_MULTIPLIER)
 	value64 *= 0x01010101;
 	value64 |= value64 << 32;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string-add-ull-suffix-to-the-constant-definition.patch

