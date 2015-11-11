From: akpm@linux-foundation.org
Subject: [merged]
 lib-string-add-ull-suffix-to-the-constant-definition.patch removed from -mm tree
Date: Wed, 11 Nov 2015 11:48:11 -0800
Message-ID: <56439b7b.miKJtDsOmNHpuVyD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbbKKTsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string.c: add ULL suffix to the constant definition
has been removed from the -mm tree.  Its filename was
     lib-string-add-ull-suffix-to-the-constant-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


