From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-using-separator-implies-nomultiline.patch added to -mm tree
Date: Thu, 13 Aug 2009 14:49:17 -0700
Message-ID: <200908132149.n7DLnHbe013070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbZHMV7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 17:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     scripts/get_maintainer.pl: using --separator implies --nomultiline
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-using-separator-implies-nomultiline.patch

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
Subject: scripts/get_maintainer.pl: using --separator implies --nomultiline
From: Joe Perches <joe@perches.com>

If a person sets a separator, it's only used if --nomultiline is set.
Don't make the command line also include --nomultiline in that case.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-using-separator-implies-nomultiline scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-using-separator-implies-nomultiline
+++ a/scripts/get_maintainer.pl
@@ -105,6 +105,10 @@ if ($#ARGV < 0) {
     die "$P: argument missing: patchfile or -f file please\n";
 }
 
+if ($output_separator ne ", ") {
+    $output_multiline = 0;
+}
+
 my $selections = $email + $scm + $status + $subsystem + $web;
 if ($selections == 0) {
     usage();
@@ -376,6 +380,7 @@ MAINTAINER field selection options:
 
 Output type options:
   --separator [, ] => separator for multiple entries on 1 line
+    using --separator also sets --nomultiline if --separator is not [, ]
   --multiline => print 1 entry per line
 
 Other options:
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-osd-library-and-filesystem-pattern-fix.patch
linux-next.patch
maintainers-add-ipvs-include-files.patch
scripts-get_maintainerpl-add-git-blame.patch
scripts-get_maintainerpl-add-sections-in-pattern-match-depth-order.patch
scripts-get_maintainerpl-add-pattern-depth.patch
scripts-get_maintainerpl-better-email-routines-use-perl-not-shell-where-possible.patch
scripts-get_maintainerpl-add-mailmap-use-shell-and-email-cleanups.patch
scripts-get_maintainerpl-using-separator-implies-nomultiline.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

