From: akpm@linux-foundation.org
Subject: + get_maintainerpl-incomplete-output.patch added to -mm tree
Date: Fri, 18 Oct 2013 14:02:14 -0700
Message-ID: <5261a1d6.z/4fIT/QHnpXYEcw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3JRVCP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Oct 2013 17:02:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + get_maintainerpl-incomplete-output.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Fri, 18 Oct 2013 14:02:14 -0700


The patch titled
     Subject: get_maintainer.pl incomplete output
has been added to the -mm tree.  Its filename is
     get_maintainerpl-incomplete-output.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainerpl-incomplete-output.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainerpl-incomplete-output.patch

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
Subject: get_maintainer.pl incomplete output

Try this:


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   90 +++++++++++++++++++++++++++++++++---
 1 file changed, 84 insertions(+), 6 deletions(-)

diff -puN scripts/get_maintainer.pl~get_maintainerpl-incomplete-output scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainerpl-incomplete-output
+++ a/scripts/get_maintainer.pl
@@ -98,6 +98,7 @@ my %VCS_cmds_git = (
     "available" => '(which("git") ne "") && (-d ".git")',
     "find_signers_cmd" =>
 	"git log --no-color --follow --since=\$email_git_since " .
+	    '--numstat --no-merges ' .
 	    '--format="GitCommit: %H%n' .
 		      'GitAuthor: %an <%ae>%n' .
 		      'GitDate: %aD%n' .
@@ -106,6 +107,7 @@ my %VCS_cmds_git = (
 	    " -- \$file",
     "find_commit_signers_cmd" =>
 	"git log --no-color " .
+	    '--numstat ' .
 	    '--format="GitCommit: %H%n' .
 		      'GitAuthor: %an <%ae>%n' .
 		      'GitDate: %aD%n' .
@@ -114,6 +116,7 @@ my %VCS_cmds_git = (
 	    " -1 \$commit",
     "find_commit_author_cmd" =>
 	"git log --no-color " .
+	    '--numstat ' .
 	    '--format="GitCommit: %H%n' .
 		      'GitAuthor: %an <%ae>%n' .
 		      'GitDate: %aD%n' .
@@ -125,6 +128,7 @@ my %VCS_cmds_git = (
     "blame_commit_pattern" => "^([0-9a-f]+) ",
     "author_pattern" => "^GitAuthor: (.*)",
     "subject_pattern" => "^GitSubject: (.*)",
+    "stat_pattern" => "(\\d+)\\t(\\d+)\\t\$file",
 );
 
 my %VCS_cmds_hg = (
@@ -152,6 +156,7 @@ my %VCS_cmds_hg = (
     "blame_commit_pattern" => "^([ 0-9a-f]+):",
     "author_pattern" => "^HgAuthor: (.*)",
     "subject_pattern" => "^HgSubject: (.*)",
+    "stat_pattern" => "(\\d+)\t(\\d+)\t\$file",
 );
 
 my $conf = which_conf(".get_maintainer.conf");
@@ -1269,20 +1274,30 @@ sub extract_formatted_signatures {
 }
 
 sub vcs_find_signers {
-    my ($cmd) = @_;
+    my ($cmd, $file) = @_;
     my $commits;
     my @lines = ();
     my @signatures = ();
+    my @authors = ();
+    my @stats = ();
 
     @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
 
     my $pattern = $VCS_cmds{"commit_pattern"};
+    my $author_pattern = $VCS_cmds{"author_pattern"};
+    my $stat_pattern = $VCS_cmds{"stat_pattern"};
+
+    $stat_pattern =~ s/(\$\w+)/$1/eeg;		#interpolate $stat_pattern
 
     $commits = grep(/$pattern/, @lines);	# of commits
 
+    @authors = grep(/$author_pattern/, @lines);
     @signatures = grep(/^[ \t]*${signature_pattern}.*\@.*$/, @lines);
+    @stats = grep(/$stat_pattern/, @lines);
+
+#    print("stats: <@stats>\n");
 
-    return (0, @signatures) if !@signatures;
+    return (0, @signatures, @authors) if !@signatures;
 
     save_commits_by_author(@lines) if ($interactive);
     save_commits_by_signer(@lines) if ($interactive);
@@ -1291,9 +1306,10 @@ sub vcs_find_signers {
 	@signatures = grep(!/${penguin_chiefs}/i, @signatures);
     }
 
+    my ($author_ref, $authors_ref) = extract_formatted_signatures(@authors);
     my ($types_ref, $signers_ref) = extract_formatted_signatures(@signatures);
 
-    return ($commits, @$signers_ref);
+    return ($commits, $signers_ref, $authors_ref, \@stats);
 }
 
 sub vcs_find_author {
@@ -1849,7 +1865,12 @@ sub vcs_assign {
 sub vcs_file_signoffs {
     my ($file) = @_;
 
+    my $authors_ref;
+    my $signers_ref;
+    my $stats_ref;
+    my @authors = ();
     my @signers = ();
+    my @stats = ();
     my $commits;
 
     $vcs_used = vcs_exists();
@@ -1858,13 +1879,58 @@ sub vcs_file_signoffs {
     my $cmd = $VCS_cmds{"find_signers_cmd"};
     $cmd =~ s/(\$\w+)/$1/eeg;		# interpolate $cmd
 
-    ($commits, @signers) = vcs_find_signers($cmd);
+    ($commits, $signers_ref, $authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
+    @signers = @{$signers_ref};
+    @authors = @{$authors_ref};
+    @stats = @{$stats_ref};
+
+#    print("commits: <$commits>\nsigners:<@signers>\nauthors: <@authors>\nstats: <@stats>\n");
 
     foreach my $signer (@signers) {
 	$signer = deduplicate_email($signer);
     }
 
     vcs_assign("commit_signer", $commits, @signers);
+    vcs_assign("authored", $commits, @authors);
+    if ($#authors == $#stats) {
+	my $stat_pattern = $VCS_cmds{"stat_pattern"};
+	$stat_pattern =~ s/(\$\w+)/$1/eeg;	#interpolate $stat_pattern
+
+	my $added = 0;
+	my $deleted = 0;
+	for (my $i = 0; $i <= $#stats; $i++) {
+	    if ($stats[$i] =~ /$stat_pattern/) {
+		$added += $1;
+		$deleted += $2;
+	    }
+	}
+	my @tmp_authors = uniq(@authors);
+	foreach my $author (@tmp_authors) {
+	    $author = deduplicate_email($author);
+	}
+	@tmp_authors = uniq(@tmp_authors);
+	my @list_added = ();
+	my @list_deleted = ();
+	foreach my $author (@tmp_authors) {
+	    my $auth_added = 0;
+	    my $auth_deleted = 0;
+	    for (my $i = 0; $i <= $#stats; $i++) {
+		if ($author eq deduplicate_email($authors[$i]) &&
+		    $stats[$i] =~ /$stat_pattern/) {
+		    $auth_added += $1;
+		    $auth_deleted += $2;
+		}
+	    }
+	    for (my $i = 0; $i < $auth_added; $i++) {
+		push(@list_added, $author);
+	    }
+	    for (my $i = 0; $i < $auth_deleted; $i++) {
+		push(@list_deleted, $author);
+	    }
+	}
+	vcs_assign("added_lines", $added, @list_added);
+	vcs_assign("removed_lines", $deleted, @list_deleted);
+    }
 }
 
 sub vcs_file_blame {
@@ -1887,6 +1953,10 @@ sub vcs_file_blame {
     if ($email_git_blame_signatures) {
 	if (vcs_is_hg()) {
 	    my $commit_count;
+	    my $commit_authors_ref;
+	    my $commit_signers_ref;
+	    my $stats_ref;
+	    my @commit_authors = ();
 	    my @commit_signers = ();
 	    my $commit = join(" -r ", @commits);
 	    my $cmd;
@@ -1894,19 +1964,27 @@ sub vcs_file_blame {
 	    $cmd = $VCS_cmds{"find_commit_signers_cmd"};
 	    $cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
 
-	    ($commit_count, @commit_signers) = vcs_find_signers($cmd);
+	    ($commit_count, $commit_signers_ref, $commit_authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
+	    @commit_authors = @{$commit_authors_ref};
+	    @commit_signers = @{$commit_signers_ref};
 
 	    push(@signers, @commit_signers);
 	} else {
 	    foreach my $commit (@commits) {
 		my $commit_count;
+		my $commit_authors_ref;
+		my $commit_signers_ref;
+		my $stats_ref;
+		my @commit_authors = ();
 		my @commit_signers = ();
 		my $cmd;
 
 		$cmd = $VCS_cmds{"find_commit_signers_cmd"};
 		$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
 
-		($commit_count, @commit_signers) = vcs_find_signers($cmd);
+		($commit_count, $commit_signers_ref, $commit_authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
+		@commit_authors = @{$commit_authors_ref};
+		@commit_signers = @{$commit_signers_ref};
 
 		push(@signers, @commit_signers);
 	    }
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
devres-add-kernel-standard-devm_kalloc-functions.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
printk-mark-printk_once-test-variable-__read_mostly.patch
vsprintf-check-real-user-group-id-for-%pk.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch
checkpatch-make-the-memory-barrier-test-noisier.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
checkpatch-add-check-for-sscanf-without-return-use.patch
checkpatch-add-check-for-sscanf-without-return-use-v2.patch
drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch
drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch
kernel-modulec-use-pr_foo.patch
linux-next.patch
get_maintainerpl-incomplete-output.patch

