From: akpm@linux-foundation.org
Subject: [merged] vsprintf-use-warn_on_once.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:45:30 -0700
Message-ID: <200909222045.n8MKjUKi015824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbZIVUp2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:45:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, fweisbec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vsprintf: use WARN_ON_ONCE
has been removed from the -mm tree.  Its filename was
     vsprintf-use-warn_on_once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1092,13 +1092,8 @@ int vsnprintf(char *buf, size_t size, co
 
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
@@ -1544,13 +1539,8 @@ int bstr_printf(char *buf, size_t size, 
 
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

origin.patch
linux-next.patch
ia64-use-printk_once.patch
ide-use-printk_once.patch
cciss-fix-schedule_timeout-parameters.patch

