From: akpm@linux-foundation.org
Subject: +
 checkpatch-make-strict-a-default-for-files-in-drivers-net-and-net.patch
 added to -mm tree
Date: Wed, 07 May 2014 12:20:18 -0700
Message-ID: <536a8772.XVyCu23QimqoqQJA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaEGTUT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:20:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davem@davemloft.net, apw@canonical.com, joe@perches.com

Subject: + checkpatch-make-strict-a-default-for-files-in-drivers-net-and-net.patch added to -mm tree
To: joe@perches.com,apw@canonical.com,davem@davemloft.net
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:20:18 -0700


The patch titled
     Subject: checkpatch: make --strict a default for files in drivers/net and net/
has been added to the -mm tree.  Its filename is
     checkpatch-make-strict-a-default-for-files-in-drivers-net-and-net.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-make-strict-a-default-for-files-in-drivers-net-and-net.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-make-strict-a-default-for-files-in-drivers-net-and-net.patch

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
Subject: checkpatch: make --strict a default for files in drivers/net and net/

Networking files are generally more strictly conformant to linux-kernel
style so make checkpatch more verbose by default for patches to files or
when checking files in these directories.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-make-strict-a-default-for-files-in-drivers-net-and-net scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-make-strict-a-default-for-files-in-drivers-net-and-net
+++ a/scripts/checkpatch.pl
@@ -24,6 +24,7 @@ my $emacs = 0;
 my $terse = 0;
 my $file = 0;
 my $check = 0;
+my $check_orig = 0;
 my $summary = 1;
 my $mailback = 0;
 my $summary_file = 0;
@@ -146,6 +147,7 @@ GetOptions(
 help(0) if ($help);
 
 $fix = 1 if ($fix_inplace);
+$check_orig = $check;
 
 my $exit = 0;
 
@@ -1813,11 +1815,13 @@ sub process {
 		$here = "#$linenr: " if (!$file);
 		$here = "#$realline: " if ($file);
 
+		my $found_file = 0;
 		# extract the filename as it passes
 		if ($line =~ /^diff --git.*?(\S+)$/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@ if (!$file);
 			$in_commit_log = 0;
+			$found_file = 1;
 		} elsif ($line =~ /^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@ if (!$file);
@@ -1834,6 +1838,15 @@ sub process {
 				ERROR("MODIFIED_INCLUDE_ASM",
 				      "do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
 			}
+			$found_file = 1;
+		}
+
+		if ($found_file) {
+			if ($realfile =~ m@^(drivers/net/|net/)@) {
+				$check = 1;
+			} else {
+				$check = $check_orig;
+			}
 			next;
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
documentation-expand-clarify-debug-documentation.patch
maintainers-add-linux-api-for-review-of-api-abi-changes.patch
mm-utilc-add-kstrimdup.patch
checkpatch-fix-wildcard-dt-compatible-string-checking.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-improve-missing-blank-line-after-declarations-test.patch
checkpatch-make-strict-a-default-for-files-in-drivers-net-and-net.patch
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

