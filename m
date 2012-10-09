From: akpm@linux-foundation.org
Subject: + lib-kasprintfc-use-kmalloc_track_caller-to-get-accurate-traces-for-kvasprintf.patch added to -mm tree
Date: Tue, 09 Oct 2012 14:18:15 -0700
Message-ID: <20121009211815.9BA7B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:52872 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab2JIVSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 17:18:16 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so551815qae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 14:18:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elezegarcia@gmail.com, sam@ravnborg.org


The patch titled
     Subject: lib/kasprintf.c: use kmalloc_track_caller() to get accurate traces for kvasprintf
has been added to the -mm tree.  Its filename is
     lib-kasprintfc-use-kmalloc_track_caller-to-get-accurate-traces-for-kvasprintf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
lib-kasprintfc-use-kmalloc_track_caller-to-get-accurate-traces-for-kvasprintf.patch

