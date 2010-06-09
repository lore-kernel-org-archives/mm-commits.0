From: akpm@linux-foundation.org
Subject: + kernelh-remove-unused-nipquad-and-nipquad_fmt.patch added to -mm tree
Date: Wed, 09 Jun 2010 15:47:35 -0700
Message-ID: <201006092247.o59MlZL7026291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756316Ab0FIWrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jun 2010 18:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, davem@davemloft.net


The patch titled
     kernel.h: remove unused NIPQUAD and NIPQUAD_FMT
has been added to the -mm tree.  Its filename is
     kernelh-remove-unused-nipquad-and-nipquad_fmt.patch

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
Subject: kernel.h: remove unused NIPQUAD and NIPQUAD_FMT
From: Joe Perches <joe@perches.com>

There are no more uses of NIPQUAD or NIPQUAD_FMT.  Remove the definitions.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN include/linux/kernel.h~kernelh-remove-unused-nipquad-and-nipquad_fmt include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-remove-unused-nipquad-and-nipquad_fmt
+++ a/include/linux/kernel.h
@@ -609,17 +609,6 @@ static inline void ftrace_dump(enum ftra
 #endif /* CONFIG_TRACING */
 
 /*
- *      Display an IP address in readable format.
- */
-
-#define NIPQUAD(addr) \
-	((unsigned char *)&addr)[0], \
-	((unsigned char *)&addr)[1], \
-	((unsigned char *)&addr)[2], \
-	((unsigned char *)&addr)[3]
-#define NIPQUAD_FMT "%u.%u.%u.%u"
