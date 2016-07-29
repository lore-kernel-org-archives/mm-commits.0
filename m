From: akpm@linux-foundation.org
Subject: + get_maintainerpl-reduce-need-for-command-line-option-f.patch
 added to -mm tree
Date: Fri, 29 Jul 2016 16:21:35 -0700
Message-ID: <579be4ff.ZiGeHVX887JMplv/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbcG2XVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 19:21:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer.pl: reduce need for command-line option -f
has been added to the -mm tree.  Its filename is
     get_maintainerpl-reduce-need-for-command-line-option-f.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainerpl-reduce-need-for-command-line-option-f.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainerpl-reduce-need-for-command-line-option-f.patch

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

Patches currently in -mm which might be from joe@perches.com are

printk-create-pr_level-functions.patch
get_maintainerpl-reduce-need-for-command-line-option-f.patch
checkpatch-skip-long-lines-that-use-an-efi_guid-macro.patch
checkpatch-allow-c99-style-comments.patch
checkpatch-yet-another-commit-id-improvement.patch
checkpatch-improve-bare-use-of-signed-unsigned-types-warning.patch
rapidio-remove-unnecessary-0x-prefixes-before-%pa-extension-uses.patch

