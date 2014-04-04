From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-checks-for-constant-non-octal-permissions.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:33:54 -0700
Message-ID: <533f0922.CKk/qi2GkVL0YQg5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaDDTdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] checkpatch-add-checks-for-constant-non-octal-permissions.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:54 -0700


The patch titled
     Subject: checkpatch: add checks for constant non-octal permissions
has been removed from the -mm tree.  Its filename was
     checkpatch-add-checks-for-constant-non-octal-permissions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add checks for constant non-octal permissions

umode_t permissions are sometimes mistakenly written with decimal
constants.  Verify that numeric permissions are using octal.

Add a list of the most commonly used functions and macros that have
umode_t permissions and the argument position.

Add a $Octal type to $Constant.
Allow $LvalOrFunc to be a pointer indirection too.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-checks-for-constant-non-octal-permissions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-checks-for-constant-non-octal-permissions
+++ a/scripts/checkpatch.pl
@@ -289,11 +289,12 @@ our $Int_type	= qr{(?i)llu|ull|ll|lu|ul|
 our $Binary	= qr{(?i)0b[01]+$Int_type?};
 our $Hex	= qr{(?i)0x[0-9a-f]+$Int_type?};
 our $Int	= qr{[0-9]+$Int_type?};
+our $Octal	= qr{0[0-7]+$Int_type?};
 our $Float_hex	= qr{(?i)0x[0-9a-f]+p-?[0-9]+[fl]?};
 our $Float_dec	= qr{(?i)(?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?};
 our $Float_int	= qr{(?i)[0-9]+e-?[0-9]+[fl]?};
 our $Float	= qr{$Float_hex|$Float_dec|$Float_int};
-our $Constant	= qr{$Float|$Binary|$Hex|$Int};
+our $Constant	= qr{$Float|$Binary|$Octal|$Hex|$Int};
 our $Assignment	= qr{\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Arithmetic = qr{\+|-|\*|\/|%};
@@ -378,6 +379,15 @@ our @modifierList = (
 	qr{fastcall},
 );
 
+our @mode_permission_funcs = (
+	["module_param", 3],
+	["module_param_(?:array|named|string)", 4],
+	["module_param_array_named", 5],
+	["debugfs_create_(?:file|u8|u16|u32|u64|x8|x16|x32|x64|size_t|atomic_t|bool|blob|regset32|u32_array)", 2],
+	["proc_create(?:_data|)", 2],
+	["(?:CLASS|DEVICE|SENSOR)_ATTR", 2],
+);
+
 our $allowed_asm_includes = qr{(?x:
 	irq|
 	memory
@@ -423,7 +433,7 @@ our $Typecast	= qr{\s*(\(\s*$NonptrType\
 # Any use must be runtime checked with $^V
 
 our $balanced_parens = qr/(\((?:[^\(\)]++|(?-1))*\))/;
-our $LvalOrFunc	= qr{($Lval)\s*($balanced_parens{0,1})\s*};
+our $LvalOrFunc	= qr{((?:[\&\*]\s*)?$Lval)\s*($balanced_parens{0,1})\s*};
 our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};
 
 sub deparenthesize {
@@ -4473,6 +4483,28 @@ sub process {
 			WARN("EXPORTED_WORLD_WRITABLE",
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
+
+		foreach my $entry (@mode_permission_funcs) {
+			my $func = $entry->[0];
+			my $arg_pos = $entry->[1];
+
+			my $skip_args = "";
+			if ($arg_pos > 1) {
+				$arg_pos--;
+				$skip_args = "(?:\\s*$FuncArg\\s*,\\s*){$arg_pos,$arg_pos}";
+			}
+			my $test = "\\b$func\\s*\\(${skip_args}([\\d]+)\\s*[,\\)]";
+			if ($^V && $^V ge 5.10.0 &&
+			    $line =~ /$test/) {
+				my $val = $1;
+				$val = $6 if ($skip_args ne "");
+
+				if ($val =~ /^$Int$/ && $val !~ /^$Octal$/) {
+					ERROR("NON_OCTAL_PERMISSIONS",
+					      "Use octal not decimal permissions\n" . $herecurr);
+				}
+			}
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ntfs-logging-clean-up.patch
mm-utilc-add-kstrimdup.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

