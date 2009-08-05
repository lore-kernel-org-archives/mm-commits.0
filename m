From: akpm@linux-foundation.org
Subject: [to-be-updated] scripts-get_maintainerpl-add-sections-in-pattern-match-directory-depth-order.patch removed from -mm tree
Date: Wed, 05 Aug 2009 12:21:02 -0700
Message-ID: <200908051921.n75JL27J025387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbZHETV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 15:21:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, James.Bottomley@HansenPartnership.com, zaga@fly.cc.fer.hr, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: Add sections in pattern match directory depth order
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-add-sections-in-pattern-match-directory-depth-order.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: Add sections in pattern match directory depth order
From: Joe Perches <joe@perches.com>

Before this change, matched sections were added in the normally
alphabetic order of MAINTAINERS.

For instance, finding the maintainer for drivers/scsi/wd7000.c
would first find "SCSI SUBSYSTEM", then "WD7000 SCSI SUBSYSTEM",
then "THE REST".

before patch:

$ ./scripts/get_maintainer.pl --nogit -f drivers/scsi/wd7000.c
James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Miroslav Zagorac <zaga@fly.cc.fer.hr>
linux-scsi@vger.kernel.org
linux-kernel@vger.kernel.org

This patch does a length based directory match depth check by
counting the number of "/" characters in the pattern and adding
1 more if the pattern is not a directory, then selecting the
matched pattern sections by greatest depth.

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

 scripts/get_maintainer.pl |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-sections-in-pattern-match-directory-depth-order scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-sections-in-pattern-match-directory-depth-order
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.18beta2';
+my $V = '0.18';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -210,6 +210,7 @@ foreach my $file (@files) {
 	    if ($type eq 'X') {
 		if (file_match_pattern($file, $value)) {
 		    $exclude = 1;
+		    last;
 		}
 	    }
 	}
@@ -217,18 +218,24 @@ foreach my $file (@files) {
 
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

linux-next.patch
maintainers-add-ipvs-include-files.patch
scripts-get_maintainerpl-add-sections-in-pattern-match-directory-depth-order.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch

