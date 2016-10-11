From: akpm@linux-foundation.org
Subject: [patch 016/102] checkpatch: look for symbolic permissions and
 suggest octal instead
Date: Tue, 11 Oct 2016 13:51:47 -0700
Message-ID: <57fd50e3.5uLFyoNn900HWNOx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37873 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752298AbcJKUxE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

From: Joe Perches <joe@perches.com>
Subject: checkpatch: look for symbolic permissions and suggest octal instead

S_<FOO> uses should be avoided where octal is more intelligible.

Linus didst say:

: It's *much* easier to parse and understand the octal numbers, while the
: symbolic macro names are just random line noise and hard as hell to
: understand.  You really have to think about it.
: 
: So we should rather go the other way: convert existing bad symbolic
: permission bit macro use to just use the octal numbers.
: 
: The symbolic names are good for the *other* bits (ie sticky bit, and the
: inode mode _type_ numbers etc), but for the permission bits, the symbolic
: names are just insane crap.  Nobody sane should ever use them.  Not in the
: kernel, not in user space.
(http://lkml.kernel.org/r/CA+55aFw5v23T-zvDZp-MmD_EYxF8WbafwwB59934FV7g21uMGQ@mail.gmail.com)

Link: http://lkml.kernel.org/r/7232ef011d05a92f4caa86a5e9830d87966a2eaf.1470180926.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   49 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-look-for-symbolic-permissions-and-suggest-octal-instead scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-look-for-symbolic-permissions-and-suggest-octal-instead
+++ a/scripts/checkpatch.pl
@@ -541,6 +541,32 @@ our $mode_perms_world_writable = qr{
 	0[0-7][0-7][2367]
 }x;
 
+our %mode_permission_string_types = (
+	"S_IRWXU" => 0700,
+	"S_IRUSR" => 0400,
+	"S_IWUSR" => 0200,
+	"S_IXUSR" => 0100,
+	"S_IRWXG" => 0070,
+	"S_IRGRP" => 0040,
+	"S_IWGRP" => 0020,
+	"S_IXGRP" => 0010,
+	"S_IRWXO" => 0007,
+	"S_IROTH" => 0004,
+	"S_IWOTH" => 0002,
+	"S_IXOTH" => 0001,
+	"S_IRWXUGO" => 0777,
+	"S_IRUGO" => 0444,
+	"S_IWUGO" => 0222,
+	"S_IXUGO" => 0111,
+);
+
+#Create a search pattern for all these strings to speed up a loop below
+our $mode_perms_string_search = "";
+foreach my $entry (keys %mode_permission_string_types) {
+	$mode_perms_string_search .= '|' if ($mode_perms_string_search ne "");
+	$mode_perms_string_search .= $entry;
+}
+
 our $allowed_asm_includes = qr{(?x:
 	irq|
 	memory|
@@ -6003,20 +6029,31 @@ sub process {
 					$arg_pos--;
 					$skip_args = "(?:\\s*$FuncArg\\s*,\\s*){$arg_pos,$arg_pos}";
 				}
-				my $test = "\\b$func\\s*\\(${skip_args}([\\d]+)\\s*[,\\)]";
+				my $test = "\\b$func\\s*\\(${skip_args}($FuncArg(?:\\|\\s*$FuncArg)*)\\s*[,\\)]";
 				if ($line =~ /$test/) {
 					my $val = $1;
 					$val = $6 if ($skip_args ne "");
-
-					if ($val !~ /^0$/ &&
-					    (($val =~ /^$Int$/ && $val !~ /^$Octal$/) ||
-					     length($val) ne 4)) {
+					if (($val =~ /^$Int$/ && $val !~ /^$Octal$/) ||
+					    ($val =~ /^$Octal$/ && length($val) ne 4)) {
 						ERROR("NON_OCTAL_PERMISSIONS",
 						      "Use 4 digit octal (0777) not decimal permissions\n" . $herecurr);
-					} elsif ($val =~ /^$Octal$/ && (oct($val) & 02)) {
+					}
+					if ($val =~ /^$Octal$/ && (oct($val) & 02)) {
 						ERROR("EXPORTED_WORLD_WRITABLE",
 						      "Exporting writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 					}
+					if ($val =~ /\b$mode_perms_string_search\b/) {
+						my $to = 0;
+						while ($val =~ /\b($mode_perms_string_search)\b(?:\s*\|\s*)?\s*/g) {
+							$to |=  $mode_permission_string_types{$1};
+						}
+						my $new = sprintf("%04o", $to);
+						if (WARN("SYMBOLIC_PERMS",
+							 "Symbolic permissions are not preferred. Consider using octal permissions $new.\n" . $herecurr) &&
+						    $fix) {
+							$fixed[$fixlinenr] =~ s/\Q$val\E/$new/;
+						}
+					}
 				}
 			}
 		}
_
