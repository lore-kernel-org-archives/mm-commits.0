From: akpm@linux-foundation.org
Subject: + linux-compilerh-fix-stale-comment-on-readwrite_once.patch added to -mm tree
Date: Thu, 10 Mar 2016 14:08:48 -0800
Message-ID: <56e1f070./fD/FZLxM6NH7kcx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453AbcCJWIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 17:08:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, borntraeger@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/compiler.h: fix stale comment on {READ,WRITE}_ONCE
has been added to the -mm tree.  Its filename is
     linux-compilerh-fix-stale-comment-on-readwrite_once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-compilerh-fix-stale-comment-on-readwrite_once.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-compilerh-fix-stale-comment-on-readwrite_once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: linux/compiler.h: fix stale comment on {READ,WRITE}_ONCE

Commit 7bd3e239d6c6 ("locking: Remove atomicy checks from
{READ,WRITE}_ONCE") removed said warning.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/compiler.h~linux-compilerh-fix-stale-comment-on-readwrite_once include/linux/compiler.h
--- a/include/linux/compiler.h~linux-compilerh-fix-stale-comment-on-readwrite_once
+++ a/include/linux/compiler.h
@@ -263,8 +263,7 @@ static __always_inline void __write_once
  * In contrast to ACCESS_ONCE these two macros will also work on aggregate
  * data types like structs or unions. If the size of the accessed data
  * type exceeds the word size of the machine (e.g., 32 bits or 64 bits)
- * READ_ONCE() and WRITE_ONCE()  will fall back to memcpy and print a
- * compile-time warning.
+ * READ_ONCE() and WRITE_ONCE()  will fall back to memcpy.
  *
  * Their two major use cases are: (1) Mediating communication between
  * process-level code and irq/NMI handlers, all running on the same CPU,
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-compilerh-fix-stale-comment-on-readwrite_once.patch

