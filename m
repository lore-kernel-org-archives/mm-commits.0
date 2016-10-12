From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-the-octal-permissions-tests.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:23:31 -0700
Message-ID: <57fe8db3.Sx1CpaSGlGX6iLTz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33275 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755920AbcJLTYc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, roliveir@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve the octal permissions tests
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-the-octal-permissions-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve the octal permissions tests

The function calls with octal permissions commonly span multiple lines. 
The current test is line oriented and fails to find some matches.

Make the test use the $stat variable instead of the $line variable to span
multiple lines.

Also add a few functions to the known functions with permissions list.

Move the SYMBOLIC_PERMS test to a separate section to find all the S_<FOO>
permissions in any form not just those that have specific function names.

This can now find and fix permissions uses like:
     .mode = S_<FOO> | S_<BAR>;

Link: http://lkml.kernel.org/r/b51bab60530912aae4ac420119d465c5b206f19f.1475030406.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Ramiro Oliveira <roliveir@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   60 +++++++++++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 16 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-the-octal-permissions-tests scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-the-octal-permissions-tests
+++ a/scripts/checkpatch.pl
@@ -524,7 +524,11 @@ our @mode_permission_funcs = (
 	["module_param_array_named", 5],
 	["debugfs_create_(?:file|u8|u16|u32|u64|x8|x16|x32|x64|size_t|atomic_t|bool|blob|regset32|u32_array)", 2],
 	["proc_create(?:_data|)", 2],
-	["(?:CLASS|DEVICE|SENSOR)_ATTR", 2],
+	["(?:CLASS|DEVICE|SENSOR|SENSOR_DEVICE|IIO_DEVICE)_ATTR", 2],
+	["IIO_DEV_ATTR_[A-Z_]+", 1],
+	["SENSOR_(?:DEVICE_|)ATTR_2", 2],
+	["SENSOR_TEMPLATE(?:_2|)", 3],
+	["__ATTR", 2],
 );
 
 #Create a search pattern for all these functions to speed up a loop below
@@ -6092,45 +6096,69 @@ sub process {
 # Mode permission misuses where it seems decimal should be octal
 # This uses a shortcut match to avoid unnecessary uses of a slow foreach loop
 		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
 		    $line =~ /$mode_perms_search/) {
 			foreach my $entry (@mode_permission_funcs) {
 				my $func = $entry->[0];
 				my $arg_pos = $entry->[1];
 
+				my $lc = $stat =~ tr@\n@@;
+				$lc = $lc + $linenr;
+				my $stat_real = raw_line($linenr, 0);
+				for (my $count = $linenr + 1; $count <= $lc; $count++) {
+					$stat_real = $stat_real . "\n" . raw_line($count, 0);
+				}
+
 				my $skip_args = "";
 				if ($arg_pos > 1) {
 					$arg_pos--;
 					$skip_args = "(?:\\s*$FuncArg\\s*,\\s*){$arg_pos,$arg_pos}";
 				}
 				my $test = "\\b$func\\s*\\(${skip_args}($FuncArg(?:\\|\\s*$FuncArg)*)\\s*[,\\)]";
-				if ($line =~ /$test/) {
+				if ($stat =~ /$test/) {
 					my $val = $1;
 					$val = $6 if ($skip_args ne "");
 					if (($val =~ /^$Int$/ && $val !~ /^$Octal$/) ||
 					    ($val =~ /^$Octal$/ && length($val) ne 4)) {
 						ERROR("NON_OCTAL_PERMISSIONS",
-						      "Use 4 digit octal (0777) not decimal permissions\n" . $herecurr);
+						      "Use 4 digit octal (0777) not decimal permissions\n" . "$here\n" . $stat_real);
 					}
 					if ($val =~ /^$Octal$/ && (oct($val) & 02)) {
 						ERROR("EXPORTED_WORLD_WRITABLE",
-						      "Exporting writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
-					}
-					if ($val =~ /\b$mode_perms_string_search\b/) {
-						my $to = 0;
-						while ($val =~ /\b($mode_perms_string_search)\b(?:\s*\|\s*)?\s*/g) {
-							$to |=  $mode_permission_string_types{$1};
-						}
-						my $new = sprintf("%04o", $to);
-						if (WARN("SYMBOLIC_PERMS",
-							 "Symbolic permissions are not preferred. Consider using octal permissions $new.\n" . $herecurr) &&
-						    $fix) {
-							$fixed[$fixlinenr] =~ s/\Q$val\E/$new/;
-						}
+						      "Exporting writable files is usually an error. Consider more restrictive permissions.\n" . "$here\n" . $stat_real);
 					}
 				}
 			}
 		}
 
+# check for uses of S_<PERMS> that could be octal for readability
+		if ($line =~ /\b$mode_perms_string_search\b/) {
+			my $val = "";
+			my $oval = "";
+			my $to = 0;
+			my $curpos = 0;
+			my $lastpos = 0;
+			while ($line =~ /\b(($mode_perms_string_search)\b(?:\s*\|\s*)?\s*)/g) {
+				$curpos = pos($line);
+				my $match = $2;
+				my $omatch = $1;
+				last if ($lastpos > 0 && ($curpos - length($omatch) != $lastpos));
+				$lastpos = $curpos;
+				$to |= $mode_permission_string_types{$match};
+				$val .= '\s*\|\s*' if ($val ne "");
+				$val .= $match;
+				$oval .= $omatch;
+			}
+			$oval =~ s/^\s*\|\s*//;
+			$oval =~ s/\s*\|\s*$//;
+			my $octal = sprintf("%04o", $to);
+			if (WARN("SYMBOLIC_PERMS",
+				 "Symbolic permissions '$oval' are not preferred. Consider using octal permissions '$octal'.\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/$val/$octal/;
+			}
+		}
+
 # validate content of MODULE_LICENSE against list from include/linux/module.h
 		if ($line =~ /\bMODULE_LICENSE\s*\(\s*($String)\s*\)/) {
 			my $extracted_string = get_quoted_string($line, $rawline);
_

Patches currently in -mm which might be from joe@perches.com are


