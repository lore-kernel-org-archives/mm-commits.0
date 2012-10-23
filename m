From: akpm@linux-foundation.org
Subject: + rbtree-include-linux-compilerh-for-definition-of-__always_inline.patch added to -mm tree
Date: Tue, 23 Oct 2012 12:12:04 -0700
Message-ID: <20121023191205.1610A5C0066@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:64908 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab2JWTMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 15:12:08 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so238672wib.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 12:12:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.deacon@arm.com, mingo@elte.hu, penberg@kernel.org, walken@google.com


The patch titled
     Subject: rbtree: include linux/compiler.h for definition of __always_inline
has been added to the -mm tree.  Its filename is
     rbtree-include-linux-compilerh-for-definition-of-__always_inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: rbtree: include linux/compiler.h for definition of __always_inline

rb_erase_augmented() is a static function annotated with __always_inline. 
This causes a compile failure when attempting to use the rbtree
implementation as a library (e.g.  kvm tool):

rbtree_augmented.h:125:24: error: expected `=', `,', `;', `asm' or `__attribute__' before `void'

Include linux/compiler.h in rbtree_augmented.h so that the __always_inline
macro is resolved correctly.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree_augmented.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/rbtree_augmented.h~rbtree-include-linux-compilerh-for-definition-of-__always_inline include/linux/rbtree_augmented.h
--- a/include/linux/rbtree_augmented.h~rbtree-include-linux-compilerh-for-definition-of-__always_inline
+++ a/include/linux/rbtree_augmented.h
@@ -24,6 +24,7 @@
 #ifndef _LINUX_RBTREE_AUGMENTED_H
 #define _LINUX_RBTREE_AUGMENTED_H
 
+#include <linux/compiler.h>
 #include <linux/rbtree.h>
 
 /*
_

Patches currently in -mm which might be from will.deacon@arm.com are

rbtree-include-linux-compilerh-for-definition-of-__always_inline.patch
linux-next.patch

