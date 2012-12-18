From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-fix-handling-of-%zd-when-using-ssize_t.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:03:29 -0800
Message-ID: <20121218200330.29A0320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:43768 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:03:32 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so63348wey.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:03:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jgunthorpe@obsidianresearch.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: fix handling of %zd when using ssize_t
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-fix-handling-of-%zd-when-using-ssize_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

