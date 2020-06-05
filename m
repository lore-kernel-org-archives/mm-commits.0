From: akpm@linux-foundation.org
Subject: [merged] checkpatch-disallow-git-and-file-fix.patch
 removed from -mm tree
Date: Fri, 05 Jun 2020 13:19:26 -0700
Message-ID: <20200605201926.8lu7ODofJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728088AbgFEUT0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:19:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: disallow --git and --file/--fix
has been removed from the -mm tree.  Its filename was
     checkpatch-disallow-git-and-file-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: disallow --git and --file/--fix

Don't allow these options to be combined.

Miscellanea:

o Add missing $P: to some die("reason message") output

Link: http://lkml.kernel.org/r/3dc7bdaa58490f5906efc11a4d6113e42a087723.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-disallow-git-and-file-fix
+++ a/scripts/checkpatch.pl
@@ -246,6 +246,8 @@ list_types(0) if ($list_types);
 $fix = 1 if ($fix_inplace);
 $check_orig = $check;
 
+die "$P: --git cannot be used with --file or --fix\n" if ($git && ($file || $fix));
+
 my $exit = 0;
 
 my $perl_version_ok = 1;
@@ -269,11 +271,11 @@ if ($color =~ /^[01]$/) {
 } elsif ($color =~ /^auto$/i) {
 	$color = (-t STDOUT);
 } else {
-	die "Invalid color mode: $color\n";
+	die "$P: Invalid color mode: $color\n";
 }
 
 # skip TAB size 1 to avoid additional checks on $tabsize - 1
-die "Invalid TAB size: $tabsize\n" if ($tabsize < 2);
+die "$P: Invalid TAB size: $tabsize\n" if ($tabsize < 2);
 
 sub hash_save_array_words {
 	my ($hashRef, $arrayRef) = @_;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
