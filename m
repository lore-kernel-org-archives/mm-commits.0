From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-fix-handling-of-%zd-when-using-ssize_t.patch added to -mm tree
Date: Fri, 30 Nov 2012 15:35:23 -0800
Message-ID: <20121130233524.4898220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:63900 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab2K3Xf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 18:35:26 -0500
Received: by mail-lb0-f202.google.com with SMTP id i15so75551lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 15:35:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jgunthorpe@obsidianresearch.com


The patch titled
     Subject: lib/vsprintf.c: fix handling of %zd when using ssize_t
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-fix-handling-of-%zd-when-using-ssize_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: lib/vsprintf.c: fix handling of %zd when using ssize_t

Documentation/printk-formats.txt says to use %zd for a ssize_t argument
and some drivers do.  Unfortunately this prints a positive number for
negative values eg:

tpm_tis 70030000.tpm_tis: tpm_transmit: tpm_send: error 4294967234

Add a case to va_args a ssize_t type if the interpretation should be
signed.

Tested on PPC32.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-fix-handling-of-%zd-when-using-ssize_t lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-fix-handling-of-%zd-when-using-ssize_t
+++ a/lib/vsprintf.c
@@ -1485,7 +1485,10 @@ int vsnprintf(char *buf, size_t size, co
 				num = va_arg(args, long);
 				break;
 			case FORMAT_TYPE_SIZE_T:
-				num = va_arg(args, size_t);
+				if (spec.flags & SIGN)
+					num = va_arg(args, ssize_t);
+				else
+					num = va_arg(args, size_t);
 				break;
 			case FORMAT_TYPE_PTRDIFF:
 				num = va_arg(args, ptrdiff_t);
_

Patches currently in -mm which might be from jgunthorpe@obsidianresearch.com are

origin.patch
linux-next.patch
lib-vsprintfc-fix-handling-of-%zd-when-using-ssize_t.patch

