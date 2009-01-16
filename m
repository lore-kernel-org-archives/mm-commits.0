From: akpm@linux-foundation.org
Subject: + generic-swap-dont-return-a-value-from-swap.patch added to -mm tree
Date: Fri, 16 Jan 2009 14:27:48 -0800
Message-ID: <200901162227.n0GMRmI8016163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760285AbZAPW2L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 17:28:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, a.p.zijlstra@chello.nl, wfg@linux.intel.com


The patch titled
     generic swap(): don't return a value from swap()
has been added to the -mm tree.  Its filename is
     generic-swap-dont-return-a-value-from-swap.patch

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
Subject: generic swap(): don't return a value from swap()
From: Peter Zijlstra <peterz@infradead.org>

The swap() macro is accidentally retuning the value of its first argument.
Change it into a doesn't-return-anything macro before someone goes and
relies upon this behaviour.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <wfg@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/kernel.h~generic-swap-dont-return-a-value-from-swap include/linux/kernel.h
--- a/include/linux/kernel.h~generic-swap-dont-return-a-value-from-swap
+++ a/include/linux/kernel.h
@@ -480,7 +480,8 @@ static inline char *pack_hex_byte(char *
 /*
  * swap - swap value of @a and @b
  */
-#define swap(a, b) ({ typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; })
+#define swap(a, b) \
+	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
 /**
  * container_of - cast a member of a structure out to the containing structure
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch
generic-swap-dont-return-a-value-from-swap.patch

