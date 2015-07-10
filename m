From: akpm@linux-foundation.org
Subject: + parse_integer-add-checkpatchpl-notice.patch added to -mm tree
Date: Fri, 10 Jul 2015 14:28:04 -0700
Message-ID: <55a038e4.L4N2KyvvODb0octj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724AbbGJV2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jul 2015 17:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: add checkpatch.pl notice
has been added to the -mm tree.  Its filename is
     parse_integer-add-checkpatchpl-notice.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parse_integer-add-checkpatchpl-notice.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parse_integer-add-checkpatchpl-notice.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: parse_integer: add checkpatch.pl notice

* remove check for strict_strto*(), they were fully removed long ago,

* add check for simple_strto*(), suggest replacements

  sscanf() is a bit icky to suggest because it accepts arbitrary amount
  of whitespace before any integer conversion, but assume programmer
  knows such twist and don't use sscanf() where real strictness is
  required (yes, sure...).

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~parse_integer-add-checkpatchpl-notice scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~parse_integer-add-checkpatchpl-notice
+++ a/scripts/checkpatch.pl
@@ -5498,10 +5498,10 @@ sub process {
 			     "consider using a completion\n" . $herecurr);
 		}
 
-# recommend kstrto* over simple_strto* and strict_strto*
-		if ($line =~ /\b((simple|strict)_(strto(l|ll|ul|ull)))\s*\(/) {
+# simple_strto*() is deprecated
+		if ($line =~ /\b(simple_strto(l|ll|ul|ull))\s*\(/) {
 			WARN("CONSIDER_KSTRTO",
-			     "$1 is obsolete, use k$3 instead\n" . $herecurr);
+			     "$1 is obsolete, use parse_integer(), kstrto*(), kstrto*_from_user(), sscanf() instead\n" . $herecurr);
 		}
 
 # check for __initcall(), use device_initcall() explicitly or more appropriate function please
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kstrto-accept-0-for-signed-conversion.patch
add-parse_integer-replacement-for-simple_strto.patch
parse_integer-add-runtime-testsuite.patch
parse-integer-rewrite-kstrto.patch
parse_integer-convert-scanf.patch
scanf-fix-type-range-overflow.patch
parse_integer-convert-lib.patch
parse_integer-convert-mm.patch
parse_integer-convert-fs.patch
parse_integer-convert-fs-cachefiles.patch
parse_integer-convert-ext2-ext3-ext4.patch
parse_integer-convert-fs-ocfs2.patch
parse_integer-add-checkpatchpl-notice.patch

