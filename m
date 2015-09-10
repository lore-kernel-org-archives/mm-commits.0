From: akpm@linux-foundation.org
Subject: [nacked] parse_integer-add-checkpatchpl-notice.patch removed from -mm tree
Date: Thu, 10 Sep 2015 13:40:38 -0700
Message-ID: <55f1eac6.kZmgi/8XPXUU0Qyj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbbIJUki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Sep 2015 16:40:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: add checkpatch.pl notice
has been removed from the -mm tree.  Its filename was
     parse_integer-add-checkpatchpl-notice.patch

This patch was dropped because it was nacked

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
@@ -5517,10 +5517,10 @@ sub process {
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
parse_integer-convert-scanf.patch
scanf-fix-type-range-overflow.patch
parse_integer-convert-lib.patch
parse_integer-convert-mm.patch
parse_integer-convert-fs.patch
parse_integer-convert-fs-cachefiles.patch
parse_integer-convert-ext2-ext3-ext4.patch
parse_integer-convert-fs-ocfs2.patch
parse_integer-convert-fs-9p.patch
parse_integer-convert-fs-exofs.patch
proc-convert-to-kstrto-kstrto_from_user.patch
sound-convert-to-parse_integer.patch

