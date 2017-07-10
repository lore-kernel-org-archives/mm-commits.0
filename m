From: akpm@linux-foundation.org
Subject: [patch 104/115] checkpatch: change format of --color
 argument to --color[=WHEN]
Date: Mon, 10 Jul 2017 15:52:24 -0700
Message-ID: <20170710225224.QaI-9NItw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43566 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754888AbdGJWw0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:52:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, john@fastquake.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: John Brooks <john@fastquake.com>
Subject: checkpatch: change format of --color argument to --color[=WHEN]

The boolean --color argument did not offer the ability to force colourized
output even if stdout is not a terminal.  Change the format of the
argument to the familiar --color[=WHEN] construct as seen in common Linux
utilities such as git, ls and dmesg, which allows the user to specify
whether to colourize output "always", "never", or "auto" when the output
is a terminal.  The default is "auto".

The old command-line uses of --color and --no-color are unchanged.

Link: http://lkml.kernel.org/r/efe43bdbad400f39ba691ae663044462493b0773.1496799721.git.joe@perches.com
Signed-off-by: John Brooks <john@fastquake.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-change-format-of-color-argument-to-color scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-change-format-of-color-argument-to-color
+++ a/scripts/checkpatch.pl
@@ -57,7 +57,7 @@ my $codespell = 0;
 my $codespellfile = "/usr/share/codespell/dictionary.txt";
 my $conststructsfile = "$D/const_structs.checkpatch";
 my $typedefsfile = "";
-my $color = 1;
+my $color = "auto";
 my $allow_c99_comments = 1;
 
 sub help {
@@ -116,7 +116,8 @@ Options:
                              (default:/usr/share/codespell/dictionary.txt)
   --codespellfile            Use this codespell dictionary
   --typedefsfile             Read additional types from this file
-  --color                    Use colors when output is STDOUT (default: on)
+  --color[=WHEN]             Use colors 'always', 'never', or only when output
+                             is a terminal ('auto'). Default is 'auto'.
   -h, --help, --version      display this help and exit
 
 When FILE is - read standard input.
@@ -182,6 +183,14 @@ if (-f $conf) {
 	unshift(@ARGV, @conf_args) if @conf_args;
 }
 
+# Perl's Getopt::Long allows options to take optional arguments after a space.
+# Prevent --color by itself from consuming other arguments
+foreach (@ARGV) {
+	if ($_ eq "--color" || $_ eq "-color") {
+		$_ = "--color=$color";
+	}
+}
+
 GetOptions(
 	'q|quiet+'	=> \$quiet,
 	'tree!'		=> \$tree,
@@ -212,7 +221,9 @@ GetOptions(
 	'codespell!'	=> \$codespell,
 	'codespellfile=s'	=> \$codespellfile,
 	'typedefsfile=s'	=> \$typedefsfile,
-	'color!'	=> \$color,
+	'color=s'	=> \$color,
+	'no-color'	=> \$color,	#keep old behaviors of -nocolor
+	'nocolor'	=> \$color,	#keep old behaviors of -nocolor
 	'h|help'	=> \$help,
 	'version'	=> \$help
 ) or help(1);
@@ -238,6 +249,18 @@ if ($#ARGV < 0) {
 	push(@ARGV, '-');
 }
 
+if ($color =~ /^[01]$/) {
+	$color = !$color;
+} elsif ($color =~ /^always$/i) {
+	$color = 1;
+} elsif ($color =~ /^never$/i) {
+	$color = 0;
+} elsif ($color =~ /^auto$/i) {
+	$color = (-t STDOUT);
+} else {
+	die "Invalid color mode: $color\n";
+}
+
 sub hash_save_array_words {
 	my ($hashRef, $arrayRef) = @_;
 
@@ -1883,7 +1906,7 @@ sub report {
 		return 0;
 	}
 	my $output = '';
-	if (-t STDOUT && $color) {
+	if ($color) {
 		if ($level eq 'ERROR') {
 			$output .= RED;
 		} elsif ($level eq 'WARNING') {
@@ -1894,10 +1917,10 @@ sub report {
 	}
 	$output .= $prefix . $level . ':';
 	if ($show_types) {
-		$output .= BLUE if (-t STDOUT && $color);
+		$output .= BLUE if ($color);
 		$output .= "$type:";
 	}
-	$output .= RESET if (-t STDOUT && $color);
+	$output .= RESET if ($color);
 	$output .= ' ' . $msg . "\n";
 
 	if ($showfile) {
_
