From: akpm@linux-foundation.org
Subject: [merged] checkpatch-update-octal-permissions-warning.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:33:56 -0700
Message-ID: <533f0924.egwuvQcR/OnHBIja%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaDDTd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] checkpatch-update-octal-permissions-warning.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:56 -0700


The patch titled
     Subject: checkpatch: update octal permissions warning
has been removed from the -mm tree.  Its filename was
     checkpatch-update-octal-permissions-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: update octal permissions warning

When checking permissions, make sure 4 octal digits are used, but allow a
single 0 too.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-update-octal-permissions-warning scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-update-octal-permissions-warning
+++ a/scripts/checkpatch.pl
@@ -4512,9 +4512,11 @@ sub process {
 				my $val = $1;
 				$val = $6 if ($skip_args ne "");
 
-				if ($val =~ /^$Int$/ && $val !~ /^$Octal$/) {
+				if ($val !~ /^0$/ &&
+				    (($val =~ /^$Int$/ && $val !~ /^$Octal$/) ||
+				     length($val) ne 4)) {
 					ERROR("NON_OCTAL_PERMISSIONS",
-					      "Use octal not decimal permissions\n" . $herecurr);
+					      "Use 4 digit octal (0777) not decimal permissions\n" . $herecurr);
 				}
 			}
 		}
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

