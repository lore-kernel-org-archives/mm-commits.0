From: akpm@linux-foundation.org
Subject: + vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch added to -mm tree
Date: Mon, 16 Apr 2012 14:49:13 -0700
Message-ID: <20120416214913.B0485A0333@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:46077 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2DPVtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 17:49:15 -0400
Received: by qabg24 with SMTP id g24so679474qab.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 14:49:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant.likely@secretlab.ca


The patch titled
     Subject: vsprintf: correctly handle width when '#' flag used in %#p format.
has been added to the -mm tree.  Its filename is
     vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Grant Likely <grant.likely@secretlab.ca>
Subject: vsprintf: correctly handle width when '#' flag used in %#p format.

needs decent changelog!

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-correctly-handle-width-when-flag-used-in-%p-format lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-correctly-handle-width-when-flag-used-in-%p-format
+++ a/lib/vsprintf.c
@@ -866,13 +866,15 @@ static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	      struct printf_spec spec)
 {
+	int default_width = 2 * sizeof(void*) + (spec.flags & SPECIAL ? 2 : 0);
+
 	if (!ptr && *fmt != 'K') {
 		/*
 		 * Print (null) with the same width as a pointer so it makes
 		 * tabular output look nice.
 		 */
 		if (spec.field_width == -1)
-			spec.field_width = 2 * sizeof(void *);
+			spec.field_width = default_width;
 		return string(buf, end, "(null)", spec);
 	}
 
@@ -927,7 +929,7 @@ char *pointer(const char *fmt, char *buf
 		 */
 		if (in_irq() || in_serving_softirq() || in_nmi()) {
 			if (spec.field_width == -1)
-				spec.field_width = 2 * sizeof(void *);
+				spec.field_width = default_width;
 			return string(buf, end, "pK-error", spec);
 		}
 		if (!((kptr_restrict == 0) ||
@@ -944,7 +946,7 @@ char *pointer(const char *fmt, char *buf
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
-		spec.field_width = 2 * sizeof(void *);
+		spec.field_width = default_width;
 		spec.flags |= ZEROPAD;
 	}
 	spec.base = 16;
_
Subject: Subject: vsprintf: correctly handle width when '#' flag used in %#p format.

Patches currently in -mm which might be from grant.likely@secretlab.ca are

linux-next.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch

