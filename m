From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-defines-ending-in-semicolon.patch added to
 -mm tree
Date: Fri, 09 May 2014 14:41:18 -0700
Message-ID: <536d4b7e.LSODhpnlZ7W78OXk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368AbaEIVlT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2014 17:41:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, bp@suse.de, joe@perches.com

Subject: + checkpatch-warn-on-defines-ending-in-semicolon.patch added to -mm tree
To: joe@perches.com,bp@suse.de
From: akpm@linux-foundation.org
Date: Fri, 09 May 2014 14:41:18 -0700


The patch titled
     Subject: checkpatch: warn on #defines ending in semicolon
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-defines-ending-in-semicolon.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-on-defines-ending-in-semicolon.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-on-defines-ending-in-semicolon.patch

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
Subject: checkpatch: warn on #defines ending in semicolon

Using a #define ending in a semicolon is poor style and can lead to
unexpected code paths being executed.

Warn on uses of these #define types:

	#define foo[(...)] bar;
	#define foo[(...)]	\
		bar;

Based on a patch from Borislav Petkov.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-defines-ending-in-semicolon scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-defines-ending-in-semicolon
+++ a/scripts/checkpatch.pl
@@ -3821,6 +3821,17 @@ sub process {
 					WARN("DO_WHILE_MACRO_WITH_TRAILING_SEMICOLON",
 					     "do {} while (0) macros should not be semicolon terminated\n" . "$herectx");
 				}
+			} elsif ($dstat =~ /^\+\s*#\s*define\s+$Ident.*;\s*$/) {
+				$ctx =~ s/\n*$//;
+				my $cnt = statement_rawlines($ctx);
+				my $herectx = $here . "\n";
+
+				for (my $n = 0; $n < $cnt; $n++) {
+					$herectx .= raw_line($linenr, $n) . "\n";
+				}
+
+				WARN("TRAILING_SEMICOLON",
+				     "macros should not use a trailing semicolon\n" . "$herectx");
 			}
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
checkpatch-warn-on-defines-ending-in-semicolon.patch
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

