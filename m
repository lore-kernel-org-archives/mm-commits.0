From: akpm@linux-foundation.org
Subject: + vsprintf-use-warn_on_once.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:25:37 -0700
Message-ID: <200908242125.n7OLPbZK030585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753501AbZHXVZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:25:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, fweisbec@gmail.com


The patch titled
     vsprintf: use WARN_ON_ONCE
has been added to the -mm tree.  Its filename is
     vsprintf-use-warn_on_once.patch

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
Subject: vsprintf: use WARN_ON_ONCE
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-use-warn_on_once lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-use-warn_on_once
+++ a/lib/vsprintf.c
@@ -983,13 +983,8 @@ int vsnprintf(char *buf, size_t size, co
 
 	/* Reject out-of-range values early.  Large positive sizes are
 	   used for unknown buffer sizes. */
-	if (unlikely((int) size < 0)) {
-		/* There can be only one.. */
-		static char warn = 1;
-		WARN_ON(warn);
-		warn = 0;
+	if (WARN_ON_ONCE((int) size < 0))
 		return 0;
-	}
 
 	str = buf;
 	end = buf + size;
@@ -1439,13 +1434,8 @@ int bstr_printf(char *buf, size_t size, 
 
 	struct printf_spec spec = {0};
 
-	if (unlikely((int) size < 0)) {
-		/* There can be only one.. */
-		static char warn = 1;
-		WARN_ON(warn);
-		warn = 0;
+	if (WARN_ON_ONCE((int) size < 0))
 		return 0;
-	}
 
 	str = buf;
 	end = buf + size;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

linux-next.patch
alpha-use-printk_once.patch
ia64-use-printk_once.patch
ata-use-printk_once.patch
ide-use-printk_once.patch
vsprintf-use-warn_on_once.patch

