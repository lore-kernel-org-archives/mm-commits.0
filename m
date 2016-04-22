From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-list-types-to-show-message-types-to-show-or-ignore.patch
 added to -mm tree
Date: Fri, 22 Apr 2016 14:36:15 -0700
Message-ID: <571a994f.daGJcoex13Rmds66%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbcDVVgQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 17:36:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --list-types to show message types to show or ignore
has been added to the -mm tree.  Its filename is
     checkpatch-add-list-types-to-show-message-types-to-show-or-ignore.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-list-types-to-show-message-types-to-show-or-ignore.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-list-types-to-show-message-types-to-show-or-ignore.patch

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
Subject: checkpatch: add --list-types to show message types to show or ignore

The message types are not currently knowable without reading the code.
Add a mechanism to see what they are.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-list-types-to-show-message-types-to-show-or-ignore scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-list-types-to-show-message-types-to-show-or-ignore
+++ a/scripts/checkpatch.pl
@@ -33,6 +33,7 @@ my $summary = 1;
 my $mailback = 0;
 my $summary_file = 0;
 my $show_types = 0;
+my $list_types = 0;
 my $fix = 0;
 my $fix_inplace = 0;
 my $root;
@@ -70,11 +71,12 @@ Options:
   --showfile                 emit diffed file position, not input file position
   -f, --file                 treat FILE as regular source file
   --subjective, --strict     enable more subjective tests
+  --list-types               list the possible message types
   --types TYPE(,TYPE2...)    show only these comma separated message types
   --ignore TYPE(,TYPE2...)   ignore various comma separated message types
+  --show-types               show the specific message type in the output
   --max-line-length=n        set the maximum line length, if exceeded, warn
   --min-conf-desc-length=n   set the min description length, if shorter, warn
-  --show-types               show the message "types" in the output
   --root=PATH                PATH to the kernel tree root
   --no-summary               suppress the per-file summary
   --mailback                 only produce a report in case of warnings/errors
@@ -106,6 +108,37 @@ EOM
 	exit($exitcode);
 }
 
+sub uniq {
+	my %seen;
+	return grep { !$seen{$_}++ } @_;
+}
+
+sub list_types {
+	my ($exitcode) = @_;
+
+	my $count = 0;
+
+	local $/ = undef;
+
+	open(my $script, '<', abs_path($P)) or
+	    die "$P: Can't read '$P' $!\n";
+
+	my $text = <$script>;
+	close($script);
+
+	my @types = ();
+	for ($text =~ /\b(?:(?:CHK|WARN|ERROR)\s*\(\s*"([^"]+)")/g) {
+		push (@types, $_);
+	}
+	@types = sort(uniq(@types));
+	print("#\tMessage type\n\n");
+	foreach my $type (@types) {
+		print(++$count . "\t" . $type . "\n");
+	}
+
+	exit($exitcode);
+}
+
 my $conf = which_conf($configuration_file);
 if (-f $conf) {
 	my @conf_args;
@@ -146,6 +179,7 @@ GetOptions(
 	'ignore=s'	=> \@ignore,
 	'types=s'	=> \@use,
 	'show-types!'	=> \$show_types,
+	'list-types!'	=> \$list_types,
 	'max-line-length=i' => \$max_line_length,
 	'min-conf-desc-length=i' => \$min_conf_desc_length,
 	'root=s'	=> \$root,
@@ -166,6 +200,8 @@ GetOptions(
 
 help(0) if ($help);
 
+list_types(0) if ($list_types);
+
 $fix = 1 if ($fix_inplace);
 $check_orig = $check;
 
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-prefer_is_enabled-test.patch
checkpatch-improve-constant_comparison-test-for-structure-members.patch
checkpatch-add-test-for-keywords-not-starting-on-tabstops.patch
checkpatch-whine-about-access_once.patch
checkpatch-advertise-the-fix-and-fix-inplace-options-more.patch
checkpatch-add-list-types-to-show-message-types-to-show-or-ignore.patch

