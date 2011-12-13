From: akpm@linux-foundation.org
Subject: [alternative-merged] include-log2h-fix-rounddown_pow_of_two1.patch removed from -mm tree
Date: Tue, 13 Dec 2011 11:18:42 -0800
Message-ID: <201112131918.pBDJIhNG022590@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:39317 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab1LMTSs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Dec 2011 14:18:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreiw@vmware.com, dtor@vmware.com, eike-kernel@sf-tec.de, jj@chaosbits.net, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/log2.h: fix rounddown_pow_of_two(1)
has been removed from the -mm tree.  Its filename was
     include-log2h-fix-rounddown_pow_of_two1.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrei Warkentin <andreiw@vmware.com>
Subject: include/log2.h: fix rounddown_pow_of_two(1)

1 is a power of two, therefore rounddown_pow_of_two(1) should return 1. 
It does in case the argument is a variable but in case it's a constant it
behaves wrong and returns 0.  Probably nobody ever did it so this was
never noticed, however net/drivers/vmxnet3 with latest GCC does and breaks
on unicpu systems.

This is similar to Rolf's patch to roundup_pow_of_two(1).

Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/log2.h~include-log2h-fix-rounddown_pow_of_two1 include/linux/log2.h
--- a/include/linux/log2.h~include-log2h-fix-rounddown_pow_of_two1
+++ a/include/linux/log2.h
@@ -185,7 +185,7 @@ unsigned long __rounddown_pow_of_two(uns
 #define rounddown_pow_of_two(n)			\
 (						\
 	__builtin_constant_p(n) ? (		\
-		(n == 1) ? 0 :			\
+		(n == 1) ? 1 :			\
 		(1UL << ilog2(n))) :		\
 	__rounddown_pow_of_two(n)		\
  )
_

Patches currently in -mm which might be from andreiw@vmware.com are


