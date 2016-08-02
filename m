From: akpm@linux-foundation.org
Subject: [patch 043/111] get_maintainer.pl: reduce need for command-line
 option -f
Date: Tue, 02 Aug 2016 14:04:10 -0700
Message-ID: <57a10aca.oAhHlwVcjHLGyEfC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbcHBVRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

From: Joe Perches <joe@perches.com>
Subject: get_maintainer.pl: reduce need for command-line option -f

If a vcs is used, look to see if the vcs tracks the file specified
and so the -f option becomes optional.

Link: http://lkml.kernel.org/r/7c86a8df0d48770c45778a43b6b3e4627b2a90ee.1469746395.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~get_maintainerpl-reduce-need-for-command-line-option-f scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainerpl-reduce-need-for-command-line-option-f
+++ a/scripts/get_maintainer.pl
@@ -133,6 +133,7 @@ my %VCS_cmds_git = (
     "author_pattern" => "^GitAuthor: (.*)",
     "subject_pattern" => "^GitSubject: (.*)",
     "stat_pattern" => "^(\\d+)\\t(\\d+)\\t\$file\$",
+    "file_exists_cmd" => "git ls-files \$file",
 );
 
 my %VCS_cmds_hg = (
@@ -161,6 +162,7 @@ my %VCS_cmds_hg = (
     "author_pattern" => "^HgAuthor: (.*)",
     "subject_pattern" => "^HgSubject: (.*)",
     "stat_pattern" => "^(\\d+)\t(\\d+)\t\$file\$",
+    "file_exists_cmd" => "hg files \$file",
 );
 
 my $conf = which_conf(".get_maintainer.conf");
@@ -430,7 +432,7 @@ foreach my $file (@ARGV) {
 	    die "$P: file '${file}' not found\n";
 	}
     }
-    if ($from_filename) {
+    if ($from_filename || vcs_file_exists($file)) {
 	$file =~ s/^\Q${cur_path}\E//;	#strip any absolute path
 	$file =~ s/^\Q${lk_path}\E//;	#or the path to the lk tree
 	push(@files, $file);
@@ -2124,6 +2126,22 @@ sub vcs_file_blame {
     }
 }
 
+sub vcs_file_exists {
+    my ($file) = @_;
+
+    my $exists;
+
+    my $vcs_used = vcs_exists();
+    return 0 if (!$vcs_used);
+
+    my $cmd = $VCS_cmds{"file_exists_cmd"};
+    $cmd =~ s/(\$\w+)/$1/eeg;		# interpolate $cmd
+
+    $exists = &{$VCS_cmds{"execute_cmd"}}($cmd);
+
+    return $exists;
+}
+
 sub uniq {
     my (@parms) = @_;
 
_
