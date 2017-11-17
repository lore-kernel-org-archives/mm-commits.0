From: akpm@linux-foundation.org
Subject: [patch 27/94] get_maintainer: add more --self-test options
Date: Fri, 17 Nov 2017 15:27:46 -0800
Message-ID: <20171117232746.O-qhmqmHH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55428 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423266AbdKQX1s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:27:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, tom.saeger@oracle.com, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: get_maintainer: add more --self-test options

Add tests for duplicate section headers, missing section content, link and
scm reachability.

Miscellanea:

o Add --self-test=<foo> options
  (a comma separated list of any of sections, patterns, links or scm)
  where the default without options is all tests
o Rename check_maintainers_patterns to self_test
o Rename self_test_pattern_info to self_test_info

[tom.saeger@oracle.com: improvements]
Link: http://lkml.kernel.org/r/13e3986c374902fcf08ae947e36c5c608bbe3b79.1510075301.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Tom Saeger <tom.saeger@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |  149 +++++++++++++++++++++++++++++++-----
 1 file changed, 132 insertions(+), 17 deletions(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-add-more-self-test-options scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-add-more-self-test-options
+++ a/scripts/get_maintainer.pl
@@ -57,7 +57,7 @@ my $sections = 0;
 my $file_emails = 0;
 my $from_filename = 0;
 my $pattern_depth = 0;
-my $self_test = 0;
+my $self_test = undef;
 my $version = 0;
 my $help = 0;
 my $find_maintainer_files = 0;
@@ -221,7 +221,7 @@ if (-f $ignore_file) {
 
 if ($#ARGV > 0) {
     foreach (@ARGV) {
-        if ($_ eq "-self-test" || $_ eq "--self-test") {
+        if ($_ =~ /^-{1,2}self-test(?:=|$)/) {
             die "$P: using --self-test does not allow any other option or argument\n";
         }
     }
@@ -263,7 +263,7 @@ if (!GetOptions(
 		'fe|file-emails!' => \$file_emails,
 		'f|file' => \$from_filename,
 		'find-maintainer-files' => \$find_maintainer_files,
-		'self-test' => \$self_test,
+		'self-test:s' => \$self_test,
 		'v|version' => \$version,
 		'h|help|usage' => \$help,
 		)) {
@@ -280,9 +280,9 @@ if ($version != 0) {
     exit 0;
 }
 
-if ($self_test) {
+if (defined $self_test) {
     read_all_maintainer_files();
-    check_maintainers_patterns();
+    self_test();
     exit 0;
 }
 
@@ -329,7 +329,7 @@ if (!top_of_kernel_tree($lk_path)) {
 my @typevalue = ();
 my %keyword_hash;
 my @mfiles = ();
-my @self_test_pattern_info = ();
+my @self_test_info = ();
 
 sub read_maintainer_file {
     my ($file) = @_;
@@ -339,6 +339,7 @@ sub read_maintainer_file {
     my $i = 1;
     while (<$maint>) {
 	my $line = $_;
+	chomp $line;
 
 	if ($line =~ m/^([A-Z]):\s*(.*)/) {
 	    my $type = $1;
@@ -353,17 +354,16 @@ sub read_maintainer_file {
 		if ((-d $value)) {
 		    $value =~ s@([^/])$@$1/@;
 		}
-		if ($self_test) {
-			push(@self_test_pattern_info, {file=>$file, line=>$line, linenr=>$i, pat=>$value});
-		}
 	    } elsif ($type eq "K") {
 		$keyword_hash{@typevalue} = $value;
 	    }
 	    push(@typevalue, "$type:$value");
 	} elsif (!(/^\s*$/ || /^\s*\#/)) {
-	    $line =~ s/\n$//g;
 	    push(@typevalue, $line);
 	}
+	if (defined $self_test) {
+	    push(@self_test_info, {file=>$file, linenr=>$i, line=>$line});
+	}
 	$i++;
     }
     close($maint);
@@ -614,17 +614,132 @@ if ($web) {
 
 exit($exit);
 
-sub check_maintainers_patterns {
+sub self_test {
     my @lsfiles = ();
+    my @good_links = ();
+    my @bad_links = ();
+    my @section_headers = ();
+    my $index = 0;
 
     @lsfiles = vcs_list_files($lk_path);
 
-    for my $x (@self_test_pattern_info) {
-        if (!grep(m@^$x->{pat}@, @lsfiles)) {
-            my $line = $x->{line};
-            chomp($line);
-            print("$x->{file}:$x->{linenr}: warning: no matches $line\n");
-        }
+    for my $x (@self_test_info) {
+	$index++;
+
+	## Section header duplication and missing section content
+	if (($self_test eq "" || $self_test =~ /\bsections\b/) &&
+	    $x->{line} =~ /^\S[^:]/ &&
+	    defined $self_test_info[$index] &&
+	    $self_test_info[$index]->{line} =~ /^([A-Z]):\s*\S/) {
+	    my $has_S = 0;
+	    my $has_F = 0;
+	    my $has_ML = 0;
+	    my $status = "";
+	    if (grep(m@^\Q$x->{line}\E@, @section_headers)) {
+		print("$x->{file}:$x->{linenr}: warning: duplicate section header\t$x->{line}\n");
+	    } else {
+		push(@section_headers, $x->{line});
+	    }
+	    my $nextline = $index;
+	    while (defined $self_test_info[$nextline] &&
+		   $self_test_info[$nextline]->{line} =~ /^([A-Z]):\s*(\S.*)/) {
+		my $type = $1;
+		my $value = $2;
+		if ($type eq "S") {
+		    $has_S = 1;
+		    $status = $value;
+		} elsif ($type eq "F" || $type eq "N") {
+		    $has_F = 1;
+		} elsif ($type eq "M" || $type eq "R" || $type eq "L") {
+		    $has_ML = 1;
+		}
+		$nextline++;
+	    }
+	    if (!$has_ML && $status !~ /orphan|obsolete/i) {
+		print("$x->{file}:$x->{linenr}: warning: section without email address\t$x->{line}\n");
+	    }
+	    if (!$has_S) {
+		print("$x->{file}:$x->{linenr}: warning: section without status \t$x->{line}\n");
+	    }
+	    if (!$has_F) {
+		print("$x->{file}:$x->{linenr}: warning: section without file pattern\t$x->{line}\n");
+	    }
+	}
+
+	next if ($x->{line} !~ /^([A-Z]):\s*(.*)/);
+
+	my $type = $1;
+	my $value = $2;
+
+	## Filename pattern matching
+	if (($type eq "F" || $type eq "X") &&
+	    ($self_test eq "" || $self_test =~ /\bpatterns\b/)) {
+	    $value =~ s@\.@\\\.@g;       ##Convert . to \.
+	    $value =~ s/\*/\.\*/g;       ##Convert * to .*
+	    $value =~ s/\?/\./g;         ##Convert ? to .
+	    ##if pattern is a directory and it lacks a trailing slash, add one
+	    if ((-d $value)) {
+		$value =~ s@([^/])$@$1/@;
+	    }
+	    if (!grep(m@^$value@, @lsfiles)) {
+		print("$x->{file}:$x->{linenr}: warning: no file matches\t$x->{line}\n");
+	    }
+
+	## Link reachability
+	} elsif (($type eq "W" || $type eq "Q" || $type eq "B") &&
+		 $value =~ /^https?:/ &&
+		 ($self_test eq "" || $self_test =~ /\blinks\b/)) {
+	    next if (grep(m@^\Q$value\E$@, @good_links));
+	    my $isbad = 0;
+	    if (grep(m@^\Q$value\E$@, @bad_links)) {
+	        $isbad = 1;
+	    } else {
+		my $output = `wget --spider -q --no-check-certificate --timeout 10 --tries 1 $value`;
+		if ($? == 0) {
+		    push(@good_links, $value);
+		} else {
+		    push(@bad_links, $value);
+		    $isbad = 1;
+		}
+	    }
+	    if ($isbad) {
+	        print("$x->{file}:$x->{linenr}: warning: possible bad link\t$x->{line}\n");
+	    }
+
+	## SCM reachability
+	} elsif ($type eq "T" &&
+		 ($self_test eq "" || $self_test =~ /\bscm\b/)) {
+	    next if (grep(m@^\Q$value\E$@, @good_links));
+	    my $isbad = 0;
+	    if (grep(m@^\Q$value\E$@, @bad_links)) {
+	        $isbad = 1;
+            } elsif ($value !~ /^(?:git|quilt|hg)\s+\S/) {
+		print("$x->{file}:$x->{linenr}: warning: malformed entry\t$x->{line}\n");
+	    } elsif ($value =~ /^git\s+(\S+)(\s+([^\(]+\S+))?/) {
+		my $url = $1;
+		my $branch = "";
+		$branch = $3 if $3;
+		my $output = `git ls-remote --exit-code -h "$url" $branch > /dev/null 2>&1`;
+		if ($? == 0) {
+		    push(@good_links, $value);
+		} else {
+		    push(@bad_links, $value);
+		    $isbad = 1;
+		}
+	    } elsif ($value =~ /^(?:quilt|hg)\s+(https?:\S+)/) {
+		my $url = $1;
+		my $output = `wget --spider -q --no-check-certificate --timeout 10 --tries 1 $url`;
+		if ($? == 0) {
+		    push(@good_links, $value);
+		} else {
+		    push(@bad_links, $value);
+		    $isbad = 1;
+		}
+	    }
+	    if ($isbad) {
+		print("$x->{file}:$x->{linenr}: warning: possible bad link\t$x->{line}\n");
+	    }
+	}
     }
 }
 
_
