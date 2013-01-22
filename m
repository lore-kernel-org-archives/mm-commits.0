From: akpm@linux-foundation.org
Subject: + checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch added to -mm tree
Date: Tue, 22 Jan 2013 15:10:15 -0800
Message-ID: <20130122231015.90B7531C211@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:40732 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3AVXKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 18:10:16 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so874355ghb.5
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 15:10:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, akpm@linux-foundation.org


The patch titled
     Subject: checkpatch: don't emit the CamelCase warning for PageFoo
has been added to the -mm tree.  Its filename is
     checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch

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
Subject: checkpatch: don't emit the CamelCase warning for PageFoo

I'm getting a ton of these:

WARNING: Avoid CamelCase: <PageTransHuge>
#140: FILE: mm/migrate.c:1576:
+       if (PageTransHuge(page) && page_count(page) != 3) {

So exclude anything which starts with "Page".

Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-dont-emit-the-camelcase-warning-for-pagefoo scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-dont-emit-the-camelcase-warning-for-pagefoo
+++ a/scripts/checkpatch.pl
@@ -2915,6 +2915,7 @@ sub process {
 			my $var = $1;
 			if ($var !~ /$Constant/ &&
 			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
+			    $var !~ /^Page[A-Z]/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				WARN("CAMELCASE",
_

Patches currently in -mm which might be from joe@perches.com are

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

