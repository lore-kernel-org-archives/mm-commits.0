From: akpm@linux-foundation.org
Subject: + h8300-atomich-update.patch added to -mm tree
Date: Mon, 14 May 2007 11:54:23 -0700
Message-ID: <200705141854.l4EIsNip023492@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbXENSy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 14:54:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ysato@users.sourceforge.jp


The patch titled
     h8300 atomic.h update
has been added to the -mm tree.  Its filename is
     h8300-atomich-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: h8300 atomic.h update
From: Yoshinori Sato <ysato@users.sourceforge.jp>

add atomic_sub_and_test define.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-h8300/atomic.h |    1 +
 1 files changed, 1 insertion(+)

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

h8300-atomich-update.patch
