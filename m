From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-uses-of-__constant_foo-functions.patch added to -mm tree
Date: Wed, 12 Feb 2014 13:53:17 -0800
Message-ID: <52fbed4d.mbd1lVUHD6wQ6Kok%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaBLVxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Feb 2014 16:53:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sw@simonwunderlich.de, apw@canonical.com, joe@perches.com

Subject: + checkpatch-warn-on-uses-of-__constant_foo-functions.patch added to -mm tree
To: joe@perches.com,apw@canonical.com,sw@simonwunderlich.de
From: akpm@linux-foundation.org
Date: Wed, 12 Feb 2014 13:53:17 -0800


The patch titled
     Subject: checkpatch: warn on uses of __constant_<foo> functions
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-uses-of-__constant_foo-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-on-uses-of-__constant_foo-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-on-uses-of-__constant_foo-functions.patch

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
Subject: checkpatch: warn on uses of __constant_<foo> functions

Emit a warning when using any of these __constant_<foo> forms:

	__constant_cpu_to_be[x]
	__constant_cpu_to_le[x]
	__constant_be[x]_to_cpu
	__constant_le[x]_to_cpu
	__constant_htons
	__constant_ntohs

Using any of these outside of include/uapi/ isn't preferred as using the
function without __constant_ is identical when the argument is a constant.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-uses-of-__constant_foo-functions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-uses-of-__constant_foo-functions
+++ a/scripts/checkpatch.pl
@@ -3931,6 +3931,19 @@ sub process {
 			}
 		}
 
+# don't use __constant_<foo> functions outside of include/uapi/
+		if ($realfile !~ m@^include/uapi/@ &&
+		    $line =~ /(__constant_(?:htons|ntohs|[bl]e(?:16|32|64)_to_cpu|cpu_to_[bl]e(?:16|32|64)))\s*\(/) {
+			my $constant_func = $1;
+			my $func = $constant_func;
+			$func =~ s/^__constant_//;
+			if (WARN("CONSTANT_CONVERSION",
+				 "$constant_func should be $func\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/\b$constant_func\b/$func/g;
+			}
+		}
+
 # prefer usleep_range over udelay
 		if ($line =~ /\budelay\s*\(\s*(\d+)\s*\)/) {
 			my $delay = $1;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch
drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

