From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-warning-for-kmalloc-kzalloc-with-multiply.patch removed from -mm tree
Date: Thu, 05 Jun 2014 13:05:47 -0700
Message-ID: <5390cd9b.HdVf9n3eUmz1/+Ne%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaFEUFr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, apw@canonical.com, joe@perches.com

Subject: [merged] checkpatch-add-warning-for-kmalloc-kzalloc-with-multiply.patch removed from -mm tree
To: joe@perches.com,apw@canonical.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:47 -0700


The patch titled
     Subject: checkpatch: add warning for kmalloc/kzalloc with multiply
has been removed from the -mm tree.  Its filename was
     checkpatch-add-warning-for-kmalloc-kzalloc-with-multiply.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add warning for kmalloc/kzalloc with multiply

Protect against sizeof overflows by preferring kmalloc_array/kcalloc over
kmalloc/kzalloc with a sizeof multiply.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-warning-for-kmalloc-kzalloc-with-multiply scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-warning-for-kmalloc-kzalloc-with-multiply
+++ a/scripts/checkpatch.pl
@@ -4378,6 +4378,30 @@ sub process {
 			    "Prefer $3(sizeof(*$1)...) over $3($4...)\n" . $herecurr);
 		}
 
+# check for k[mz]alloc with multiplies that could be kmalloc_array/kcalloc
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/) {
+			my $oldfunc = $3;
+			my $a1 = $4;
+			my $a2 = $10;
+			my $newfunc = "kmalloc_array";
+			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
+			if ($a1 =~ /^sizeof\s*\S/ || $a2 =~ /^sizeof\s*\S/) {
+				if (WARN("ALLOC_WITH_MULTIPLY",
+					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
+				    $fix) {
+					my $r1 = $a1;
+					my $r2 = $a2;
+					if ($a1 =~ /^sizeof\s*\S/) {
+						$r1 = $a2;
+						$r2 = $a1;
+					}
+					$fixed[$linenr - 1] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
+
+				}
+			}
+		}
+
 # check for krealloc arg reuse
 		if ($^V && $^V ge 5.10.0 &&
 		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*krealloc\s*\(\s*\1\s*,/) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch
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
maintainers-add-linux-api-for-review-of-api-abi-changes.patch

