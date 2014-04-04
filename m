From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-warn-on-uses-of-__constant_foo-functions.patch removed from -mm
 tree
Date: Fri, 04 Apr 2014 12:33:58 -0700
Message-ID: <533f0926.oAG9HjsRRcdwsbqx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaDDTd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sw@simonwunderlich.de, apw@canonical.com, joe@perches.com

Subject: [merged] checkpatch-warn-on-uses-of-__constant_foo-functions.patch removed from -mm tree
To: joe@perches.com,apw@canonical.com,sw@simonwunderlich.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:58 -0700


The patch titled
     Subject: checkpatch: warn on uses of __constant_<foo> functions
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-uses-of-__constant_foo-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

