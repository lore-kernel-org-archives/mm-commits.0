From: akpm@linux-foundation.org
Subject: + hexdump-make-test-data-really-const.patch added to -mm tree
Date: Tue, 21 Apr 2015 15:13:50 -0700
Message-ID: <5536cb9e.GZOpIdRWo12sJLcu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964934AbbDUWNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Apr 2015 18:13:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, ak@linux.intel.com, andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hexdump: Make test data really const
has been added to the -mm tree.  Its filename is
     hexdump-make-test-data-really-const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hexdump-make-test-data-really-const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hexdump-make-test-data-really-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: hexdump: Make test data really const

The test data arrays, containing pointers to test strings, are never
modified, so they can be const, too.  Hence mark them "const" and
"__initconst".

This moves 28 pointers from ".init.data" to ".init.rodata".

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test-hexdump.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/test-hexdump.c~hexdump-make-test-data-really-const lib/test-hexdump.c
--- a/lib/test-hexdump.c~hexdump-make-test-data-really-const
+++ a/lib/test-hexdump.c
@@ -25,19 +25,19 @@ static const char * const test_data_1_le
 	"4c", "d1", "19", "99", "43", "b1", "af", "0c",
 };
 
-static const char *test_data_2_le[] __initdata = {
+static const char * const test_data_2_le[] __initconst = {
 	"32be", "7bdb", "180a", "b293",
 	"ba70", "24c4", "837d", "9b34",
 	"9ca6", "ad31", "0f9c", "e9ac",
 	"d14c", "9919", "b143", "0caf",
 };
 
-static const char *test_data_4_le[] __initdata = {
+static const char * const test_data_4_le[] __initconst = {
 	"7bdb32be", "b293180a", "24c4ba70", "9b34837d",
 	"ad319ca6", "e9ac0f9c", "9919d14c", "0cafb143",
 };
 
-static const char *test_data_8_le[] __initdata = {
+static const char * const test_data_8_le[] __initconst = {
 	"b293180a7bdb32be", "9b34837d24c4ba70",
 	"e9ac0f9cad319ca6", "0cafb1439919d14c",
 };
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
hexdump-make-test-data-really-const.patch
linux-next.patch

