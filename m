From: akpm@linux-foundation.org
Subject: + test-hexdumpc-fix-initconst-confusion.patch added to -mm tree
Date: Wed, 08 Apr 2015 15:22:38 -0700
Message-ID: <5525aa2e.iaa1TGZADDLMoaj9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbbDHWWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Apr 2015 18:22:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test-hexdump.c: fix initconst confusion
has been added to the -mm tree.  Its filename is
     test-hexdumpc-fix-initconst-confusion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test-hexdumpc-fix-initconst-confusion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test-hexdumpc-fix-initconst-confusion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3.patch
dont-let-latencytop-and-lockdep-select-kallsyms_all.patch
test-hexdumpc-fix-initconst-confusion.patch
linux-next.patch
gitignore-ignore-tar.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

