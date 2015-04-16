From: akpm@linux-foundation.org
Subject: [merged] test-hexdumpc-fix-initconst-confusion.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:54:19 -0700
Message-ID: <552fe93b.NPpDN/4mf/oorgDY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbbDPQsu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test-hexdump.c: fix initconst confusion
has been removed from the -mm tree.  Its filename was
     test-hexdumpc-fix-initconst-confusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: lib/test-hexdump.c: fix initconst confusion

const char *...[] is not const, but an array of pointer to const.  So
these arrays cannot be __initconst, but must be __initdata

This fixes section conflicts with LTO.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test-hexdump.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/test-hexdump.c~test-hexdumpc-fix-initconst-confusion lib/test-hexdump.c
--- a/lib/test-hexdump.c~test-hexdumpc-fix-initconst-confusion
+++ a/lib/test-hexdump.c
@@ -18,26 +18,26 @@ static const unsigned char data_b[] = {
 
 static const unsigned char data_a[] = ".2.{....p..$}.4...1.....L...C...";
 
-static const char *test_data_1_le[] __initconst = {
+static const char * const test_data_1_le[] __initconst = {
 	"be", "32", "db", "7b", "0a", "18", "93", "b2",
 	"70", "ba", "c4", "24", "7d", "83", "34", "9b",
 	"a6", "9c", "31", "ad", "9c", "0f", "ac", "e9",
 	"4c", "d1", "19", "99", "43", "b1", "af", "0c",
 };
 
-static const char *test_data_2_le[] __initconst = {
+static const char *test_data_2_le[] __initdata = {
 	"32be", "7bdb", "180a", "b293",
 	"ba70", "24c4", "837d", "9b34",
 	"9ca6", "ad31", "0f9c", "e9ac",
 	"d14c", "9919", "b143", "0caf",
 };
 
-static const char *test_data_4_le[] __initconst = {
+static const char *test_data_4_le[] __initdata = {
 	"7bdb32be", "b293180a", "24c4ba70", "9b34837d",
 	"ad319ca6", "e9ac0f9c", "9919d14c", "0cafb143",
 };
 
-static const char *test_data_8_le[] __initconst = {
+static const char *test_data_8_le[] __initdata = {
 	"b293180a7bdb32be", "9b34837d24c4ba70",
 	"e9ac0f9cad319ca6", "0cafb1439919d14c",
 };
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
lto-add-__noreorder-and-mark-initcalls-__noreorder.patch
linux-next.patch
gitignore-ignore-tar.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

