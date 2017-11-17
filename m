From: akpm@linux-foundation.org
Subject: [patch 26/94] get_maintainer: add --self-test for internal
 consistency tests
Date: Fri, 17 Nov 2017 15:27:42 -0800
Message-ID: <20171117232742.DofVxGET7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55420 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423266AbdKQX1o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:27:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, tom.saeger@oracle.com, torvalds@linux-foundation.org

From: Tom Saeger <tom.saeger@oracle.com>
Subject: get_maintainer: add --self-test for internal consistency tests

Add "--self-test" option to get_maintainer.pl to show potential
issues in MAINTAINERS file(s) content.

Pattern check warnings are shown for "F" and "X" patterns found in
MAINTAINERS file(s) which do not match any files known by git.

Link: http://lkml.kernel.org/r/64994f911b3510d0f4c8ac2e113501dfcec1f3c9.1509559540.git.tom.saeger@oracle.com
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   96 +++++++++++++++++++++++++++++-------
 1 file changed, 78 insertions(+), 18 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-warn-about-invalid-maintainers-patterns scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-warn-about-invalid-maintainers-patterns
+++ a/scripts/get_maintainer.pl
@@ -57,6 +57,7 @@ my $sections = 0;
 my $file_emails = 0;
 my $from_filename = 0;
 my $pattern_depth = 0;
+my $self_test = 0;
 my $version = 0;
 my $help = 0;
 my $find_maintainer_files = 0;
