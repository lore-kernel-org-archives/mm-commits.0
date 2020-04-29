From: akpm@linux-foundation.org
Subject: + checkpatch-disallow-git-and-file-fix.patch added to -mm
 tree
Date: Wed, 29 Apr 2020 15:16:40 -0700
Message-ID: <20200429221640.oHAuSaSKM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbgD2WQl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Apr 2020 18:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: disallow --git and --file/--fix
has been added to the -mm tree.  Its filename is
     checkpatch-disallow-git-and-file-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-disallow-git-and-file-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-disallow-git-and-file-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
get_maintainer-add-email-addresses-from-yaml-files.patch
checkpatch-additional-maintainer-section-entry-ordering-checks.patch
checkpatch-look-for-c99-comments-in-ctx_locate_comment.patch
checkpatch-disallow-git-and-file-fix.patch
fs-seq_filec-seq_read-update-pr_info_ratelimited.patch
