From: akpm@linux-foundation.org
Subject: [folded-merged]
 checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch removed from -mm tree
Date: Mon, 05 May 2014 15:09:07 -0700
Message-ID: <53680c03.0t+dlYHW4BQumYnJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbaEEWJI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 18:09:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [folded-merged] checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 15:09:07 -0700


The patch titled
     Subject: checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix
has been removed from the -mm tree.  Its filename was
     checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch

This patch was dropped because it was folded into checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix

"struct foo *bar" does not match the regex "$Declare\s+$Ident"
$Declare matches "struct foo *" but there is no required space
between the pointer "*" and the $Ident.

Also it ends in a pointer, the $Declare variable also contains all
trailing spaces after the declaration so there is no space between
$Declare and $Ident.

ie:	"struct foo * bar" does not match "$Declare\s+$Ident"

So, change the \s+ to \s* to have this regex match any of
"struct foo bar", "struct foo *bar", and "struct foo * bar"
	
Signed-off-by: Joe Perches <joe@perches.com>	
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix
+++ a/scripts/checkpatch.pl
@@ -2275,7 +2275,7 @@ sub process {
 # check for missing blank lines after declarations
 		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
 			# actual declarations
-		    ($prevline =~ /^\+\s+$Declare\s+$Ident\s*[=,;\[]/ ||
+		    ($prevline =~ /^\+\s+$Declare\s*$Ident\s*[=,;\[]/ ||
 			# foo bar; where foo is some local typedef or #define
 		     $prevline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
@@ -2287,7 +2287,7 @@ sub process {
 			# not starting a section or a macro "\" extended line
 		      $prevline =~ /(?:\{\s*|\\)$/) &&
 			# looks like a declaration
-		    !($sline =~ /^\+\s+$Declare/ ||
+		    !($sline =~ /^\+\s+$Declare\s*$Ident\s*[=,;\[]/ ||
 			# foo bar; where foo is some local typedef or #define
 		      $sline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
_

Patches currently in -mm which might be from joe@perches.com are

mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-utilc-add-kstrimdup.patch
checkpatch-fix-wildcard-dt-compatible-string-checking.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-improve-missing-blank-line-after-declarations-test.patch
init-mainc-dont-use-pr_debug.patch
fs-isofs-logging-clean-up.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
tile-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
random-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
parport-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
scsi-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
coda-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fscache-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
lockd-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
inotify-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ntfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
key-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

