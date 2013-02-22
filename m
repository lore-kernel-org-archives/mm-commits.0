From: akpm@linux-foundation.org
Subject: + checkpatch-improve-camelcase-test-for-page.patch added to -mm tree
Date: Fri, 22 Feb 2013 13:14:24 -0800
Message-ID: <20130222211424.86FE95A4252@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:36311 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab3BVVOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 16:14:25 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so107612qen.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 13:14:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     Subject: checkpatch: improve CamelCase test for Page
has been added to the -mm tree.  Its filename is
     checkpatch-improve-camelcase-test-for-page.patch

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
Subject: checkpatch: improve CamelCase test for Page

Add the ClearPage/SetPage/TestClearPage/TestSetPage variants to the not
reported Page CamelCase variables.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-camelcase-test-for-page scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-camelcase-test-for-page
+++ a/scripts/checkpatch.pl
@@ -2930,7 +2930,7 @@ sub process {
 			my $var = $1;
 			if ($var !~ /$Constant/ &&
 			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
-			    $var !~ /^Page[A-Z]/ &&
+			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				WARN("CAMELCASE",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
checkpatch-improve-camelcase-test-for-page.patch
get_maintainer-allow-keywords-to-match-filenames.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch

