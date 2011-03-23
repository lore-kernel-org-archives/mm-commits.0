From: akpm@linux-foundation.org
Subject: [merged] vsprintf-neaten-%pk-kptr_restrict-save-a-bit-of-code-space.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:19 -0700
Message-ID: <201103232042.p2NKgtx9028811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933407Ab1CWUn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:43:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, drosenberg@vsecurity.com, mm-commits@vger.kernel.org


The patch titled
     vsprintf: neaten %pK kptr_restrict, save a bit of code space
has been removed from the -mm tree.  Its filename was
     vsprintf-neaten-%pk-kptr_restrict-save-a-bit-of-code-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
