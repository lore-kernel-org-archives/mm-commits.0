From: akpm@linux-foundation.org
Subject: + checkpatch-update-octal-permissions-warning.patch added to -mm
 tree
Date: Tue, 18 Feb 2014 14:50:05 -0800
Message-ID: <5303e39d.k6nnB3Nhzb5cEuO5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaBRWuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 17:50:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-update-octal-permissions-warning.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 14:50:05 -0800


The patch titled
     Subject: checkpatch: update octal permissions warning
has been added to the -mm tree.  Its filename is
     checkpatch-update-octal-permissions-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-update-octal-permissions-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-update-octal-permissions-warning.patch

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

drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch
drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

