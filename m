From: akpm@linux-foundation.org
Subject: [merged]
 get_maintainer-add-commit-author-information-to-rolestats.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 11:01:01 -0800
Message-ID: <52e2b86d.jFA+6aZYMO3cFilY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] get_maintainer-add-commit-author-information-to-rolestats.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:01 -0800


The patch titled
     Subject: get_maintainer: add commit author information to --rolestats
has been removed from the -mm tree.  Its filename was
     get_maintainer-add-commit-author-information-to-rolestats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: get_maintainer: add commit author information to --rolestats

get_maintainer currently uses "Signed-off-by" style lines to find
interested parties to send patches to when the MAINTAINERS file does not
have a specific section entry with a matching file pattern.

Add statistics for commit authors and lines added and deleted to the
information provided by --rolestats.

These statistics are also emitted whenever --rolestats and --git are
selected even when there is a specified maintainer.

This can have the effect of expanding the number of people that are shown
as possible "maintainers" of a particular file because "authors",
"added_lines", and "removed_lines" are also used as criterion for the
--max-maintainers option separate from the "commit_signers".

The first "--git-max-maintainers" values of each criterion
are emitted.  Any "ties" are not shown.

For example: (forcedeth does not have a named maintainer)

Old output:

$ ./scripts/get_maintainer.pl -f drivers/net/ethernet/nvidia/forcedeth.c
"David S. Miller" <davem@davemloft.net> (commit_signer:8/10=80%)
Jiri Pirko <jiri@resnulli.us> (commit_signer:2/10=20%)
Patrick McHardy <kaber@trash.net> (commit_signer:2/10=20%)
Larry Finger <Larry.Finger@lwfinger.net> (commit_signer:1/10=10%)
Peter Zijlstra <peterz@infradead.org> (commit_signer:1/10=10%)
netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
linux-kernel@vger.kernel.org (open list)

New output:

$ ./scripts/get_maintainer.pl -f drivers/net/ethernet/nvidia/forcedeth.c
"David S. Miller" <davem@davemloft.net> (commit_signer:8/10=80%)
Jiri Pirko <jiri@resnulli.us> (commit_signer:2/10=20%,authored:2/10=20%,removed_lines:3/33=9%)
Patrick McHardy <kaber@trash.net> (commit_signer:2/10=20%,authored:2/10=20%,added_lines:12/95=13%,removed_lines:10/33=30%)
Larry Finger <Larry.Finger@lwfinger.net> (commit_signer:1/10=10%,authored:1/10=10%,added_lines:35/95=37%)
Peter Zijlstra <peterz@infradead.org> (commit_signer:1/10=10%)
"Peter Hüwe" <PeterHuewe@gmx.de> (authored:1/10=10%,removed_lines:15/33=45%)
Joe Perches <joe@perches.com> (authored:1/10=10%)
Neil Horman <nhorman@tuxdriver.com> (added_lines:40/95=42%)
Bill Pemberton <wfp5p@virginia.edu> (removed_lines:3/33=9%)
netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
linux-kernel@vger.kernel.org (open list)

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   91 +++++++++++++++++++++++++++++++++---
 1 file changed, 85 insertions(+), 6 deletions(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-add-commit-author-information-to-rolestats scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-add-commit-author-information-to-rolestats
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
+    "stat_pattern" => "^(\\d+)\\t(\\d+)\\t\$file\$",
 );
 
 my %VCS_cmds_hg = (
@@ -152,6 +156,7 @@ my %VCS_cmds_hg = (
     "blame_commit_pattern" => "^([ 0-9a-f]+):",
     "author_pattern" => "^HgAuthor: (.*)",
     "subject_pattern" => "^HgSubject: (.*)",
+    "stat_pattern" => "^(\\d+)\t(\\d+)\t\$file\$",
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
+    return (0, \@signatures, \@authors, \@stats) if !@signatures;
 
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
@@ -1858,13 +1879,59 @@ sub vcs_file_signoffs {
     my $cmd = $VCS_cmds{"find_signers_cmd"};
     $cmd =~ s/(\$\w+)/$1/eeg;		# interpolate $cmd
 
-    ($commits, @signers) = vcs_find_signers($cmd);
+    ($commits, $signers_ref, $authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
+
+    @signers = @{$signers_ref} if defined $signers_ref;
+    @authors = @{$authors_ref} if defined $authors_ref;
+    @stats = @{$stats_ref} if defined $stats_ref;
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
@@ -1887,6 +1954,10 @@ sub vcs_file_blame {
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
@@ -1894,19 +1965,27 @@ sub vcs_file_blame {
 	    $cmd = $VCS_cmds{"find_commit_signers_cmd"};
 	    $cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
 
-	    ($commit_count, @commit_signers) = vcs_find_signers($cmd);
+	    ($commit_count, $commit_signers_ref, $commit_authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
+	    @commit_authors = @{$commit_authors_ref} if defined $commit_authors_ref;
+	    @commit_signers = @{$commit_signers_ref} if defined $commit_signers_ref;
 
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
+		@commit_authors = @{$commit_authors_ref} if defined $commit_authors_ref;
+		@commit_signers = @{$commit_signers_ref} if defined $commit_signers_ref;
 
 		push(@signers, @commit_signers);
 	    }
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

