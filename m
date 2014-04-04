From: akpm@linux-foundation.org
Subject: [merged] checkpatch-avoid-sscanf-test-duplicated-messages.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:00 -0700
Message-ID: <533f0928.o4FRJb4/Zxv2e7kJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaDDTeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] checkpatch-avoid-sscanf-test-duplicated-messages.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:00 -0700


The patch titled
     Subject: checkpatch: avoid sscanf test duplicated messages
has been removed from the -mm tree.  Its filename was
     checkpatch-avoid-sscanf-test-duplicated-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: avoid sscanf test duplicated messages

Change a test of $dstat to $line to avoid possibly emitting the sscanf
warning multiple times.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-avoid-sscanf-test-duplicated-messages scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-avoid-sscanf-test-duplicated-messages
+++ a/scripts/checkpatch.pl
@@ -4188,7 +4188,7 @@ sub process {
 # check for naked sscanf
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
-		    $stat =~ /\bsscanf\b/ &&
+		    $line =~ /\bsscanf\b/ &&
 		    ($stat !~ /$Ident\s*=\s*sscanf\s*$balanced_parens/ &&
 		     $stat !~ /\bsscanf\s*$balanced_parens\s*(?:$Compare)/ &&
 		     $stat !~ /(?:$Compare)\s*\bsscanf\s*$balanced_parens/)) {
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

