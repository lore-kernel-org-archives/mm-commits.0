From: akpm@linux-foundation.org
Subject: [merged] make-sure-the-value-in-abs-does-not-get-truncated-if-it-is-greater-than-232.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:53:26 -0700
Message-ID: <200909231953.n8NJrQZ1031170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbZIWTyC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:54:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eike-kernel@sf-tec.de, mm-commits@vger.kernel.org


The patch titled
     Make sure the value in abs() does not get truncated if it is greater than 2^32
has been removed from the -mm tree.  Its filename was
     make-sure-the-value-in-abs-does-not-get-truncated-if-it-is-greater-than-232.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Make sure the value in abs() does not get truncated if it is greater than 2^32
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

abs() will truncate the input if is it outside the 2^32 range.  Fix that
by assuming `long' input.

This might generate worse code in the common case.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kernel.h~make-sure-the-value-in-abs-does-not-get-truncated-if-it-is-greater-than-232 include/linux/kernel.h
--- a/include/linux/kernel.h~make-sure-the-value-in-abs-does-not-get-truncated-if-it-is-greater-than-232
+++ a/include/linux/kernel.h
@@ -146,7 +146,7 @@ extern int _cond_resched(void);
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
 #define abs(x) ({				\
-		int __x = (x);			\
+		long __x = (x);			\
 		(__x < 0) ? -__x : __x;		\
 	})
 
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are

origin.patch

