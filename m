From: akpm@linux-foundation.org
Subject: + vsprintf-neaten-%pk-kptr_restrict-save-a-bit-of-code-space.patch added to -mm tree
Date: Wed, 19 Jan 2011 14:50:29 -0800
Message-ID: <201101192250.p0JMoTGA008194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421Ab1ASWub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 17:50:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, drosenberg@vsecurity.com


The patch titled
     vsprintf: neaten %pK kptr_restrict, save a bit of code space
has been added to the -mm tree.  Its filename is
     vsprintf-neaten-%pk-kptr_restrict-save-a-bit-of-code-space.patch

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
Subject: vsprintf: neaten %pK kptr_restrict, save a bit of code space
From: Joe Perches <joe@perches.com>

If kptr restrictions are on, just set the passed pointer to NULL.

$ size lib/vsprintf.o.*
   text	   data	    bss	    dec	    hex	filename
   8247	      4	      2	   8253	   203d	lib/vsprintf.o.new
   8282	      4	      2	   8288	   2060	lib/vsprintf.o.old

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-neaten-%pk-kptr_restrict-save-a-bit-of-code-space lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-neaten-%pk-kptr_restrict-save-a-bit-of-code-space
+++ a/lib/vsprintf.c
@@ -1047,16 +1047,12 @@ char *pointer(const char *fmt, char *buf
 			if (spec.field_width == -1)
 				spec.field_width = 2 * sizeof(void *);
 			return string(buf, end, "pK-error", spec);
-		} else if ((kptr_restrict == 0) ||
-			 (kptr_restrict == 1 &&
-			  has_capability_noaudit(current, CAP_SYSLOG)))
-			break;
