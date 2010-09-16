From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-dont-search-maintainers-for-keywords-or-emails.patch added to -mm tree
Date: Thu, 16 Sep 2010 12:53:21 -0700
Message-ID: <201009161953.o8GJrL8n010335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672Ab0IPTxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 15:53:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     scripts/get_maintainer.pl: don't search MAINTAINERS for keywords or emails
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-dont-search-maintainers-for-keywords-or-emails.patch

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
Subject: scripts/get_maintainer.pl: don't search MAINTAINERS for keywords or emails
From: Joe Perches <joe@perches.com>

Keyword matching uses K: patterns from MAINTAINERS, so if looking for the
MAINTAINERS maintainer, don't search MAINTAINERS for pattern matches. 
MAINTAINERS also has rather a lot of email addresses and is easily
searched using grep "^M:", so skip it.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-dont-search-maintainers-for-keywords-or-emails scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-dont-search-maintainers-for-keywords-or-emails
+++ a/scripts/get_maintainer.pl
@@ -304,7 +304,7 @@ foreach my $file (@ARGV) {
     }
     if ($from_filename) {
 	push(@files, $file);
-	if (-f $file && ($keywords || $file_emails)) {
+	if ($file ne "MAINTAINERS" && -f $file && ($keywords || $file_emails)) {
 	    open(my $f, '<', $file)
 		or die "$P: Can't open $file: $!\n";
 	    my $text = do { local($/) ; <$f> };
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-add-irq-subsystem.patch
kernelh-add-minmax3-macros.patch
kernelh-add-minmax3-macros-fix.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
scripts-get_maintainerpl-use-correct-indentation.patch
scripts-get_maintainerpl-dont-search-maintainers-for-keywords-or-emails.patch
scripts-get_maintainerpl-add-default-git-fallback-remove-default-git.patch
scripts-get_maintainerpl-use-get_maintainerconf-from-then-home-then-scripts.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-add-additional-attribute-defines.patch
scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char.patch

