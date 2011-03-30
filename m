From: akpm@linux-foundation.org
Subject: + documentation-atomic_opstxt-avoid-volatile-in-sample-code.patch added to -mm tree
Date: Wed, 30 Mar 2011 14:18:34 -0700
Message-ID: <201103302118.p2ULIYs7010405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933632Ab1C3VTH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 17:19:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@suse.de


The patch titled
     Documentation/atomic_ops.txt: avoid volatile in sample code
has been added to the -mm tree.  Its filename is
     documentation-atomic_opstxt-avoid-volatile-in-sample-code.patch

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
Subject: Documentation/atomic_ops.txt: avoid volatile in sample code
From: Nikanth Karthikesan <knikanth@suse.de>

As declaring counter as volatile is discouraged, it is best not to use it
in sample code as well.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/atomic_ops.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/atomic_ops.txt~documentation-atomic_opstxt-avoid-volatile-in-sample-code Documentation/atomic_ops.txt
--- a/Documentation/atomic_ops.txt~documentation-atomic_opstxt-avoid-volatile-in-sample-code
+++ a/Documentation/atomic_ops.txt
@@ -12,7 +12,7 @@ Also, it should be made opaque such that
 C integer type will fail.  Something like the following should
 suffice:
 
-	typedef struct { volatile int counter; } atomic_t;
+	typedef struct { int counter; } atomic_t;
 
 Historically, counter has been declared volatile.  This is now discouraged.
 See Documentation/volatile-considered-harmful.txt for the complete rationale.
_

Patches currently in -mm which might be from knikanth@suse.de are

documentation-atomic_opstxt-avoid-volatile-in-sample-code.patch

