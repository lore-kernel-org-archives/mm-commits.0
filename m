From: akpm@linux-foundation.org
Subject: + checkpatch-quiet-kconfig-help-message-checking.patch added to
 -mm tree
Date: Tue, 24 Jun 2014 14:32:51 -0700
Message-ID: <53a9ee83.SeunS1PGLs7DUVUr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaFXVcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 17:32:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jdelvare@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: quiet Kconfig help message checking
has been added to the -mm tree.  Its filename is
     checkpatch-quiet-kconfig-help-message-checking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-quiet-kconfig-help-message-checking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-quiet-kconfig-help-message-checking.patch

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
Subject: checkpatch: quiet Kconfig help message checking

Editing Kconfig dependencies can emit unnecessary messages about missing
or too short help entries.

Only emit the message when adding help sections to Kconfig files.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Jean Delvare <jdelvare@suse.de>
Tested-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-quiet-kconfig-help-message-checking scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-quiet-kconfig-help-message-checking
+++ a/scripts/checkpatch.pl
@@ -2060,7 +2060,7 @@ sub process {
 # Only applies when adding the entry originally, after that we do not have
 # sufficient context to determine whether it is indeed long enough.
 		if ($realfile =~ /Kconfig/ &&
-		    $line =~ /.\s*config\s+/) {
+		    $line =~ /^\+\s*config\s+/) {
 			my $length = 0;
 			my $cnt = $realcnt;
 			my $ln = $linenr + 1;
@@ -2073,10 +2073,11 @@ sub process {
 				$is_end = $lines[$ln - 1] =~ /^\+/;
 
 				next if ($f =~ /^-/);
+				last if (!$file && $f =~ /^\@\@/);
 
-				if ($lines[$ln - 1] =~ /.\s*(?:bool|tristate)\s*\"/) {
+				if ($lines[$ln - 1] =~ /^\+\s*(?:bool|tristate)\s*\"/) {
 					$is_start = 1;
-				} elsif ($lines[$ln - 1] =~ /.\s*(?:---)?help(?:---)?$/) {
+				} elsif ($lines[$ln - 1] =~ /^\+\s*(?:---)?help(?:---)?$/) {
 					$length = -1;
 				}
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
mm-utilc-add-kstrimdup.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch

