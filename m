From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-test-git_dir-changes.patch added to -mm tree
Date: Sat, 25 Apr 2020 17:48:49 -0700
Message-ID: <20200426004849.RQUShjn30%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgDZAsu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 25 Apr 2020 20:48:50 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: test $GIT_DIR changes
has been added to the -mm tree.  Its filename is
     checkpatch-test-git_dir-changes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-test-git_dir-changes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-test-git_dir-changes.patch

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
Subject: checkpatch: test $GIT_DIR changes

Link: http://lkml.kernel.org/r/318ca0e0c755cc31c288d7f8769817da4dc60bda.camel@perches.com

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-test-git_dir-changes
+++ a/scripts/checkpatch.pl
@@ -43,6 +43,8 @@ my $list_types = 0;
 my $fix = 0;
 my $fix_inplace = 0;
 my $root;
+my $gitroot = $ENV{'GIT_DIR'};
+$gitroot = ".git" if !defined($gitroot);
 my %debug;
 my %camelcase = ();
 my %use_type = ();
@@ -897,7 +899,7 @@ sub is_maintained_obsolete {
 sub is_SPDX_License_valid {
 	my ($license) = @_;
 
-	return 1 if (!$tree || which("python") eq "" || !(-e "$root/scripts/spdxcheck.py") || !(-e "$root/.git"));
+	return 1 if (!$tree || which("python") eq "" || !(-e "$root/scripts/spdxcheck.py") || !(-e "$gitroot"));
 
 	my $root_path = abs_path($root);
 	my $status = `cd "$root_path"; echo "$license" | python scripts/spdxcheck.py -`;
@@ -915,7 +917,7 @@ sub seed_camelcase_includes {
 
 	$camelcase_seeded = 1;
 
-	if (-e ".git") {
+	if (-e "$gitroot") {
 		my $git_last_include_commit = `${git_command} log --no-merges --pretty=format:"%h%n" -1 -- include`;
 		chomp $git_last_include_commit;
 		$camelcase_cache = ".checkpatch-camelcase.git.$git_last_include_commit";
@@ -943,7 +945,7 @@ sub seed_camelcase_includes {
 		return;
 	}
 
-	if (-e ".git") {
+	if (-e "$gitroot") {
 		$files = `${git_command} ls-files "include/*.h"`;
 		@include_files = split('\n', $files);
 	}
@@ -966,7 +968,7 @@ sub seed_camelcase_includes {
 sub git_commit_info {
 	my ($commit, $id, $desc) = @_;
 
-	return ($id, $desc) if ((which("git") eq "") || !(-e ".git"));
+	return ($id, $desc) if ((which("git") eq "") || !(-e "$gitroot"));
 
 	my $output = `${git_command} log --no-color --format='%H %s' -1 $commit 2>&1`;
 	$output =~ s/^\s*//gm;
@@ -1005,7 +1007,7 @@ my $fixlinenr = -1;
 
 # If input is git commits, extract all commits from the commit expressions.
 # For example, HEAD-3 means we need check 'HEAD, HEAD~1, HEAD~2'.
-die "$P: No git repository found\n" if ($git && !-e ".git");
+die "$P: No git repository found\n" if ($git && !-e "$gitroot");
 
 if ($git) {
 	my @commits = ();
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
checkpatch-additional-maintainer-section-entry-ordering-checks.patch
checkpatch-look-for-c99-comments-in-ctx_locate_comment.patch
fs-seq_filec-seq_read-update-pr_info_ratelimited.patch
