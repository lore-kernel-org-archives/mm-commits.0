From: akpm@linux-foundation.org
Subject: + checkpatch-add-check-for-kcalloc-argument-order.patch added to -mm tree
Date: Mon, 28 Jan 2013 14:13:28 -0800
Message-ID: <20130128221328.93A0F31C25A@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:51222 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab3A1WN3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 17:13:29 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so328885ghb.0
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 14:13:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     Subject: checkpatch: Add check for kcalloc argument order
has been added to the -mm tree.  Its filename is
     checkpatch-add-check-for-kcalloc-argument-order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: Add check for kcalloc argument order

kcalloc is sometimes misused with the first and second arguments switched.

Same issue with kmalloc_array too.

Bleat if sizeof is the first argument

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-check-for-kcalloc-argument-order scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-check-for-kcalloc-argument-order
+++ a/scripts/checkpatch.pl
@@ -3476,6 +3476,12 @@ sub process {
 			     "unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
 		}
 
+# check for alloc argument mismatch
+		if ($line =~ /\b(kcalloc|kmalloc_array)\s*\(\s*sizeof\b/) {
+			WARN("ALLOC_ARRAY_ARGS",
+			     "$1 uses number as first arg, sizeof is generally wrong\n" . $herecurr);
+		}
+
 # check for multiple semicolons
 		if ($line =~ /;\s*;\s*$/) {
 			WARN("ONE_SEMICOLON",
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-fix-float-creation-of-match-variables.patch
linux-next.patch
compiler-gcc4h-reorder-macros-based-upon-gcc-ver.patch
compiler-gcch-add-gcc-recommended-gcc_version-macro.patch
compiler-gcc34h-use-gcc_version-macro.patch
compiler-gcc4h-bugh-remove-duplicate-macros.patch
bugh-fix-build_bug_on-macro-in-__checker__.patch
bugh-prevent-double-evaulation-of-in-build_bug_on.patch
bugh-make-build_bug_on-generate-compile-time-error.patch
compilerh-bugh-prevent-double-error-messages-with-build_bug_on.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch
get_maintainerpl-find-maintainers-for-removed-files.patch
checkpatch-prefer-dev_level-to-dev_printkkern_level.patch
checkpatch-warn-on-unnecessary-__devfoo-section-markings.patch
checkpatch-add-joe-to-maintainers.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
checkpatch-add-check-for-kcalloc-argument-order.patch

