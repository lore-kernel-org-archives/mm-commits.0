From: akpm@linux-foundation.org
Subject: [merged] rbtree-include-linux-compilerh-for-definition-of-__always_inline.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:50:01 -0700
Message-ID: <20121029195001.C98EA1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:36994 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab2J2TuD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:50:03 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so375916qae.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:50:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, mingo@elte.hu, penberg@kernel.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: include linux/compiler.h for definition of __always_inline
has been removed from the -mm tree.  Its filename was
     rbtree-include-linux-compilerh-for-definition-of-__always_inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Michel Lespinasse <walken@google.com>
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

linux-next.patch

