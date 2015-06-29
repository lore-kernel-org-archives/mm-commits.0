From: akpm@linux-foundation.org
Subject: [merged] checkpatch-colorize-output-to-terminal.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:48:41 -0700
Message-ID: <5591af29.0+4SkQrMqJhG2b2M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbbF2Usl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, pmladek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: colorize output to terminal
has been removed from the -mm tree.  Its filename was
     checkpatch-colorize-output-to-terminal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: colorize output to terminal

Add optional colors to make seeing message types a bit easier.

Add --color command line switch, default:on

Error is RED, warning is YELLOW, check is GREEN.  The message type, if
shown, is BLUE.

Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Petr Mladek <pmladek@suse.cz>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-colorize-output-to-terminal scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-colorize-output-to-terminal
+++ a/scripts/checkpatch.pl
@@ -9,6 +9,7 @@ use strict;
 use POSIX;
 use File::Basename;
 use Cwd 'abs_path';
+use Term::ANSIColor qw(:constants);
 
 my $P = $0;
 my $D = dirname(abs_path($P));
@@ -49,6 +50,7 @@ my $min_conf_desc_length = 4;
 my $spelling_file = "$D/spelling.txt";
 my $codespell = 0;
 my $codespellfile = "/usr/local/share/codespell/dictionary.txt";
+my $color = 1;
 
 sub help {
 	my ($exitcode) = @_;
@@ -93,6 +95,7 @@ Options:
   --codespell                Use the codespell dictionary for spelling/typos
                              (default:/usr/local/share/codespell/dictionary.txt)
   --codespellfile            Use this codespell dictionary
+  --color                    Use colors when output is STDOUT (default: on)
   -h, --help, --version      display this help and exit
 
 When FILE is - read standard input.
@@ -153,6 +156,7 @@ GetOptions(
 	'test-only=s'	=> \$tst_only,
 	'codespell!'	=> \$codespell,
 	'codespellfile=s'	=> \$codespellfile,
+	'color!'	=> \$color,
 	'h|help'	=> \$help,
 	'version'	=> \$help
 ) or help(1);
@@ -1672,15 +1676,26 @@ sub report {
 	    (defined $tst_only && $msg !~ /\Q$tst_only\E/)) {
 		return 0;
 	}
-	my $line;
+	my $output = '';
+	if (-t STDOUT && $color) {
+		if ($level eq 'ERROR') {
+			$output .= RED;
+		} elsif ($level eq 'WARNING') {
+			$output .= YELLOW;
+		} else {
+			$output .= GREEN;
+		}
+	}
+	$output .= $prefix . $level . ':';
 	if ($show_types) {
-		$line = "$prefix$level:$type: $msg\n";
-	} else {
-		$line = "$prefix$level: $msg\n";
+		$output .= BLUE if (-t STDOUT && $color);
+		$output .= "$type:";
 	}
-	$line = (split('\n', $line))[0] . "\n" if ($terse);
+	$output .= RESET if (-t STDOUT && $color);
+	$output .= ' ' . $msg . "\n";
+	$output = (split('\n', $output))[0] . "\n" if ($terse);
 
-	push(our @report, $line);
+	push(our @report, $output);
 
 	return 1;
 }
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

