From: akpm@linux-foundation.org
Subject: [to-be-updated]
 byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix.patch removed from
 -mm tree
Date: Mon, 02 May 2016 15:10:07 -0700
Message-ID: <5727d03f.d90RnDO4fzUNo5aO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbcEBWKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 May 2016 18:10:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpoimboe@redhat.com, arnd@arndb.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix
has been removed from the -mm tree.  Its filename was
     byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix

We probably need to add a (__u64) cast to the return value of
__builtin_bswap64(), like:

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/swab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/uapi/linux/swab.h~byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix include/uapi/linux/swab.h
--- a/include/uapi/linux/swab.h~byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix
+++ a/include/uapi/linux/swab.h
@@ -123,7 +123,7 @@ static inline __attribute_const__ __u32
  * @x: value to byteswap
  */
 #ifdef __HAVE_BUILTIN_BSWAP64__
-#define __swab64(x) __builtin_bswap64((__u64)(x))
+#define __swab64(x) (__u64)__builtin_bswap64((__u64)(x))
 #else
 #define __swab64(x)				\
 	(__builtin_constant_p((__u64)(x)) ?	\
_

Patches currently in -mm which might be from jpoimboe@redhat.com are


