From: akpm@linux-foundation.org
Subject: + checkpatch-ignore-email-headers-better.patch added to -mm tree
Date: Fri, 20 Jun 2014 15:16:11 -0700
Message-ID: <53a4b2ab.QDD9BHIz+e5GdxI+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046AbaFTWQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:16:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com


The patch titled
     Subject: checkpatch: Ignore email headers better
has been added to the -mm tree.  Its filename is
     checkpatch-ignore-email-headers-better.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-ignore-email-headers-better.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-ignore-email-headers-better.patch

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
Subject: checkpatch: Ignore email headers better

There are some patches created by git format-patch that when scanned by
checkpatch report errors on lines like

To:	address.tld

This is a checkpatch false positive.

Improve the logic a bit to ignore folded email headers to avoid emitting
these messages.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-ignore-email-headers-better scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-ignore-email-headers-better
+++ a/scripts/checkpatch.pl
@@ -1637,7 +1637,7 @@ sub process {
 	my $signoff = 0;
 	my $is_patch = 0;
 
-	my $in_header_lines = 1;
+	my $in_header_lines = $file ? 0 : 1;
 	my $in_commit_log = 0;		#Scanning lines before patch
 
 	my $non_utf8_charset = 0;
@@ -2001,7 +2001,8 @@ sub process {
 # Check if it's the start of a commit log
 # (not a header line and we haven't seen the patch filename)
 		if ($in_header_lines && $realfile =~ /^$/ &&
-		    $rawline !~ /^(commit\b|from\b|[\w-]+:).+$/i) {
+		    !($rawline =~ /^\s+\S/ ||
+		      $rawline =~ /^(commit\b|from\b|[\w-]+:).*$/i)) {
 			$in_header_lines = 0;
 			$in_commit_log = 1;
 		}
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-check-git-commit-descriptions.patch
checkpatch-reduce-false-positives-when-checking-void-function-return-statements.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
mm-utilc-add-kstrimdup.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch

