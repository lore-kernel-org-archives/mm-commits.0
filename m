From: akpm@linux-foundation.org
Subject: +
 checkpatch-dont-require-kernel-style-__attribute__-shortcuts-in-uapi-paths.patch added to -mm tree
Date: Mon, 11 Nov 2013 15:13:44 -0800
Message-ID: <528164a8.SFJUdx1a/UiiwjFY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3KKXNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 18:13:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ashutosh.dixit@intel.com, apw@canonical.com, joe@perches.com

Subject: + checkpatch-dont-require-kernel-style-__attribute__-shortcuts-in-uapi-paths.patch added to -mm tree
To: joe@perches.com,apw@canonical.com,ashutosh.dixit@intel.com
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 15:13:44 -0800


The patch titled
     Subject: checkpatch: don't require kernel style __attribute__ shortcuts in uapi paths
has been added to the -mm tree.  Its filename is
     checkpatch-dont-require-kernel-style-__attribute__-shortcuts-in-uapi-paths.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-dont-require-kernel-style-__attribute__-shortcuts-in-uapi-paths.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-dont-require-kernel-style-__attribute__-shortcuts-in-uapi-paths.patch

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
Subject: checkpatch: don't require kernel style __attribute__ shortcuts in uapi paths

Avoid proscribing kernel styled shortcuts for gcc extensions of
__attribute__((foo)) in the uapi include paths.

Fix $realfile filename when using -f/--file to not remove first level
directory as if the filename was used in a -P1 patch.  Only strip the
first level directory (typically a or b) for P1 patches.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "Dixit, Ashutosh" <ashutosh.dixit@intel.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-dont-require-kernel-style-__attribute__-shortcuts-in-uapi-paths scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-dont-require-kernel-style-__attribute__-shortcuts-in-uapi-paths
+++ a/scripts/checkpatch.pl
@@ -1769,11 +1769,11 @@ sub process {
 		# extract the filename as it passes
 		if ($line =~ /^diff --git.*?(\S+)$/) {
 			$realfile = $1;
-			$realfile =~ s@^([^/]*)/@@;
+			$realfile =~ s@^([^/]*)/@@ if (!$file);
 			$in_commit_log = 0;
 		} elsif ($line =~ /^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
-			$realfile =~ s@^([^/]*)/@@;
+			$realfile =~ s@^([^/]*)/@@ if (!$file);
 			$in_commit_log = 0;
 
 			$p1_prefix = $1;
@@ -3877,7 +3877,8 @@ sub process {
 		}
 
 # Check for __inline__ and __inline, prefer inline
-		if ($line =~ /\b(__inline__|__inline)\b/) {
+		if ($realfile !~ m@\binclude/uapi/@ &&
+		    $line =~ /\b(__inline__|__inline)\b/) {
 			if (WARN("INLINE",
 				 "plain inline is preferred over $1\n" . $herecurr) &&
 			    $fix) {
@@ -3887,19 +3888,22 @@ sub process {
 		}
 
 # Check for __attribute__ packed, prefer __packed
-		if ($line =~ /\b__attribute__\s*\(\s*\(.*\bpacked\b/) {
+		if ($realfile !~ m@\binclude/uapi/@ &&
+		    $line =~ /\b__attribute__\s*\(\s*\(.*\bpacked\b/) {
 			WARN("PREFER_PACKED",
 			     "__packed is preferred over __attribute__((packed))\n" . $herecurr);
 		}
 
 # Check for __attribute__ aligned, prefer __aligned
-		if ($line =~ /\b__attribute__\s*\(\s*\(.*aligned/) {
+		if ($realfile !~ m@\binclude/uapi/@ &&
+		    $line =~ /\b__attribute__\s*\(\s*\(.*aligned/) {
 			WARN("PREFER_ALIGNED",
 			     "__aligned(size) is preferred over __attribute__((aligned(size)))\n" . $herecurr);
 		}
 
 # Check for __attribute__ format(printf, prefer __printf
-		if ($line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf/) {
+		if ($realfile !~ m@\binclude/uapi/@ &&
+		    $line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf/) {
 			if (WARN("PREFER_PRINTF",
 				 "__printf(string-index, first-to-check) is preferred over __attribute__((format(printf, string-index, first-to-check)))\n" . $herecurr) &&
 			    $fix) {
@@ -3909,7 +3913,8 @@ sub process {
 		}
 
 # Check for __attribute__ format(scanf, prefer __scanf
-		if ($line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*scanf\b/) {
+		if ($realfile !~ m@\binclude/uapi/@ &&
+		    $line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*scanf\b/) {
 			if (WARN("PREFER_SCANF",
 				 "__scanf(string-index, first-to-check) is preferred over __attribute__((format(scanf, string-index, first-to-check)))\n" . $herecurr) &&
 			    $fix) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
vsprintf-check-real-user-group-id-for-%pk.patch
printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
get_maintainerpl-incomplete-output.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch
checkpatch-make-the-memory-barrier-test-noisier.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
checkpatch-improve-return-is-not-a-function-test.patch
checkpatch-dont-require-kernel-style-__attribute__-shortcuts-in-uapi-paths.patch
checkpatch-add-check-for-sscanf-without-return-use.patch
checkpatch-add-check-for-sscanf-without-return-use-v2.patch
drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch
drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch
kernel-modulec-use-pr_foo.patch
linux-next.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch

