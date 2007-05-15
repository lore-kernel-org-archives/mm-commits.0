From: akpm@linux-foundation.org
Subject: - h8300-atomich-update.patch removed from -mm tree
Date: Tue, 15 May 2007 11:07:04 -0700
Message-ID: <200705151807.l4FI73De014141@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53324 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755049AbXEOSHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 14:07:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300 atomic.h update
has been removed from the -mm tree.  Its filename was
     h8300-atomich-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: h8300 atomic.h update
From: Yoshinori Sato <ysato@users.sourceforge.jp>

add atomic_sub_and_test define.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-h8300/atomic.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-h8300/atomic.h~h8300-atomich-update include/asm-h8300/atomic.h
--- a/include/asm-h8300/atomic.h~h8300-atomich-update
+++ a/include/asm-h8300/atomic.h
@@ -37,6 +37,7 @@ static __inline__ int atomic_sub_return(
 }
 
 #define atomic_sub(i, v) atomic_sub_return(i, v)
+#define atomic_sub_and_test(i,v) (atomic_sub_return(i, v) == 0)
 
 static __inline__ int atomic_inc_return(atomic_t *v)
 {
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

origin.patch
