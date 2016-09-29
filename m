From: akpm@linux-foundation.org
Subject: + include-linux-propertyh-fix-typo-compile-error.patch added to
 -mm tree
Date: Thu, 29 Sep 2016 14:12:22 -0700
Message-ID: <57ed83b6.8RLd2iEGLQfrdVnd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46671 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933484AbcI2VMc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2016 17:12:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnyoun@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/property.h: fix typo/compile error
has been added to the -mm tree.  Its filename is
     include-linux-propertyh-fix-typo-compile-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-propertyh-fix-typo-compile-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-propertyh-fix-typo-compile-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Youn <johnyoun@synopsys.com>
Subject: include/linux/property.h: fix typo/compile error

This fixes commit d76eebfa175e ("include/linux/property.h: fix build
issues with gcc-4.4.4").

With that commit we get the following compile error when using the
PROPERTY_ENTRY_INTEGER_ARRAY macro.

../include/linux/property.h:201:39: error: `u32_data' undeclared (first
                 use in this function)
  PROPERTY_ENTRY_INTEGER_ARRAY(_name_, u32, _val_)
                                       ^
../include/linux/property.h:193:17: note: in definition of macro
                 `PROPERTY_ENTRY_INTEGER_ARRAY'
  { .pointer = { _type_##_data = _val_ } },  \
                 ^

This needs a '.' to reference the union member. It seems this was just
overlooked here since it is done correctly in similar constructs in
other parts of the original commit.

This fix is in preparation of upcoming commits that will use this macro.

Fixes: commit d76eebfa175e ("include/linux/property.h: fix build issues with gcc-4.4.4")
Link: http://lkml.kernel.org/r/2de3b929290d88a723ed829a3e3cbd02044714df.1475114627.git.johnyoun@synopsys.com
Signed-off-by: John Youn <johnyoun@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/property.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/property.h~include-linux-propertyh-fix-typo-compile-error include/linux/property.h
--- a/include/linux/property.h~include-linux-propertyh-fix-typo-compile-error
+++ a/include/linux/property.h
@@ -190,7 +190,7 @@ struct property_entry {
 	.length = ARRAY_SIZE(_val_) * sizeof(_type_),		\
 	.is_array = true,					\
 	.is_string = false,					\
-	{ .pointer = { _type_##_data = _val_ } },		\
+	{ .pointer = { ._type_##_data = _val_ } },		\
 }
 
 #define PROPERTY_ENTRY_U8_ARRAY(_name_, _val_)			\
_

Patches currently in -mm which might be from johnyoun@synopsys.com are

include-linux-propertyh-fix-typo-compile-error.patch

