From: akpm@linux-foundation.org
Subject: + make-sure-the-value-in-abs-does-not-get-truncated-if-it-is-greater-than-232.patch added to -mm tree
Date: Thu, 10 Sep 2009 13:41:02 -0700
Message-ID: <200909102041.n8AKf3Vb029280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbZIJUla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Sep 2009 16:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eike-kernel@sf-tec.de


The patch titled
     Make sure the value in abs() does not get truncated if it is greater than 2^32
has been added to the -mm tree.  Its filename is
     make-sure-the-value-in-abs-does-not-get-truncated-if-it-is-greater-than-232.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -145,7 +145,7 @@ extern int _cond_resched(void);
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
 #define abs(x) ({				\
-		int __x = (x);			\
+		long __x = (x);			\
 		(__x < 0) ? -__x : __x;		\
 	})
 
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are

make-sure-the-value-in-abs-does-not-get-truncated-if-it-is-greater-than-232.patch

