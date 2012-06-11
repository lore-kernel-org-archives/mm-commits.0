From: akpm@linux-foundation.org
Subject: + include-linux-bitopsh-fix-warning.patch added to -mm tree
Date: Mon, 11 Jun 2012 15:59:42 -0700
Message-ID: <20120611225942.8BB84A026F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:44494 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab2FKW7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 18:59:43 -0400
Received: by yenl3 with SMTP id l3so424637yen.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 15:59:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com


The patch titled
     Subject: include/linux/bitops.h: fix warning
has been added to the -mm tree.  Its filename is
     include-linux-bitopsh-fix-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: include/linux/bitops.h: fix warning

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
Subject: Subject: include/linux/bitops.h: fix warning

Patches currently in -mm which might be from linkinjeon@gmail.com are

drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch
ufs-fix-incorrect-return-value-about-success-and-failed.patch
include-linux-bitopsh-fix-warning.patch
hfsplus-use-enomem-when-kzalloc-fails.patch

