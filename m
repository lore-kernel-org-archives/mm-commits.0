From: akpm@linux-foundation.org
Subject: + checkpatch-add-a-few-device_attr-style-tests.patch added to -mm tree
Date: Wed, 20 Dec 2017 14:44:02 -0800
Message-ID: <5a3ae7b2.0tma5dk+6b8LN364%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38240 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751955AbdLTWoD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Dec 2017 17:44:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add a few DEVICE_ATTR style tests
has been added to the -mm tree.  Its filename is
     checkpatch-add-a-few-device_attr-style-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-a-few-device_attr-style-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-a-few-device_attr-style-tests.patch

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
Subject: checkpatch: add a few DEVICE_ATTR style tests

DEVICE_ATTR is a declaration macro that has a few alternate and preferred
forms like DEVICE_ATTR_RW, DEVICE_ATTR_RO, and DEVICE_ATTR.

As well, many uses of DEVICE_ATTR could use the preferred forms when the
show or store functions are also named in a regular form.

Suggest the preferred forms when appropriate.

Also emit a permissions warning if the the permissions are not the typical
0644, 0444, or 0200.

Link: http://lkml.kernel.org/r/725864f363d91d1e1e6894a39fb57662eabd6d65.1513803306.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  114 ++++++++++++++++++++++++++++++++--------
 1 file changed, 93 insertions(+), 21 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-a-few-device_attr-style-tests scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-a-few-device_attr-style-tests
+++ a/scripts/checkpatch.pl
@@ -566,6 +566,7 @@ foreach my $entry (@mode_permission_func
 	$mode_perms_search .= '|' if ($mode_perms_search ne "");
 	$mode_perms_search .= $entry->[0];
 }
