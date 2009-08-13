From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-add-sections-in-pattern-match-depth-order.patch added to -mm tree
Date: Thu, 13 Aug 2009 14:49:06 -0700
Message-ID: <200908132149.n7DLn7g9012700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751566AbZHMVuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 17:50:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, James.Bottomley@HansenPartnership.com, zaga@fly.cc.fer.hr


The patch titled
     scripts/get_maintainer.pl: add sections in pattern match depth order
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-add-sections-in-pattern-match-depth-order.patch

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
Subject: scripts/get_maintainer.pl: add sections in pattern match depth order
From: Joe Perches <joe@perches.com>

Before this change, matched sections were added in the order
of appearance in the normally alphabetic section order of
the MAINTAINERS file.

For instance, finding the maintainer for drivers/scsi/wd7000.c
would first find "SCSI SUBSYSTEM", then "WD7000 SCSI SUBSYSTEM",
then "THE REST".

before patch:

$ ./scripts/get_maintainer.pl --nogit -f drivers/scsi/wd7000.c
James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Miroslav Zagorac <zaga@fly.cc.fer.hr>
linux-scsi@vger.kernel.org
linux-kernel@vger.kernel.org

get_maintainer.pl now selects matched sections by longest pattern match.
Longest is the number of "/"s and any specific file pattern.

This changes the example output order of MAINTAINERS to whatever is
selected in "WD7000 SUBSYSTEM", then "SCSI SYSTEM", then "THE REST".

after patch:

$ ./scripts/get_maintainer.pl --nogit -f drivers/scsi/wd7000.c
Miroslav Zagorac <zaga@fly.cc.fer.hr>
James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
linux-scsi@vger.kernel.org
linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-sections-in-pattern-match-depth-order scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-sections-in-pattern-match-depth-order
+++ a/scripts/get_maintainer.pl
@@ -211,6 +211,7 @@ foreach my $file (@files) {
 	    if ($type eq 'X') {
 		if (file_match_pattern($file, $value)) {
 		    $exclude = 1;
+		    last;
 		}
 	    }
 	}
@@ -218,18 +219,24 @@ foreach my $file (@files) {
 
     if (!$exclude) {
 	my $tvi = 0;
+	my %hash;
 	foreach my $line (@typevalue) {
 	    if ($line =~ m/^(\C):\s*(.*)/) {
 		my $type = $1;
 		my $value = $2;
 		if ($type eq 'F') {
 		    if (file_match_pattern($file, $value)) {
-			add_categories($tvi);
+			my $pattern_depth = ($value =~ tr@/@@);
+			$pattern_depth++ if (!(substr($value,-1,1) eq "/"));
+			$hash{$tvi} = $pattern_depth;
 		    }
 		}
 	    }
 	    $tvi++;
 	}
+	foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
+	    add_categories($line);
+	}
     }
 
     if ($email && $email_git) {
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

