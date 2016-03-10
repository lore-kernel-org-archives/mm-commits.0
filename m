From: akpm@linux-foundation.org
Subject: [alternative-merged]
 linux-compilerh-fix-stale-comment-on-readwrite_once.patch removed from -mm
 tree
Date: Thu, 10 Mar 2016 14:43:57 -0800
Message-ID: <56e1f8ad.lr8mtMSE9Bo62tFK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbcCJWn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 17:43:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, borntraeger@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/compiler.h: fix stale comment on {READ,WRITE}_ONCE
has been removed from the -mm tree.  Its filename was
     linux-compilerh-fix-stale-comment-on-readwrite_once.patch

This patch was dropped because an alternative patch was merged

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


