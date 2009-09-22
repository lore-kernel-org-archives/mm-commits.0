From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-using-separator-implies-nomultiline.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:45:11 -0700
Message-ID: <200909222045.n8MKjBEH015167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456AbZIVUpJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:45:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: using --separator implies --nomultiline
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-using-separator-implies-nomultiline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
ncpfs-remove-dead-url-from-documentation.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