@@ -138,6 +139,7 @@ my %VCS_cmds_git = (
     "subject_pattern" => "^GitSubject: (.*)",
     "stat_pattern" => "^(\\d+)\\t(\\d+)\\t\$file\$",
     "file_exists_cmd" => "git ls-files \$file",
+    "list_files_cmd" => "git ls-files \$file",
 );
 
 my %VCS_cmds_hg = (
@@ -167,6 +169,7 @@ my %VCS_cmds_hg = (
     "subject_pattern" => "^HgSubject: (.*)",
     "stat_pattern" => "^(\\d+)\t(\\d+)\t\$file\$",
     "file_exists_cmd" => "hg files \$file",
+    "list_files_cmd" => "hg manifest -R \$file",
 );
 
 my $conf = which_conf(".get_maintainer.conf");
@@ -216,6 +219,14 @@ if (-f $ignore_file) {
     close($ignore);
 }
 
+if ($#ARGV > 0) {
+    foreach (@ARGV) {
+        if ($_ eq "-self-test" || $_ eq "--self-test") {
+            die "$P: using --self-test does not allow any other option or argument\n";
+        }
+    }
+}
+
 if (!GetOptions(
 		'email!' => \$email,
 		'git!' => \$email_git,
@@ -252,6 +263,7 @@ if (!GetOptions(
 		'fe|file-emails!' => \$file_emails,
 		'f|file' => \$from_filename,
 		'find-maintainer-files' => \$find_maintainer_files,
+		'self-test' => \$self_test,
 		'v|version' => \$version,
 		'h|help|usage' => \$help,
 		)) {
@@ -268,6 +280,12 @@ if ($version != 0) {
     exit 0;
 }
 
+if ($self_test) {
+    read_all_maintainer_files();
+    check_maintainers_patterns();
+    exit 0;
+}
+
 if (-t STDIN && !@ARGV) {
     # We're talking to a terminal, but have no command line arguments.
     die "$P: missing patchfile or -f file - use --help if necessary\n";
@@ -311,12 +329,14 @@ if (!top_of_kernel_tree($lk_path)) {
 my @typevalue = ();
 my %keyword_hash;
 my @mfiles = ();
+my @self_test_pattern_info = ();
 
 sub read_maintainer_file {
     my ($file) = @_;
 
     open (my $maint, '<', "$file")
 	or die "$P: Can't open MAINTAINERS file '$file': $!\n";
+    my $i = 1;
     while (<$maint>) {
 	my $line = $_;
 
@@ -333,6 +353,9 @@ sub read_maintainer_file {
 		if ((-d $value)) {
 		    $value =~ s@([^/])$@$1/@;
 		}
+		if ($self_test) {
+			push(@self_test_pattern_info, {file=>$file, line=>$line, linenr=>$i, pat=>$value});
+		}
 	    } elsif ($type eq "K") {
 		$keyword_hash{@typevalue} = $value;
 	    }
@@ -341,6 +364,7 @@ sub read_maintainer_file {
 	    $line =~ s/\n$//g;
 	    push(@typevalue, $line);
 	}
+	$i++;
     }
     close($maint);
 }
@@ -357,26 +381,30 @@ sub find_ignore_git {
     return grep { $_ !~ /^\.git$/; } @_;
 }
 
-if (-d "${lk_path}MAINTAINERS") {
-    opendir(DIR, "${lk_path}MAINTAINERS") or die $!;
-    my @files = readdir(DIR);
-    closedir(DIR);
-    foreach my $file (@files) {
-	push(@mfiles, "${lk_path}MAINTAINERS/$file") if ($file !~ /^\./);
-    }
-}
+read_all_maintainer_files();
 
-if ($find_maintainer_files) {
-    find( { wanted => \&find_is_maintainer_file,
-	    preprocess => \&find_ignore_git,
-	    no_chdir => 1,
-	}, "${lk_path}");
-} else {
-    push(@mfiles, "${lk_path}MAINTAINERS") if -f "${lk_path}MAINTAINERS";
-}
+sub read_all_maintainer_files {
+    if (-d "${lk_path}MAINTAINERS") {
+        opendir(DIR, "${lk_path}MAINTAINERS") or die $!;
+        my @files = readdir(DIR);
+        closedir(DIR);
+        foreach my $file (@files) {
+            push(@mfiles, "${lk_path}MAINTAINERS/$file") if ($file !~ /^\./);
+        }
+    }
+
+    if ($find_maintainer_files) {
+        find( { wanted => \&find_is_maintainer_file,
+                preprocess => \&find_ignore_git,
+                no_chdir => 1,
+        }, "${lk_path}");
+    } else {
+        push(@mfiles, "${lk_path}MAINTAINERS") if -f "${lk_path}MAINTAINERS";
+    }
 
-foreach my $file (@mfiles) {
-    read_maintainer_file("$file");
+    foreach my $file (@mfiles) {
+        read_maintainer_file("$file");
+    }
 }
 
 #
@@ -586,6 +614,20 @@ if ($web) {
 
 exit($exit);
 
+sub check_maintainers_patterns {
+    my @lsfiles = ();
+
+    @lsfiles = vcs_list_files($lk_path);
+
+    for my $x (@self_test_pattern_info) {
+        if (!grep(m@^$x->{pat}@, @lsfiles)) {
+            my $line = $x->{line};
+            chomp($line);
+            print("$x->{file}:$x->{linenr}: warning: no matches $line\n");
+        }
+    }
+}
+
 sub ignore_email_address {
     my ($address) = @_;
 
@@ -863,6 +905,7 @@ Other options:
   --sections => print all of the subsystem sections with pattern matches
   --letters => print all matching 'letter' types from all matching sections
   --mailmap => use .mailmap file (default: $email_use_mailmap)
+  --self-test => show potential issues with MAINTAINERS file content
   --version => show version
   --help => show this help information
 
@@ -2192,6 +2235,23 @@ sub vcs_file_exists {
     return $exists;
 }
 
+sub vcs_list_files {
+    my ($file) = @_;
+
+    my @lsfiles = ();
+
+    my $vcs_used = vcs_exists();
+    return 0 if (!$vcs_used);
+
+    my $cmd = $VCS_cmds{"list_files_cmd"};
+    $cmd =~ s/(\$\w+)/$1/eeg;   # interpolate $cmd
+    @lsfiles = &{$VCS_cmds{"execute_cmd"}}($cmd);
+
+    return () if ($? != 0);
+
+    return @lsfiles;
+}
+
 sub uniq {
     my (@parms) = @_;
 
_
