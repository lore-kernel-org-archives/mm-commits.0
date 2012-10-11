From: akpm@linux-foundation.org
Subject: [merged] lib-kasprintfc-use-kmalloc_track_caller-to-get-accurate-traces-for-kvasprintf.patch removed from -mm tree
Date: Thu, 11 Oct 2012 13:59:12 -0700
Message-ID: <20121011205913.34DC020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:63341 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2JKU7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 16:59:14 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so143202wib.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 13:59:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elezegarcia@gmail.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/kasprintf.c: use kmalloc_track_caller() to get accurate traces for kvasprintf
has been removed from the -mm tree.  Its filename was
     lib-kasprintfc-use-kmalloc_track_caller-to-get-accurate-traces-for-kvasprintf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: lib/kasprintf.c: use kmalloc_track_caller() to get accurate traces for kvasprintf

Previously kvasprintf() allocation was being done through kmalloc(), thus
producing an inaccurate trace report.

This is a common problem: in order to get accurate callsite tracing, a
lib/utils function shouldn't allocate kmalloc but instead use
kmalloc_track_caller.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kasprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/kasprintf.c~lib-kasprintfc-use-kmalloc_track_caller-to-get-accurate-traces-for-kvasprintf lib/kasprintf.c
--- a/lib/kasprintf.c~lib-kasprintfc-use-kmalloc_track_caller-to-get-accurate-traces-for-kvasprintf
+++ a/lib/kasprintf.c
@@ -21,7 +21,7 @@ char *kvasprintf(gfp_t gfp, const char *
 	len = vsnprintf(NULL, 0, fmt, aq);
 	va_end(aq);
 
-	p = kmalloc(len+1, gfp);
+	p = kmalloc_track_caller(len+1, gfp);
 	if (!p)
 		return NULL;
 
_

Patches currently in -mm which might be from elezegarcia@gmail.com are

origin.patch
linux-next.patch

