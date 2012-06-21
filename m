From: akpm@linux-foundation.org
Subject: [withdrawn] include-linux-bitopsh-fix-warning.patch removed from -mm tree
Date: Thu, 21 Jun 2012 14:31:15 -0700
Message-ID: <20120621213115.A473EA0329@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36149 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2FUVbQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 17:31:16 -0400
Received: by ggeh3 with SMTP id h3so121304gge.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 14:31:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkinjeon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/bitops.h: fix warning
has been removed from the -mm tree.  Its filename was
     include-linux-bitopsh-fix-warning.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: include/linux/bitops.h: fix warning

include/linux/bitops.h: In function 'hweight_long':
include/linux/bitops.h:49: warning: signed and unsigned type in conditional expression

The compile warning is caused by __const_hweight8 when using hweight_long
with -Wsign-compare option.  The reason is that the default return value
of this macro is signed.  So need type casting to remove warning.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/const_hweight.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/bitops/const_hweight.h~include-linux-bitopsh-fix-warning include/asm-generic/bitops/const_hweight.h
--- a/include/asm-generic/bitops/const_hweight.h~include-linux-bitopsh-fix-warning
+++ a/include/asm-generic/bitops/const_hweight.h
@@ -4,7 +4,7 @@
 /*
  * Compile time versions of __arch_hweightN()
  */
-#define __const_hweight8(w)		\
+#define __const_hweight8(w)	(unsigned long)	\
       (	(!!((w) & (1ULL << 0))) +	\
 	(!!((w) & (1ULL << 1))) +	\
 	(!!((w) & (1ULL << 2))) +	\
_

Patches currently in -mm which might be from linkinjeon@gmail.com are

linux-next.patch
drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch
ufs-fix-incorrect-return-value-about-success-and-failed.patch
hfsplus-use-enomem-when-kzalloc-fails.patch

