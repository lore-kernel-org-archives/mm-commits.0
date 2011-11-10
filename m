From: akpm@linux-foundation.org
Subject: + checkpatch-prefer-__printf-not-__attribute__formatprintf.patch added to -mm tree
Date: Thu, 10 Nov 2011 15:29:11 -0800
Message-ID: <201111102329.pAANTBfE001266@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wy0-f202.google.com ([74.125.82.202]:52118 "EHLO
	mail-wy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1KJX3P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2011 18:29:15 -0500
Received: by wyg8 with SMTP id 8so80057wyg.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2011 15:29:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     Subject: checkpatch: prefer __printf over __attribute__((format(printf,...)))
has been added to the -mm tree.  Its filename is
     checkpatch-prefer-__printf-not-__attribute__formatprintf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: prefer __printf over __attribute__((format(printf,...)))

Add a warn for not using __printf.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-prefer-__printf-not-__attribute__formatprintf scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-prefer-__printf-not-__attribute__formatprintf
+++ a/scripts/checkpatch.pl
@@ -3114,6 +3114,12 @@ sub process {
 			     "__aligned(size) is preferred over __attribute__((aligned(size)))\n" . $herecurr);
 		}
 
+# Check for __attribute__ format(printf, prefer __printf
+		if ($line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf/) {
+			WARN("PREFER_PRINTF",
+			     "__printf(string-index, first-to-check) is preferred over __attribute__((format(printf, string-index, first-to-check)))\n" . $herecurr);
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("SIZEOF_ADDRESS",
_
Subject: Subject: checkpatch: prefer __printf over __attribute__((format(printf,...)))

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
linkage-remove-unused-attrib_noret-macro.patch
checkpatch-update-signature-might-be-better-as-warning.patch
checkpatch-prefer-__printf-not-__attribute__formatprintf.patch

