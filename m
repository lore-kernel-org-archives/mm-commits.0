From: akpm@linux-foundation.org
Subject: + hexdump-truncate-output-in-case-of-overflow.patch added to -mm
 tree
Date: Tue, 03 Nov 2015 15:19:01 -0800
Message-ID: <563940e5.BPVeghy6QB9sss/9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965073AbbKCXTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2015 18:19:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, aaro.koskinen@nokia.com, catalin.marinas@arm.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/hexdump.c: truncate output in case of overflow
has been added to the -mm tree.  Its filename is
     hexdump-truncate-output-in-case-of-overflow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hexdump-truncate-output-in-case-of-overflow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hexdump-truncate-output-in-case-of-overflow.patch

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
Subject: lib/hexdump.c: truncate output in case of overflow

There is a classical off-by-one error in case when we try to place, for
example, 1+1 bytes as hex in the buffer of size 6.  The expected result is
to get an output truncated, but in the reality we get 6 bytes filed
followed by terminating NUL.

Change the logic how we fill the output in case of byte dumping into
limited space.  This will follow the snprintf() behaviour by truncating
output even on half bytes.

Fixes: 114fc1afb2de (hexdump: make it return number of bytes placed in buffer)
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Tested-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/hexdump.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN lib/hexdump.c~hexdump-truncate-output-in-case-of-overflow lib/hexdump.c
--- a/lib/hexdump.c~hexdump-truncate-output-in-case-of-overflow
+++ a/lib/hexdump.c
@@ -169,11 +169,15 @@ int hex_dump_to_buffer(const void *buf,
 		}
 	} else {
 		for (j = 0; j < len; j++) {
-			if (linebuflen < lx + 3)
+			if (linebuflen < lx + 2)
 				goto overflow2;
 			ch = ptr[j];
 			linebuf[lx++] = hex_asc_hi(ch);
+			if (linebuflen < lx + 2)
+				goto overflow2;
 			linebuf[lx++] = hex_asc_lo(ch);
+			if (linebuflen < lx + 2)
+				goto overflow2;
 			linebuf[lx++] = ' ';
 		}
 		if (j)
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

fs-proc-arrayc-set-overflow-flag-in-case-of-error.patch
hexdump-truncate-output-in-case-of-overflow.patch
fs-seq_file-use-seq_-helpers-in-seq_hex_dump.patch
seq_file-re-use-string_escape_str.patch