+$mode_perms_search = "(?:${mode_perms_search})";
 
 our $mode_perms_world_writable = qr{
 	S_IWUGO		|
@@ -600,6 +601,37 @@ foreach my $entry (keys %mode_permission
 	$mode_perms_string_search .= '|' if ($mode_perms_string_search ne "");
 	$mode_perms_string_search .= $entry;
 }
+our $single_mode_perms_string_search = "(?:${mode_perms_string_search})";
+our $multi_mode_perms_string_search = qr{
+	${single_mode_perms_string_search}
+	(?:\s*\|\s*${single_mode_perms_string_search})*
+}x;
+
+sub perms_to_octal {
+	my ($string) = @_;
+
+	return trim($string) if ($string =~ /^\s*0[0-7]{3,3}\s*$/);
+
+	my $val = "";
+	my $oval = "";
+	my $to = 0;
+	my $curpos = 0;
+	my $lastpos = 0;
+	while ($string =~ /\b(($single_mode_perms_string_search)\b(?:\s*\|\s*)?\s*)/g) {
+		$curpos = pos($string);
+		my $match = $2;
+		my $omatch = $1;
+		last if ($lastpos > 0 && ($curpos - length($omatch) != $lastpos));
+		$lastpos = $curpos;
+		$to |= $mode_permission_string_types{$match};
+		$val .= '\s*\|\s*' if ($val ne "");
+		$val .= $match;
+		$oval .= $omatch;
+	}
+	$oval =~ s/^\s*\|\s*//;
+	$oval =~ s/\s*\|\s*$//;
+	return sprintf("%04o", $to);
+}
 
 our $allowed_asm_includes = qr{(?x:
 	irq|
@@ -6261,6 +6293,63 @@ sub process {
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
 
+# check for DEVICE_ATTR uses that could be DEVICE_ATTR_<FOO>
+# and whether or not function naming is typical and if
+# DEVICE_ATTR permissions uses are unusual too
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
+		    $stat =~ /\bDEVICE_ATTR\s*\(\s*(\w+)\s*,\s*\(?\s*(\s*(?:${multi_mode_perms_string_search}|0[0-7]{3,3})\s*)\s*\)?\s*,\s*(\w+)\s*,\s*(\w+)\s*\)/) {
+			my $var = $1;
+			my $perms = $2;
+			my $show = $3;
+			my $store = $4;
+			my $octal_perms = perms_to_octal($perms);
+			if ($show =~ /^${var}_show$/ &&
+			    $store =~ /^${var}_store$/ &&
+			    $octal_perms eq "0644") {
+				if (WARN("DEVICE_ATTR_RW",
+					 "Use DEVICE_ATTR_RW\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/\bDEVICE_ATTR\s*\(\s*$var\s*,\s*\Q$perms\E\s*,\s*$show\s*,\s*$store\s*\)/DEVICE_ATTR_RW(${var})/;
+				}
+			} elsif ($show =~ /^${var}_show$/ &&
+				 $store =~ /^NULL$/ &&
+				 $octal_perms eq "0444") {
+				if (WARN("DEVICE_ATTR_RO",
+					 "Use DEVICE_ATTR_RO\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/\bDEVICE_ATTR\s*\(\s*$var\s*,\s*\Q$perms\E\s*,\s*$show\s*,\s*NULL\s*\)/DEVICE_ATTR_RO(${var})/;
+				}
+			} elsif ($show =~ /^NULL$/ &&
+				 $store =~ /^${var}_store$/ &&
+				 $octal_perms eq "0200") {
+				if (WARN("DEVICE_ATTR_WO",
+					 "Use DEVICE_ATTR_WO\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/\bDEVICE_ATTR\s*\(\s*$var\s*,\s*\Q$perms\E\s*,\s*NULL\s*,\s*$store\s*\)/DEVICE_ATTR_WO(${var})/;
+				}
+			} elsif ($octal_perms eq "0644" ||
+				 $octal_perms eq "0444" ||
+				 $octal_perms eq "0200") {
+				my $newshow = "$show";
+				$newshow = "${var}_show" if ($show ne "NULL" && $show ne "${var}_show");
+				my $newstore = $store;
+				$newstore = "${var}_store" if ($store ne "NULL" && $store ne "${var}_store");
+				my $rename = "";
+				if ($show ne $newshow) {
+					$rename .= " '$show' to '$newshow'";
+				}
+				if ($store ne $newstore) {
+					$rename .= " '$store' to '$newstore'";
+				}
+				WARN("DEVICE_ATTR_FUNCTIONS",
+				     "Consider renaming function(s)$rename\n" . $herecurr);
+			} else {
+				WARN("DEVICE_ATTR_PERMS",
+				     "DEVICE_ATTR unusual permissions '$perms' used\n" . $herecurr);
+			}
+		}
+
 # Mode permission misuses where it seems decimal should be octal
 # This uses a shortcut match to avoid unnecessary uses of a slow foreach loop
 # o Ignore module_param*(...) uses with a decimal 0 permission as that has a
@@ -6305,30 +6394,13 @@ sub process {
 		}
 
 # check for uses of S_<PERMS> that could be octal for readability
-		if ($line =~ /\b$mode_perms_string_search\b/) {
-			my $val = "";
-			my $oval = "";
-			my $to = 0;
-			my $curpos = 0;
-			my $lastpos = 0;
-			while ($line =~ /\b(($mode_perms_string_search)\b(?:\s*\|\s*)?\s*)/g) {
-				$curpos = pos($line);
-				my $match = $2;
-				my $omatch = $1;
-				last if ($lastpos > 0 && ($curpos - length($omatch) != $lastpos));
-				$lastpos = $curpos;
-				$to |= $mode_permission_string_types{$match};
-				$val .= '\s*\|\s*' if ($val ne "");
-				$val .= $match;
-				$oval .= $omatch;
-			}
-			$oval =~ s/^\s*\|\s*//;
-			$oval =~ s/\s*\|\s*$//;
-			my $octal = sprintf("%04o", $to);
+		if ($line =~ /\b($multi_mode_perms_string_search)\b/) {
+			my $oval = $1;
+			my $octal = perms_to_octal($oval);
 			if (WARN("SYMBOLIC_PERMS",
 				 "Symbolic permissions '$oval' are not preferred. Consider using octal permissions '$octal'.\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$fixlinenr] =~ s/$val/$octal/;
+				$fixed[$fixlinenr] =~ s/\Q$oval\E/$octal/;
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-ignore-some-octal-permissions-of-0.patch
checkpatch-improve-quoted-string-and-line-continuation-test.patch
checkpatch-add-a-few-device_attr-style-tests.patch

