From: akpm@linux-foundation.org
Subject: + hexdump-fix-ascii-column-for-the-tail-of-a-dump.patch added to
 -mm tree
Date: Mon, 29 Dec 2014 14:15:54 -0800
Message-ID: <54a1d29a.07OiIpN3QIHmljO0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaL2WPz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Dec 2014 17:15:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hexdump: fix ascii column for the tail of a dump
has been added to the -mm tree.  Its filename is
     hexdump-fix-ascii-column-for-the-tail-of-a-dump.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hexdump-fix-ascii-column-for-the-tail-of-a-dump.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hexdump-fix-ascii-column-for-the-tail-of-a-dump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: hexdump: fix ascii column for the tail of a dump

In the current implementation we have a floating ascii column in the tail
of the dump.

For example, for row size equal to 16 the ascii column as in following
table

group size \ length	8	12	16
	1		50	50	50
	2		22	32	42
	4		20	29	38
	8		19	-	36

This patch makes it the same independently of amount of bytes dumped.

The change is safe since all current users, which use ASCII part of the
dump, rely on the group size equal to 1.  The patch doesn't change
behaviour for such group size (see the table above).

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/hexdump.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/hexdump.c~hexdump-fix-ascii-column-for-the-tail-of-a-dump lib/hexdump.c
--- a/lib/hexdump.c~hexdump-fix-ascii-column-for-the-tail-of-a-dump
+++ a/lib/hexdump.c
@@ -126,7 +126,7 @@ void hex_dump_to_buffer(const void *buf,
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%16.16llx", j ? " " : "",
 					(unsigned long long)*(ptr8 + j));
-		ascii_column = 17 * ngroups + 2;
+		ascii_column = rowsize * 2 + rowsize / 8 + 2;
 		break;
 	}
 
@@ -137,7 +137,7 @@ void hex_dump_to_buffer(const void *buf,
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%8.8x", j ? " " : "", *(ptr4 + j));
-		ascii_column = 9 * ngroups + 2;
+		ascii_column = rowsize * 2 + rowsize / 4 + 2;
 		break;
 	}
 
@@ -148,7 +148,7 @@ void hex_dump_to_buffer(const void *buf,
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%4.4x", j ? " " : "", *(ptr2 + j));
-		ascii_column = 5 * ngroups + 2;
+		ascii_column = rowsize * 2 + rowsize / 2 + 2;
 		break;
 	}
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

hexdump-introduce-test-suite.patch
hexdump-fix-ascii-column-for-the-tail-of-a-dump.patch
hexdump-do-few-calculations-ahead.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer.patch
linux-next.patch

